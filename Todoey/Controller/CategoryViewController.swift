//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 10/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray : Results<Category>?
    
    let realm = try! Realm()
    
    // Context for the SQLite DB
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Use super to refer to our Superclass
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colorHexValue) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategory = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if (newCategory.text != "" && newCategory.text != nil) {
                let category = Category()
                category.name = newCategory.text!.capitalized
                category.colorHexValue = RandomFlatColor().hexValue()
                
                self.saveCategories(category)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            newCategory = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation
    
    func saveCategories(_ category : Category) {
        do {
//            try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Data. \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error Fetching Data, \(error)")
//        }

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        // Used to also use the functionality of the super class
        super.updateModel(at: indexPath)
        
        if let item = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    // Deletes the specified Item
                    self.realm.delete(item)
                }
            } catch {
                print("Error Deleting Category, \(error)")
            }
        }
    }
    
}
