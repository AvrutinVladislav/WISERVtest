//
//  CoreDataManager.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import SwiftUI
import CoreData

public final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    init() {}
    
    func fetchData() -> Result<[PressureModel], CoreDataError> {
        let context = persistentContainer.viewContext
        
        do {
            let item = try context.fetch(PressureModel.fetchRequest())
            return .success(item)
        } catch {
            return .failure(.fetch)
        }
    }
    
    func addItem(systolic: Int16, diastolic: Int16, pulse: Int16, date: Date?, note: String?) {
        let context = persistentContainer.viewContext
        let newItem = Item(context: context)
        newItem.date = date
        newItem.id = UUID().uuidString
        newItem.systolic = systolic
        newItem.daistolic = diastolic
        newItem.pulse = pulse
        newItem.note = note
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения записи: \(error.localizedDescription)")
        }
    }
    
    
    func deleteItems(offsets: IndexSet, viewContext: NSManagedObjectContext, items: [Item]) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "WISERVtest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

enum CoreDataError: Error {
    case fetch
    case fetchById
    case fillFromJson
    case update
    case create
    case delete
    
    var errorDescription: String {
        switch self {
        case .fetch:
            return "Error fetch data from DB"
        case .fetchById:
            return "Error fetch data from DB by id"
        case .update:
            return "Error to update DB"
        case .create:
            return "Error save bew todo in DB"
        case .delete:
            return "Error delete todo from DB"
        case .fillFromJson:
            return "Error fetch data when load from json"
        }
    }
}

