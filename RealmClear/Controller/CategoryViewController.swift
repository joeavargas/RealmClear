//
//  CategoryViewController.swift
//  RealmClear
//
//  Created by Joe Vargas on 8/1/22.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        loadCategories()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavBarUI()
        setupTableViewUI()
    }
    
    // MARK: - UI Setup
    
    private func setupNavBarUI(){
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupTableViewUI(){
        tableView.separatorStyle = .none
    }
    
    // MARK: - Selector Functions
    
    @objc private func addButtonPressed(){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!

            self.save(newCategory)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Category name"
            textField = alertTextField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    private func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            //TODO: Handle error with UIAlertController and UIAlertAction
            print("DEBUG: Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    private func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(category)
                }
            } catch {
                //TODO: Handle error with UIAlertController and UIAlertAction
                print("DEBUG: Error deleting category", error.localizedDescription)
            }
        }
    }
}
// MARK: - TableView Delegate methods
extension CategoryViewController {
    
    //MARK: TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added"
        
        return cell
    }
    
    //MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = ToDoListViewController()
        destinationVC.selectedCategory = categories?[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
