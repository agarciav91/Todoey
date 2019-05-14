//
//  ViewController.swift
//  Todoey
//
//  Created by Andres Garcia Vega on 07/05/2019.
//  Copyright © 2019 Andres Garcia Vega. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<TodoDTO>?
    let realm = try! Realm()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        
//        print(dataFilePath!)
        
        // Assigning the persisted data to our array
//        if let items = defaults.data(forKey: "TodoListArray") {
//            todoItems = items
//        }
        
//        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colorHexValue else { fatalError() }
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) { updateNavBar(withHexCode: "1D9BF6") }
    
    //MARK - NavBar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Setting the size of the tableView
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creating a Cell to configure it with our data
        // Use super to refer to our Superclass
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            // Adding data to the cells in each row
            cell.textLabel?.text = item.todoItem

            if let colour = UIColor(hexString: selectedCategory!.colorHexValue)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            // Ternary Operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.isChecked ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Method that triggers everytime a cell is tapped
//        print(todoItems[indexPath.row])
        
        // Adding and removing checkmarks on taps of the cells
//        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            todoItems[indexPath.row].isChecked = false
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            todoItems[indexPath.row].isChecked = true
//        }
        
        // Removing items from the SQLite DB (the order of this 2 lines matter)
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)

        // Faster way
//        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
//
//        // Saving all Updates in the SQLite DB
//        saveItems()
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isChecked = !item.isChecked
                    // Deletes the specified Item
//                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let todoDTO = TodoDTO()
                            todoDTO.todoItem = newItem.text!
                            todoDTO.dateCreated = Date()
                            //                todoDTO.isChecked = false
                            //                todoDTO.parentCategory = selectedCategory!
                            currentCategory.todoItems.append(todoDTO)
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Error Saving Data. \(error)")
                    }
                }
                
//                self.saveItems()
            }
        }
        
        alert.addAction(action)
        // Showing the AlertDialog on Screen
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation
    
//    func saveItems() {
////        let encoder = PropertyListEncoder()
//        do {
////            let data = try encoder.encode(todoItems)
////            try data.write(to: dataFilePath!)
//            try context.save()
//        } catch {
//            print("Error Saving Data, \(error)")
////            print("Error encoding item array, \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    
    func loadItems() {
        
        // Realm DB
        todoItems = selectedCategory?.todoItems.sorted(byKeyPath: "todoItem", ascending: true)
        
        // CoreData DB
//        if let data = try? Data(contentsOf: dataFilePath!) {
//        let request : NSFetchRequest<TodoDTO> = TodoDTO.fetchRequest()
//            let decoder = PropertyListDecoder()

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPreficate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPreficate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
//
//            do {
//                todoItems = try context.fetch(request)
////                itemArray = try decoder.decode([TodoDTO].self, from: data)
//            } catch {
////                print("Error Decoding Item Array, \(error)")
//                print("Error Fetching Data, \(error)")
//            }

        tableView.reloadData()
        }
    
    override func updateModel(at indexPath: IndexPath) {
        
        // Used to also use the functionality of the super class
        super.updateModel(at: indexPath)
        
        if let item = self.todoItems?[indexPath.row] {
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

//MARK - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Realm DB
        todoItems = todoItems?.filter("todoItem CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        // CoreData DB
//        let request : NSFetchRequest<TodoDTO> = TodoDTO.fetchRequest()
//        let predicate = NSPredicate(format: "todoItem CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "todoItem", ascending: true)]
//        loadItems(with: request, predicate: predicate)
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
