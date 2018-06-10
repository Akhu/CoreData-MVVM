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
    
    
    init(_ tableView: UITableView, moc: NSManagedObjectContext,  cellIdentifier: String = "MoodCell") {
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
        self.managedObjectContext = moc
        self.setupTableView()
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
    
    var selectedObject: Mood? {
        get {
            guard let object = self.dataSource.selectedObject else { return nil }
            return object
        }
    }
    
    func addMood(){
        guard let image = UIImage(named: "imageTest") else { return }
        
        image.getColors { colors in
            print(colors.primary)
        }
        
        managedObjectContext.performChanges {
            _ = Mood.insert(into: self.managedObjectContext, image: image)
        }
    }
}

extension MoodTableViewModel: TableViewDataSourceDelegate {
    func configure(_ cell: MoodTableViewCell, for object: Mood) {
        cell.configure(for: object)
    }
}
