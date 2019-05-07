//
//  ViewController.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 07/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating a Cell to configure it with our data
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // Adding data to the cells in each row
        cell.textLabel?.text = itemArray[indexPath.row]
        
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
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
                self.itemArray.append(newItem.text!)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        // Showing the AlertDialog on Screen
        present(alert, animated: true, completion: nil)
    }
    
}

