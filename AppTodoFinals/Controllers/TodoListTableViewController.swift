//
//  TodoListTableViewController.swift
//  AppTodoFinals
//
//  Created by Bee on 9/17/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var todoItemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // loading data from library use encode and decode
        // encoder : Mã hoá  chính nó thành 1dạng dữ liệu có thể sử dụng ở bên ngoaif(JSON,plist)
        //decoder: Giải mã các dữ liệu bên ngoài thành dữ liệu sử dụng đc trong app.
        loadItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let newItems = Item()
            newItems.title = textFieldItemsAdd.text!
            self.todoItemArray.append(newItems)
            
            // save array data to Dictionary
            self.saveItems()
            self.tableView.reloadData()
            
            
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Items"
            textFieldItemsAdd = alertTextField
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    //MARK: Model Manupulation Method
    func saveItems (){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(todoItemArray)
            try data.write(to: dataFilePath!)
            
        }catch {
            print("Error encoding item array ,\(error)")
            
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                todoItemArray = try decoder.decode([Item].self, from: data)
                
            } catch{
                print(error.localizedDescription)
            }
        }
        
    }

}

