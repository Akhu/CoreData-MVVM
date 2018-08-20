//
//  Continent.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 12/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

final class Continent: NSManagedObject {
    @NSManaged var updatedAt: Date
    
    fileprivate(set) var iso3166Code: ISO3166.Continent {
        get {
            guard let c = ISO3166.Continent(rawValue: self.numericISO3166Code) else { fatalError("Unknow continent") }
            
            return c
        }
        set {
            self.numericISO3166Code = newValue.rawValue
        }
    }
    
    @NSManaged var numericISO3166Code:Int16

    @NSManaged var countries: Set<Country>
}

extension Continent {
    static func findOrCreateContinent(for isoCountry: ISO3166.Country, in context: NSManagedObjectContext) -> Continent? {
        guard let iso3166 = ISO3166.Continent(country: isoCountry) else { return nil }
        let predicate = NSPredicate(format: "%K == %d", #keyPath(numericISO3166Code))
        let continent = findOrCreate(in: context, matching: predicate) {
            $0.iso3166Code = iso3166
            $0.updatedAt = Date()
        }
        return continent
    }
}

extension Continent: LocalizedStringConvertible {
    var localizedDescription: String {
        return iso3166Code.localizedDescription
    }
}

extension Continent: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
}


