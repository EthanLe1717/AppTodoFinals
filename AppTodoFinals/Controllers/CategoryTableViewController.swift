//
//  CategoryTableViewController.swift
//  AppTodoFinals
//
//  Created by Bee on 9/18/18.
//  Copyright © 2018 Bee. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    //connection CoreData
   

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category add"
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()

    }
    
    func loadCategories(){
         categories = realm.objects(Category.self)
         tableView.reloadData()
        
    }
    
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        
         if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    

}
