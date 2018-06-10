//
//  Mood.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import CoreData
import UIKit

final class Mood: NSManagedObject {
    @NSManaged fileprivate(set) var date: Date
    @NSManaged fileprivate(set) var colors: [UIColor]
    
    static func insert(into context: NSManagedObjectContext, image:UIImage) -> Mood {
        let mood = context.insertObject(ofType: Mood.self)
        mood.colors = [image.getColors().primary, image.getColors().secondary]
        mood.date = Date()
        return mood
    }
}

extension Mood {
    subscript (safe: Int) -> UIColor {
        get {
            do {
                let color = self.colors[safe]
                return color
            } catch {
                return UIColor.black
            }
        }
    }
}
