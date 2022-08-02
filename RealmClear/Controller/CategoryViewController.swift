//
//  CategoryViewController.swift
//  RealmClear
//
//  Created by Joe Vargas on 8/1/22.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        
        loadCategories()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
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

            self.categories.append(newCategory)
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
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("DEBUG: Error fetching data from context \(error)")
//        }
        
        tableView.reloadData()
    }
}

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = ToDoListViewController()
//        destinationVC.selectedCategory = categories[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
