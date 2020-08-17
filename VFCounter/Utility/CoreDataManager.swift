//
//  CoreDataManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/14.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataManagerType {
    case add, update, remove
}

class CoreDataManager {
    
    static var shared: CoreDataManager = CoreDataManager()

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VFCounter")
        container.loadPersistentStores(completionHandler: { (item, error) in
          
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        
        return container
    }()
    
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>, completed: @escaping (_ data: [T]) ->()) {
        do {
            let fetchResult = try self.context.fetch(request)
            completed(fetchResult)
            
        } catch {
            print(error.localizedDescription)
            completed([])
        }
    }
    
    func insertVeggies(veggies: Veggies) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Veggies", in: context)!
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(veggies.name, forKey: "name")
        managedObject.setValue(veggies.category, forKey: "category")
        managedObject.setValue(veggies.image, forKey: "imagedata")
//        managedObject.setValue(veggies.time, forKey: "time")
        managedObject.setValue(veggies.amount, forKey: "amount")
        
        
        do {
            try self.context.save()
            
            } catch {
        }
    }
    
    func insertFruits(fruits: Fruits) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Fruits", in: context)!
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(fruits.name, forKey: "name")
        managedObject.setValue(fruits.category, forKey: "category")
        managedObject.setValue(fruits.image, forKey: "imagedata")
//        managedObject.setValue(fruits.time, forKey: "time")
        managedObject.setValue(fruits.amount, forKey: "amount")
        
        do {
            try self.context.save()
            
            } catch {
        }
    }
    
    
    func delete(object: NSManagedObject) {
        context.delete(object)
        
        do {
            try self.context.save()
        } catch {
        }
        
    }
    
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try self.context.execute(delete)
            
        } catch {
            
        }
    }

    
    func sortEntity<T: NSManagedObject>(request: NSFetchRequest<T>, key: String, isAscending: Bool,
                                        completed: @escaping (Any) -> Void) {
        do {
            
            let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
            // recent data is top
            let sort = NSSortDescriptor(key: key, ascending: isAscending)
            request.sortDescriptors = [sort]
            let data = try context.fetch(request)
            completed(data)
        } catch {
            completed(error)
        }
    }
    
}
