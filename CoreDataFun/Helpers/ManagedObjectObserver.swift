//
//  ManagedObjectObserver.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

//Super cool à garder ever ! 
final class ManagedObjectObserver {
    
    enum ChangeType {
        case delete
        case update
    }
    
    fileprivate var token: NSObjectProtocol! //An opaque object to act as the observer
    
    init?(object: NSManagedObject, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else { return nil }
        
        token = moc.addObjectsDidChangeNotificationObserver({ [weak self] note in
            guard let changeType = self?.changeType(of: object, in: note) else { return }
            changeHandler(changeType)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token)
    }
    
    fileprivate func changeType(of object: NSManagedObject, in note: ObjectsDidChangeNotification) -> ChangeType? {
        
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        
        if note.invalidatedAllObjects || deleted.containsObjectIdentical(to: object) { //We check if our object is in the sequence of invalidated or deleted object
            return .delete //If yes, then we return the deleted type of event for our object
        }
        
        let updated = note.updatedObjects.union(note.refreshedObjects) //Similarly we check if it's an update
        if updated.containsObjectIdentical(to: object) {
            return .update
        }
        
        return nil
    }
}

