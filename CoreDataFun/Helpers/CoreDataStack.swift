//
//  CoreDataStack.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    static func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ()){
        let container = NSPersistentContainer(name: "Moody")
        
        container.loadPersistentStores { (_, error) in
            guard error == nil else { fatalError("Failed to load store: \(error!)") }
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }
}


protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [] //No sort descriptor by default
    }
    
    //Default implementation of the sorted fetchrequest
    static var sortedFetchRequest:NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

// Allow us to have a valid entity name by default, based on our NSManagedObject
extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name!
    }
}

extension Mood: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}

// - MARK: NSFetched Request related

