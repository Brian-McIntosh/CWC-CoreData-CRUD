//
//  ViewController.swift
//  CoreData-CRUD
//
//  Created by Brian McIntosh on 12/24/22.
//  

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Get a reference to managed object context
    // We use context to save, retrieve... we'll use it a lot
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var items: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get items from Core Data to display in our tableview
        //fetchPeople()
        //fetchPeopleWithFiltering()
        fetchPeopleWithSorting()
    }
    
    func fetchPeople() {
        /*
         note that fetch can throw
         fetch returns an array
         since it's a type method, we don't have to declare a new instance
         in a hurry, use try! as opposed to do/catch
        */
        do {
            self.items = try context.fetch(Person.fetchRequest())
            
            // b/c it's UI work
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {}
    }
    
    // MARK: - FILTERING
    func fetchPeopleWithFiltering() {
        do {
            // filtering requires parameters on the request, so separate the request
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            // set the filtering on the request
            let predicate = NSPredicate(format: "name CONTAINS 'Tiger'") //%@ for dynamic data
            request.predicate = predicate
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {}
    }
    
    // MARK: - SORTING
    func fetchPeopleWithSorting() {
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {}
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        // Create alert
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        // Configure button handler - background thread
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            // TODO: Create a Person object
            // Person is a subclass of NSManagedObject which allows us to save to Core Data
            let newPerson = Person(context: self.context)
            newPerson.name = textfield.text
            
            // TODO: Save the data
            // try! self.context.save() // error w/o try! should use do/catch
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            // TODO: Re-fetch the data
            // this function handles the context, fetchRequest, and reloading of tableview on main thread
            self.fetchPeople()
        }
        
        // Add button
        alert.addAction(submitButton)
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        // TODO: Get person from array and set the label
        let person = self.items![indexPath.row]
        
        //cell.textLabel?.text = "Placeholder"
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tappity tap tap")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // TODO: Which person to remove
            let personToRemove = self.items![indexPath.row]
            
            // TODO: Remove the person
            self.context.delete(personToRemove)
            
            // TODO: Save the data
            try! self.context.save() // DO/CATCH
            
            // TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
        
    }
}
