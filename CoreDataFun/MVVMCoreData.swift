//
//  MVVMCoreData.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol MVVMCoreData where Self: UITableViewController {
    associatedtype Model: NSManagedObject, Managed
    var cellIdentifier: String { get }
}
