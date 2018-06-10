//
//  MoodTableViewCell.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 06/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit

class MoodTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var colors: UIImageView!
}

extension MoodTableViewCell {
    func configure(for object: Mood){
        date.text = object.date.toDisplayFormat()
        
        let image = UIImage.from(color: object.colors[0])
        self.colors.image = image
        
    }
}
