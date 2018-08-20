//
//  MoodTableViewController.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit
import CoreData

class MoodsTableViewController: UITableViewController, CoreDataContainerAware, SegueHandler, MVVMCoreData {
    
    enum SegueIdentifier: String {
        case showMoodDetail = "detailMood"
    }
    
    typealias Model = Mood
    
    @IBOutlet weak var addMoodButton: UIBarButtonItem!
    var cellIdentifier: String = "MoodCell"
    var managedObjectContext: NSManagedObjectContext!
    var viewModel: MoodTableViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MoodTableViewModel(self.tableView, moc: self.managedObjectContext) //Handle all of our Data
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.viewModel.moodActionStatus
    }
    
    
    //var dataSource: TableViewDataSource<MoodsTableViewController>!
    @IBAction func addMoodAction(_ sender: UIBarButtonItem) {
        self.viewModel.addMood()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .showMoodDetail:
            guard let dvc = segue.destination as? MoodDetailViewController else { fatalError(" Wrong view controller type for detail Mood")}
            guard let mood = self.viewModel.selectedObject else { fatalError("No selected row?")}
            dvc.mood = mood
        }
    }
}


