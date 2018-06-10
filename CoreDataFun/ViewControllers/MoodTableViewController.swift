//
//  MoodTableViewController.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit
import CoreData

class MoodsTableViewController: UITableViewController, CoreDataContainerAware, SegueHandler {
    
    enum SegueIdentifier: String {
        case showMoodDetail = "detailMood"
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var viewModel: MoodTableViewModel = {
        return MoodTableViewModel(self.tableView, moc: managedObjectContext)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    func bindViewModel() {
        
    }
    
    // MARK: Private
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
