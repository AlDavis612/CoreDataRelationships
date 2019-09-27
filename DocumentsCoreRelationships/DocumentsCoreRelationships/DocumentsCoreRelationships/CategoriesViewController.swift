//
//  CategoriesViewController.swift
//  DocumentsCoreRelationships
//
//  Created by Alex Davis on 9/24/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var CategoriesTableView: UITableView!
    
     var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         title = "Categories"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FetchCategories(searchString: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func Add(_ sender: Any) {
        let alert = UIAlertController(title: "Add Category", message: "Please enter a new category name.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let name = textField.text {
                let categoryName = name.trimmingCharacters(in: .whitespaces)
                if (categoryName == "") {
                    self.alertNotifyUser(message: "Creation failed.")
                    return
                }
                self.AddCategory(name: categoryName)
            } else {
                self.alertNotifyUser(message: "Creation failed.")
                return
            }
            
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "category name"
            textField.isSecureTextEntry = false
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
   func edit(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let alert = UIAlertController(title: "Edit Category", message: "Please enter a new category name.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let name = textField.text {
                let categoryName = name.trimmingCharacters(in: .whitespaces)
                if (categoryName == "") {
                    self.alertNotifyUser(message: "Name change failed.")
                    return
                }
                
                if (categoryName == category.name) {
                    return
                }
                
                if (self.CategoryExists(name: categoryName)) {
                    self.alertNotifyUser(message: "Name change failed.")
                    return
                }
                
                self.UpdateCategory(at: indexPath, name: categoryName)
            } else {
                self.alertNotifyUser(message: "Name change failed.")
                return
            }
            
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "category name"
            textField.isSecureTextEntry = false
            textField.text = category.name
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func AddCategory(name: String) {
        if (CategoryExists(name: name)) {
            return
        }
        
        let category = Category(name: name)
        
        if let category = category {
            do {
                let managedObjectContext = category.managedObjectContext
                try managedObjectContext?.save()
            } catch {
                print("Category save failed.")
            }
        } else {
            print("Category creation failed.")
        }
        
        FetchCategories(searchString: "")
    }
    
    
    func CategoryExists(name: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, name != "" else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func FetchCategories(searchString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            if (searchString != "") {
                fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", searchString)
            }
            categories = try managedContext.fetch(fetchRequest)
            CategoriesTableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func ConfirmDeleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if let documentSet = category.document, documentSet.count > 0 {
            let name = category.name ?? "Category"
            let alert = UIAlertController(title: "Delete Category", message: "\(name) has documents in it. Are you sure?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alertAction) -> Void in
                self.CategoriesTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {
                (alertAction) -> Void in
                self.DeleteCategory(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            DeleteCategory(at: indexPath)
        }
    }
    
    func UpdateCategory(at indexPath: IndexPath, name: String) {
        let category = categories[indexPath.row]
        category.name = name
        
        if let managedObjectContext = category.managedObjectContext {
            do {
                try managedObjectContext.save()
                FetchCategories(searchString: "")
            } catch {
                print("Update failed.")
                CategoriesTableView.reloadData()
            }
        }
    }
    
    func DeleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if let managedObjectContext = category.managedObjectContext {
            managedObjectContext.delete(category)
            
            do {
                try managedObjectContext.save()
                self.categories.remove(at: indexPath.row)
                CategoriesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Delete failed.")
                CategoriesTableView.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentsViewController,
            let row = CategoriesTableView.indexPathForSelectedRow?.row {
            destination.category = categories[row]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.ConfirmDeleteCategory(at: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") {
            action, index in
            self.edit(at: indexPath)
        }
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    
}

