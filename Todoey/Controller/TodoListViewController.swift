//
//  ViewController.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 07/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray : [TodoDTO] = [TodoDTO]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    // Data persistance
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath!)
        
        // Assigning the persisted data to our array
//        if let items = defaults.data(forKey: "TodoListArray") {
//            itemArray = items
//        }
        
        loadItems()
    }
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        // Creating a Cell to configure it with our data
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // Adding data to the cells in each row
        cell.textLabel?.text = item.todoItem
        
        // Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.isChecked ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Setting the size of the tableView
        return itemArray.count
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Method that triggers everytime a cell is tapped
//        print(itemArray[indexPath.row])
        
        // Adding and removing checkmarks on taps of the cells
//        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            itemArray[indexPath.row].isChecked = false
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            itemArray[indexPath.row].isChecked = true
//        }
        
        // Removing items from the SQLite DB (the order of this 2 lines matter)
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        // Faster way
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        // Saving all Updates in the SQLite DB
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        // Creating an AlertDialog
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // Adding a TextField to the AlertDialog
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        // Adding a button/action to the AlertDialog
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (newItem.text != "" && newItem.text != nil) {
                let todoDTO = TodoDTO(context: self.context)
                todoDTO.todoItem = newItem.text!
                todoDTO.isChecked = false
                todoDTO.parentCategory = self.selectedCategory
                self.itemArray.append(todoDTO)
                
                self.saveItems()
            }
        }
        
        alert.addAction(action)
        // Showing the AlertDialog on Screen
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation
    
    func saveItems() {
//        let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            print("Error Saving Data, \(error)")
//            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<TodoDTO> = TodoDTO.fetchRequest(), predicate : NSPredicate? = nil) {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//        let request : NSFetchRequest<TodoDTO> = TodoDTO.fetchRequest()
//            let decoder = PropertyListDecoder()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPreficate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPreficate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
            do {
                itemArray = try context.fetch(request)
//                itemArray = try decoder.decode([TodoDTO].self, from: data)
            } catch {
//                print("Error Decoding Item Array, \(error)")
                print("Error Fetching Data, \(error)")
            }
        
        tableView.reloadData()
        }
    
//  }
    
    
    
}

//MARK - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<TodoDTO> = TodoDTO.fetchRequest()
        let predicate = NSPredicate(format: "todoItem CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "todoItem", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
