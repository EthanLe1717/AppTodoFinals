//
//  TodoListTableViewController.swift
//  AppTodoFinals
//
//  Created by Bee on 9/17/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import UIKit
import CoreData


class TodoListTableViewController: UITableViewController {
    
    var todoItemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    
    
    //CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // loadItems()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListItems", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = todoItemArray[indexPath.row].title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = todoItemArray[indexPath.row].done == true ? .checkmark : .none
        
//        if todoItemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//
        return cell
    }
     // MARK: - Table view delegate
    // add checkmark when choose row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if todoItemArray[indexPath.row].done == false {
            todoItemArray[indexPath.row].done = true
        }else {
            todoItemArray[indexPath.row].done = false
        }
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new item for todo list
    
    
    @IBAction func AddItemTodoListPress(_ sender: UIBarButtonItem) {
        
        var textFieldItemsAdd = UITextField()
        let alertController = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            
            let newItems = Item(context: self.context)
            newItems.title = textFieldItemsAdd.text!
            newItems.done = false
            newItems.parentCategory = self.selectedCategory
            self.todoItemArray.append(newItems)
            
            // save array data to Dictionary
            self.saveItems()
            //self.tableView.reloadData()
            
            
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Items"
            textFieldItemsAdd = alertTextField
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    //MARK: - Save data in CoreData
    func saveItems (){
        do {
            try context.save()
           
        }catch {
            print(error.localizedDescription)
           
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Read data from coreData
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
         let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
            do {
              todoItemArray = try context.fetch(request)
            } catch{
                print(error.localizedDescription)
            }
        tableView.reloadData()
        }
    }

//MARK: - Search data from coreData
extension TodoListTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
       let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        
//        do {
//            todoItemArray = try context.fetch(request)
//        } catch{
//            print(error.localizedDescription)
//        }
//        tableView.reloadData()
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



