//
//  FrameworkCell.swift
//  Demo
//
//  Created by Shane Rosse on 1/22/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit

class FrameworkCell: UITableViewCell {
    
    var f_worker: framework! {
        didSet {
            textLabel!.text = f_worker.name
        }
    }

}
