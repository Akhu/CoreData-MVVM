//
//  CoreDataContainerAware.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataContainerAware {
    var managedObjectContext: NSManagedObjectContext! { get set }
}
