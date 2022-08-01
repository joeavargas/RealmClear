//
//  ToDoListViewController.swift
//  RealmClear
//
//  Created by Joe Vargas on 8/1/22.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
//    var itemsArray = [Item]()
    let searchBar: UISearchBar = UISearchBar()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var selectedCategory: Category? {
//        didSet {
//            loadItems()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarUI()
        setupTableViewUI()
        setupFloatingAddButton()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")

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
        
    }
    
    private func setupTableViewUI(){
        
    }
    
    // MARK: - Selector Functions
    @objc private func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item?", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.isDone = false
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemsArray.append(newItem)
            self.saveItems()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func searchButtonPressed() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Helper Functions
    private func saveItems() {
        
        do {
//            try context.save()
        } catch {
            print("DEBUG: Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
//    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemsArray = try context.fetch(request)
//        } catch {
//            print("DEBUG: Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
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
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
//            let item = itemsArray[indexPath.row]
//            cell.textLabel?.text = item.title
//            cell.accessoryType = item.isDone ? .checkmark :  .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            itemsArray[indexPath.row].isDone.toggle()
        
        saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - SearchBar Delegate methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.predicate = predicate
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: request, predicate: predicate)
//
//            if searchBar.text?.count == 0 {
//                loadItems()
//            }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//            loadItems()
        search(shouldShow: false)
        searchBar.text = ""
    }
    
}
