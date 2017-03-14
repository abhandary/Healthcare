//
//  FirstTimeLaunchScreenTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/26/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import SMART


class SegueFromLeft: UIStoryboardSegue {
    
    override func perform() {
        let src: UIViewController = self.sourceViewController
        let dst: UIViewController = self.destinationViewController
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        src.navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
        src.navigationController!.pushViewController(dst, animated: false)
    }
    
}
class FirstTimeLaunchScreenTableViewController: UITableViewController {

    let kShowRevealViewController = "showRevealViewController";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        
        
        if let _ = SMARTFHIRInterpreter.sharedInstance.patient {
            // patient selected, segue to home screen.
            self.performSegueWithIdentifier(self.kShowRevealViewController, sender: self);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return UIScreen.mainScreen().bounds.height / 3.2
        }
        return 1.0
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 20;
//        }
//        return 1;
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if let navVC = segue.destinationViewController as? UINavigationController,
            vc = navVC.topViewController as? PatientListViewController  {
            
            // 1. set patient select handler
            vc.onPatientSelect = { patient in
                if let patient = patient {
                    if let currentPatient = SMARTFHIRInterpreter.sharedInstance.patient where
                        patient.id! != currentPatient.id! {
                        
                    }
                    
                    // 2. cache the selected patient.
                    SMARTFHIRInterpreter.sharedInstance.patient = patient;
                    vc.dismissViewControllerAnimated(true, completion: { 
                        
                    })
                }
            }
            vc.patientList = PatientListAll()
            vc.server = smart.server
        }
    }

    
}
