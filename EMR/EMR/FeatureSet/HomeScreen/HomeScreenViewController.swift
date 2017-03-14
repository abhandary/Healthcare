//
//  ViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/12/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import SMART

class HomeScreenViewController: UIViewController {

    var  onceToken : dispatch_once_t = 0
    let presenter = HomeScreenPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
      //  super.viewWillAppear(animated);
        
        dispatch_once(&onceToken) {
            self.presenter.authorize({ (success, error) in
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil);
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllPatientsList" {
            let vc = segue.destinationViewController as! PatientListViewController;
            vc.onPatientSelect = { patient in

                if let patient = patient {
                    SMARTFHIRInterpreter.sharedInstance.patient = patient;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil);
                })
            }
            vc.patientList = PatientListAll()
            vc.server = smart.server
        }
    }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
    }


    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}

