//
//  TodoListTableViewController.swift
//  AppTodoFinals
//
//  Created by Bee on 9/17/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class TodoListTableViewController: UITableViewController {
    
    var todoItemArray : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // loadItems()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItemArray?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListItems", for: indexPath)
        if let item = todoItemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Add"
        }

       
        return cell
    }
     // MARK: - Table view delegate
    // add checkmark when choose row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItemArray?[indexPath.row]{
            do {
                try realm.write {
                   // realm.delete(item)
                    item.done = !item.done
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new item for todo list
    
    
    @IBAction func AddItemTodoListPress(_ sender: UIBarButtonItem) {
        
        var textFieldItemsAdd = UITextField()
        let alertController = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    // save array data to Realm
                    try self.realm.write {
                        let newItems = Item()
                        newItems.title = textFieldItemsAdd.text!
                        newItems.dateCreated = Date()
                        currentCategory.items.append(newItems)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            self.tableView.reloadData()
            
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Items"
            textFieldItemsAdd = alertTextField
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Read data from Realm
    
    func loadItems(){
        todoItemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true )
        
        tableView.reloadData()
        }
    }

//MARK: - Search data from Realm
extension TodoListTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItemArray = todoItemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
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



