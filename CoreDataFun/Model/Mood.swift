//
//  Mood.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import CoreData
import CoreLocation
import UIKit

final class Mood: NSManagedObject {
    @NSManaged fileprivate(set) var date: Date
    @NSManaged fileprivate(set) var colors: [UIColor]
    
    static func insert(into context: NSManagedObjectContext, image:UIImage, location: CLLocation?, placemark: CLPlacemark?) -> Mood {
        
        let mood = context.insertObject(ofType: Mood.self)
        mood.colors = [image.getColors().primary, image.getColors().secondary]
        mood.date = Date()
        
        if let coordinates = location?.coordinate {
            mood.latitude = NSNumber(value: coordinates.latitude)
            mood.longitude = NSNumber(value: coordinates.longitude)
        }
        
        let isoCode = placemark?.isoCountryCode ?? ""
        let isoCountry = ISO3166.Country.fromISO3166(isoCode)
        
        mood.country = Country.findOrCreate(for: isoCountry, in: context)

        return mood
    }
    
    public var location: CLLocation? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocation(latitude: CLLocationDegrees(lat.doubleValue), longitude: CLLocationDegrees(lon.doubleValue))
    }
    
    @NSManaged fileprivate var latitude: NSNumber?
    @NSManaged fileprivate var longitude: NSNumber?
    
    
    @NSManaged fileprivate(set) var country: Country
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
