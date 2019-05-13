//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 10/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray : [Category] = [Category]()
    
    // Context for the SQLite DB
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedCategory = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Categories", for: indexPath)
        
        cell.textLabel?.text = selectedCategory.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategory = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            newCategory = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if (newCategory.text != "" && newCategory.text != nil) {
                let category = Category(context: self.context)
                category.name = newCategory.text!.capitalized
                self.categoryArray.append(category)
                
                self.saveCategories()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error Saving Data. \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error Fetching Data, \(error)")
        }
        
        tableView.reloadData()
    }
    
}
