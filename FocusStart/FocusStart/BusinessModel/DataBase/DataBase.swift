//
//  DataBase.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit
import CoreData

class DataBase {

    static var shared: DataBase = {
        let dataBase = DataBase()
        return dataBase
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func save() {
        if !persistentContainer.viewContext.hasChanges {
            return
        }

        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("error")
        }
    }

    func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
}
