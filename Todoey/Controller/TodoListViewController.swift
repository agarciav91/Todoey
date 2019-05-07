//
//  ViewController.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 07/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray : [TodoDTO] = [TodoDTO]()
    
    // Data persistance
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Assigning the persisted data to our array
        if let items = defaults.array(forKey: "TodoListArray") as? [TodoDTO] {
            itemArray = items
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Adding and removing checkmarks on taps of the cells
//        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            itemArray[indexPath.row].isChecked = false
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            itemArray[indexPath.row].isChecked = true
//        }
        
        // Faster way
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        tableView.reloadData()
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
                let todoDTO = TodoDTO()
                todoDTO.todoItem = newItem.text!
                self.itemArray.append(todoDTO)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        // Showing the AlertDialog on Screen
        present(alert, animated: true, completion: nil)
    }
    
}

