//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Virtual Machine on 20/10/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryArray = [Category]()
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: - IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if textField.text != "" {
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                
                self.categoryArray.append(newCategory)
                self.saveCategories()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Save and Load Functions
    func saveCategories(){
        do {
            //CONTEXT.SAVE É O COMMIT DO CORE DATA
            try context.save()
        } catch {
            print("Error Saving categories, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        //chamamos o context novamente pois ele que faz o crud e passamos o fetch com os dados que queremos
        do{
            categoryArray =  try context.fetch(request)
        }catch{
            print("Error loading categories, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func deleteCategory(with position: Int){
        let category = categoryArray[position]
        let deleteItemsFetch: NSFetchRequest<Item> = Item.fetchRequest()
        deleteItemsFetch.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)
        let deleteItemsRequest = NSBatchDeleteRequest(fetchRequest: deleteItemsFetch as! NSFetchRequest<NSFetchRequestResult>)
        
        let deleteCategoryFetch: NSFetchRequest<Category> = Category.fetchRequest()
        
        
        do{
            try context.execute(deleteItemsRequest)
            try context.save()
            
            deleteCategoryFetch.predicate = NSPredicate(format: "name MATCHES %@", category.name! as String)
            let deleteCategoryRequest = NSBatchDeleteRequest(fetchRequest: deleteCategoryFetch as! NSFetchRequest<NSFetchRequestResult>)
            
            try context.execute(deleteCategoryRequest)
            categoryArray.remove(at: position)
            try context.save()
            
        }catch{
            print("Error loading items, \(error)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //podemos pegar a celula que foi clicada na table view com esse comando
        if let indexPath = tableView.indexPathForSelectedRow {
            print(categoryArray[indexPath.row])
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
}

// MARK: - TableView DataSource Methods
extension CategoryViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
}

// MARK: - TableView Delegate Methods

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Remove") { (_,_,completionHandler) in
            DispatchQueue.main.async {
                print(indexPath.row)
                self.deleteCategory(with: indexPath.row)
                self.tableView.reloadData()
            }
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
