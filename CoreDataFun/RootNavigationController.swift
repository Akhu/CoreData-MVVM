//
//  ViewController.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit
import CoreData

class RootNavigationController: UINavigationController {
    
    
    var managedObjectContext: NSManagedObjectContext?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attributeContextToChild() {
        print("BOUM \(self.debugDescription)")
    }
    
    override func viewDidLoad() {
        print(self.managedObjectContext?.debugDescription)
        for childVc in self.viewControllers {
            if var mainContainerAwareVc = childVc as? CoreDataContainerAware {
                mainContainerAwareVc.managedObjectContext = self.managedObjectContext
            }
        }
        
        super.viewDidLoad()
        print("BOUM \(self.debugDescription)")
        
        
    }
}

