//
//  MenuScreenTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/19/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import SMART

class MenuScreenTableViewController: UITableViewController {

    var lastSeenPatientID : String?
    
    @IBOutlet weak var homeTableViewCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.lastSeenPatientID = SMARTFHIRInterpreter.sharedInstance.patient!.id!
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Toggle the reveal view if the patient id has changed since last seen.
        if let lastSeenPatientID = self.lastSeenPatientID,
            currentPatient = SMARTFHIRInterpreter.sharedInstance.patient where
            lastSeenPatientID != currentPatient.id!,
            let revealViewController = self.revealViewController() {
            
            self.lastSeenPatientID = currentPatient.id!
            revealViewController.revealToggle(self);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
     */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let revealViewController = self.revealViewController(),
            currentCell = self.tableView.cellForRowAtIndexPath(indexPath) {
            if currentCell == self.homeTableViewCell {
                revealViewController.revealToggle(self);
            }
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllPatientsList" {
            if let navVC = segue.destinationViewController as? UINavigationController,
                vc = navVC.topViewController as? PatientListViewController  {
                
                vc.onPatientSelect = { patient in
                    if let patient = patient {
                        if let currentPatient = SMARTFHIRInterpreter.sharedInstance.patient where
                            patient.id! != currentPatient.id!,
                            let revealViewController = self.revealViewController() {
                            revealViewController.revealToggle(self);
                        }
                        SMARTFHIRInterpreter.sharedInstance.patient = patient;
                    }
                }
                vc.patientList = PatientListAll()
                vc.server = smart.server
            }
        }
    }
    
    @IBAction func doneAllPatientsList(segue: UIStoryboardSegue) {
        // no action
        print("Hello");
    }
    
    @IBAction func doneSettingsScreen(segue: UIStoryboardSegue) {
        // no action
        print("Done Settings Screen");
    }

    @IBAction func doneAboutScreen(segue: UIStoryboardSegue) {
        // no action
        print("Done About Screen");
    }

    
}
