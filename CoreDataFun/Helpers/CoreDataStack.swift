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
    
    static func findOrCreate(in context: NSManagedObjectContext, matching predicate: NSPredicate, configure: (Self) -> ()) -> Self{
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject = context.insertObject(ofType: Self.self)
            configure(newObject) //Ouf ca. Permet de configurer l'objet avant de le retourner réellement
            return newObject
        }
        return object
        
    }
    
    static func fetch(in context: NSManagedObjectContext, configureBlock: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configureBlock(request)
        return try! context.fetch(request)
    }
    
    //Finding in memory first then fetch on SQLITE if needed, @Perf
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self?{
        guard let object = materializedObject(in: context, matching: predicate) else  {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }
    
    //Finding in memory an object matching the first object that match the given predicate
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        //Syntax trop cool !
        //We match only object that aren't in fault, because it could force CoreData to check in SQLITE for theses objects, for @Perf reason we ignore them
        for object in context.registeredObjects where !object.isFault {
            
            
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            
            return result
        }
        return nil
    }
    
}

extension Mood: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}

// - MARK: NSFetched Request related

