//
//  Country.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 12/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

final class Country: NSManagedObject {
    @NSManaged var updatedAt: Date
    
    @NSManaged var numericISO3166Code: Int16
    
    fileprivate(set) var iso3166Code: ISO3166.Country {
        get {
            guard let c = ISO3166.Country(rawValue: self.numericISO3166Code) else { fatalError("unknow country code") }
            return c
        }
        set {
            numericISO3166Code = newValue.rawValue
        }
    }
    
    @NSManaged fileprivate(set) var continent: Continent?
    @NSManaged fileprivate(set) var moods: Set<Mood>
    
    
    static func findOrCreate(for isoCountryCode: ISO3166.Country, in context: NSManagedObjectContext) -> Country {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(numericISO3166Code), Int(isoCountryCode.rawValue))
        
        let country = findOrCreate(in: context, matching: predicate) {
            $0.iso3166Code = isoCountryCode
            $0.updatedAt = Date()
            $0.continent = Continent.findOrCreateContinent(for: isoCountryCode, in: context) //#nazisme complet
        }
        return country
    }
}

extension Country: LocalizedStringConvertible {
    var localizedDescription: String {
        return iso3166Code.localizedDescription
    }
}

extension Country: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
}
