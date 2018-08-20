//
//  MoodTableViewModel.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class MoodTableViewModel: CoreDataContainerAware {
    
    //MOC
    //tableview data Source (based on fetchted + observers)
    
    var tableView: UITableView!
    var cellIdentifier: String = "MoodCell"
    var managedObjectContext: NSManagedObjectContext!
    
    var dataSource:TableViewDataSource<MoodTableViewModel>!
    
    var moodActionStatus: ((_ status: Bool) -> ())?
    
    fileprivate var geoLocationController:GeoLocation!
    
    fileprivate var readyToMood:Bool! {
        didSet {
            guard moodActionStatus != nil else { return }
            self.moodActionStatus!(readyToMood)
        }
    }
    
    
    
    init(_ tableView: UITableView, moc: NSManagedObjectContext,  cellIdentifier: String = "MoodCell") {
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
        self.managedObjectContext = moc
        self.setupTableView()
        
        self.geoLocationController = GeoLocation(delegate: self)
        
        self.tableView.reloadData()
    }
    
    
    fileprivate func setupTableView() {
        
        let request = Mood.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //On instancie une dataSource qui a pour type TableViewDataSource, avec un Generics qui doit se conformer à TableViewDataSourceDelegate
        self.dataSource = TableViewDataSource(tableView: self.tableView, cellIdentifier: self.cellIdentifier, fetchedResultsController: fetchResultController, delegate: self)
    }
    
    var selectedObject:Mood? {
        return self.dataSource.selectedObject
    }
    
    
    func addMood(){
        guard let image = UIImage(named: "imageTest") else { return }
        
        self.geoLocationController.gettingLocation(gotLocation: { (location, placemark) in
            
            image.getColors { colors in
                print(colors.primary)
            }
            
            self.managedObjectContext.performChanges {
                _ = Mood.insert(into: self.managedObjectContext, image: image, location: location, placemark: placemark)
            }
        })
        
    }
}

extension MoodTableViewModel: TableViewDataSourceDelegate {
    func configure(_ cell: MoodTableViewCell, for object: Mood) {
        cell.configure(for: object)
    }
}

extension MoodTableViewModel: GeoLocationDelegate {
    func geoLocationDidChangeAuthorizationStatus(authorized: Bool) {
        self.readyToMood = authorized
    }
}
