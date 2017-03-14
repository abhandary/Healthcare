//
//  SettingsScreenTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/27/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsScreenTableViewController: UITableViewController {

    @IBOutlet weak var usePassCodeSwitch: UISwitch!
    @IBOutlet weak var useTouchIDSwitch: UISwitch!
    let myContext = LAContext()
    
    var currentPatientID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var authError: NSError? = nil
        self.currentPatientID = SMARTFHIRInterpreter.sharedInstance.patient!.id!
        
        // let userDefaults = NSUserDefaults.standardUserDefaults();
        // self.usePassCodeSwitch.on = userDefaults.boolForKey(kUsePassCodeSwitch);
        // self.useTouchIDSwitch.on = userDefaults.boolForKey(kUseTouchIDSwitch);
        
        self.usePassCodeSwitch.on = false;
        self.useTouchIDSwitch.on = false;
        
        if !myContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
            self.useTouchIDSwitch.on = false;
            self.useTouchIDSwitch.userInteractionEnabled = false;
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    @IBAction func passCodeSwitchToggled(sender: AnyObject) {
        // let userDefaults = NSUserDefaults.standardUserDefaults();
        // userDefaults.setBool(self.usePassCodeSwitch.on, forKey: kUsePassCodeSwitch)
        // userDefaults.synchronize();
        
        let alert = UIAlertController(title: "Sorry!", message:"This feature isn't available right now", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { _ in
            self.usePassCodeSwitch.on = false;
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }

    
    @IBAction func touchIDSwitchToggled(sender: AnyObject) {
        // let userDefaults = NSUserDefaults.standardUserDefaults();
        // userDefaults.setBool(self.useTouchIDSwitch.on, forKey: kUseTouchIDSwitch)
        // userDefaults.synchronize();
        
        let alert = UIAlertController(title: "Sorry!", message:"This feature isn't available right now", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { _ in
            self.useTouchIDSwitch.on = false;
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
