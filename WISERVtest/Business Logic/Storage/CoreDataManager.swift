//
//  CoreDataManager.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 21.10.2024.
//

import Foundation
import CoreData

public final class CoreDataManager {
    
    func addItem(viewContext: NSManagedObjectContext) {
        let newItem = Item(context: viewContext)
        newItem.date = Date()
        newItem.id = UUID()
        newItem.systolic = 100
        newItem.daistolic = 100
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
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
    
}
