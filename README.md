## Core Data First Step - get a reference to the Managed Object Context
NOTE: You don't interact w/ the Persistent Container directly.

https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#code
```swift
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
```

## Fetch from Core Data
```swift
    self.items = try context.fetch(Person.fetchRequest())
```

## Save to Core Data
```swift
    try self.context.save()
```

## Delete from Core Data
```swift
    self.context.delete(personToRemove)
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
```

### Add Swipe Action
```swift
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
```


