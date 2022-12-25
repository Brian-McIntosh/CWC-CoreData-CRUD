# This is a basic Core Data app that demonstrates fetching, saving and deleting data from persistent storage.

Starting App               |        Adding Data        |        Finished App
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://github.com/Brian-McIntosh/CWC-CoreData-CRUD/blob/main/images/1.png" width="300"/>  |  <img src="https://github.com/Brian-McIntosh/CWC-CoreData-CRUD/blob/main/images/2.png" width="300"/>  |  <img src="https://github.com/Brian-McIntosh/CWC-CoreData-CRUD/blob/main/images/3.png" width="300"/>

## First Step - Get a reference to the Managed Object Context
NOTE: You don't interact w/ the Persistent Container directly.
```swift
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
```

## Fetch from Core Data
```swift
    // fetch can throw an error
    do {
        self.items = try context.fetch(Person.fetchRequest())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    catch {
    }
```

## Save to Core Data
```swift
    do {
        try self.context.save()
    }
    catch {
    }
```

## Delete from Core Data
```swift
    self.context.delete(personToRemove)
```

## Filter results with NSPredicate
```swift
    // filtering requires parameters on the request, so separate the request
    let request = Person.fetchRequest() as NSFetchRequest<Person>

    // set the filtering on the request
    let predicate = NSPredicate(format: "name CONTAINS 'Tiger'") //%@ for dynamic data
    request.predicate = predicate

    self.items = try context.fetch(request)
```

## Sort results with NSSortDescriptor
```swift
    let request = Person.fetchRequest() as NSFetchRequest<Person>
            
    let sort = NSSortDescriptor(key: "name", ascending: true)
    request.sortDescriptors = [sort]

    self.items = try context.fetch(request)
```

## Miscellaneous Code Snippets
### Showing an Alert
```swift
    // Create alert
    let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
    alert.addTextField()

    // Configure button handler - background thread
    let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in

        // Get the textfield for the alert
        let textfield = alert.textFields![0]

        // Create a Person object
        // Person is a subclass of NSManagedObject which allows us to save to Core Data
        let newPerson = Person(context: self.context)
        newPerson.name = textfield.text

        // Save the data
        // try! self.context.save() // error w/o try! should use do/catch
        do {
            try self.context.save()
        }
        catch {

        }

        // Re-fetch the data
        // this function handles the context, fetchRequest, and reloading of tableview on main thread
        self.fetchPeople()
    }

    // Add button
    alert.addAction(submitButton)

    // Show alert
    self.present(alert, animated: true, completion: nil)
```

### Add Swipe and Delete Action
```swift
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // Which person to remove?
            let personToRemove = self.items![indexPath.row]
            
            // Delete the person from the context
            self.context.delete(personToRemove)
            
            // Save the data
            try! self.context.save() // DO/CATCH
            
            // Re-fetch the data
            self.fetchPeople()
        }
        
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
        
    }
```
