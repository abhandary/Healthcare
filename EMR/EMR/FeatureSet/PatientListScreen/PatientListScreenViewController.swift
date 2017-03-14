//
//  PatientListScreenViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/20/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART

class PatientListScreenViewController : PatientListViewController {
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {};
    }
}
