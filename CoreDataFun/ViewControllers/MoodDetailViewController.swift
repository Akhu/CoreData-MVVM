//
//  MoodDetailViewController.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit

class MoodDetailViewController: UIViewController {
    
    @IBOutlet weak var imageMood: UIImageView!
    @IBOutlet weak var labelDateMood: UILabel!
    
    fileprivate var observer: ManagedObjectObserver?
    
    var mood: Mood! {
        didSet {
            observer = ManagedObjectObserver(object: mood, changeHandler: { [weak self] type in
                guard type == .delete else { return }
                _ = self?.navigationController?.popViewController(animated: true)
            })
            self.updateViews()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            self.imageMood.image = UIImage.from(color: mood.colors[0])
            self.labelDateMood.text = self.mood.date.toDisplayFormat()
        }
    }
    
    @IBAction func deleteMoodAction(_ sender: Any) {
        mood.managedObjectContext?.performChanges {
            self.mood.managedObjectContext?.delete(self.mood)
        }
    }
}
