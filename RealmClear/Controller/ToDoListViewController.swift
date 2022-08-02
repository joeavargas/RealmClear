//
//  ToDoListViewController.swift
//  RealmClear
//
//  Created by Joe Vargas on 8/1/22.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    var items: Results<Item>?
    let realm = try! Realm()
    let searchBar: UISearchBar = UISearchBar()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarUI()
        setupTableViewUI()
        setupFloatingAddButton()
        showSearchBarButton(shouldShow: true)
    }
    

    // MARK: - UI Setup
    
    private func setupFloatingAddButton() {
        
        let floatingAddButton = UIButton()
        floatingAddButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingAddButton.backgroundColor = .systemBlue
        floatingAddButton.tintColor = .white
        floatingAddButton.layer.cornerRadius = 25
        
        floatingAddButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        floatingAddButton.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        floatingAddButton.layer.shadowOpacity = 1.0
        floatingAddButton.layer.shadowRadius = 10.0
        floatingAddButton.layer.masksToBounds = false
        
        view.addSubview(floatingAddButton)
        floatingAddButton.translatesAutoresizingMaskIntoConstraints = false
        
        floatingAddButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingAddButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingAddButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -40).isActive = true
        floatingAddButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -20).isActive = true
        
        floatingAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    private func setupNavBarUI(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.title = selectedCategory?.name
    }
    
    private func setupTableViewUI(){
        tableView.separatorStyle = .none
    }
    
    // MARK: - Selector Functions
    @objc private func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item?", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    //TODO: Handle error with UIAlertController and UIAlertAction
                    print("DEBUG: Error saving item", error.localizedDescription)
                }
                
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func searchButtonPressed() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Helper Functions

    private func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.items?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(item)
                }
            } catch  {
                //TODO: Handle error with UIAlertController and UIAlertAction
                print("DEBUG: Error deleting item", error.localizedDescription)
            }
        }
    }
    
    private func showSearchBarButton(shouldShow: Bool) {
        navigationItem.rightBarButtonItem = shouldShow ? UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed)) : nil
    }
    
    private func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
}
// MARK: - TableView Delegate methods
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark :  .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                    
                    // Uncomment the following line if you wish to remove the item completely instead of marking it when a checkmark
                    //realm.delete(item)
                }
            } catch  {
                //TODO: Handle error with UIAlertController and UIAlertAction
                print("DEBUG: Error updating item", error.localizedDescription)
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - SearchBar Delegate methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Accending 'true' will put recently entered items at the bottom
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        if searchBar.text?.count == 0 {
            loadItems()
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        search(shouldShow: false)
        searchBar.text = ""
    }
    
}
