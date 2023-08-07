//
//  SearchHistiryManager.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import CoreData
import Foundation

final class SearchHistiryManager {
  
  static let sharedManager = SearchHistiryManager()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "SearchHistory")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func save(query: String) {
    guard query.isEmpty == false else { return }
    
    let entity = NSEntityDescription.entity(forEntityName: "QueryItem", in: persistentContainer.viewContext)!
    let queryItem = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as! QueryItem
    queryItem.query = query
    queryItem.date = Date()
    
    do {
      try persistentContainer.viewContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  func fetchQueries() -> [QueryItem] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "QueryItem")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    let items = try? persistentContainer.viewContext.fetch(fetchRequest) as? [QueryItem]
    
    return items ?? []
  }
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
