//
//  CategoryViewController.swift
//  RealmClear
//
//  Created by Joe Vargas on 8/1/22.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        tableView.rowHeight = 80.0
        loadCategories()
        
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
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
            print("DEBUG: Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    private func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories"
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            print("DEBUG: Item deleted")
            
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write{
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("DEBUG: Error deleting category", error.localizedDescription)
                }
                
            }
        }

        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = ToDoListViewController()
        destinationVC.selectedCategory = categories?[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
