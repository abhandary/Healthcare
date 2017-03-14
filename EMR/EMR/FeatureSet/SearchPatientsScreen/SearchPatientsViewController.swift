//
//  SearchPatientsViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/24/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import SMART

class SearchPatientsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var ssnTextField: UITextField!
    
    let kPickerRows = ["Any", "Male", "Female", "Other"]
    var queryParams : [String : AnyObject]?
    let kShowSearchPatientsListSegue = "showSearchPatientsList"
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.nameTextField.clearButtonMode = UITextFieldViewMode.Always;
        self.genderPicker.delegate = self;
        self.genderPicker.dataSource = self;
        
        self.searchButton.layer.borderWidth = 1.0
        self.searchButton.layer.borderColor = self.searchButton.titleLabel?.textColor.CGColor
        self.searchButton.layer.cornerRadius = 8.0;

        self.clearAllButton.layer.borderWidth = 1.0
        self.clearAllButton.layer.borderColor = self.searchButton.titleLabel?.textColor.CGColor
        self.clearAllButton.layer.cornerRadius = 8.0;

        
        /*
        [textField addTarget:textField
            action:@selector(resignFirstResponder)
        forControlEvents:UIControlEventEditingDidEndOnExit];
         */
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard));
        self.view.addGestureRecognizer(tap);
    }
    
    func dismissKeyboard() {
        self.nameTextField.resignFirstResponder();
        self.ssnTextField.resignFirstResponder();
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        
        self.queryParams = [String : AnyObject]();
        
        if let gender = getGenderParams() {
            self.queryParams!["gender"] = gender;
        }
        
        if let name = getNameParams() {
            self.queryParams!["name"] = ["$exact": name]
        }
        
        if let ssn = getSSNParams() {
            self.queryParams!["identifier"] = ssn
        }
        
        // ["address": "Boston", "gender": "male", "given": ["$exact": "Willis"]]
        // let srch = Patient.search(queryParms);
        if self.queryParams!.keys.count > 0 {
            self.performSegueWithIdentifier(kShowSearchPatientsListSegue, sender: self);
        }
        
    }
    
    @IBAction func clearAllButtonPressed(sender: AnyObject) {
        self.nameTextField.text = "";
        self.ssnTextField.text = "";
        self.genderPicker.selectRow(0, inComponent: 0, animated: true);
    }
    @IBAction func ssnTextFieldDidEndOnExit(sender: AnyObject) {
        self.ssnTextField.resignFirstResponder()
        self.searchButtonPressed(sender);
    }
    
    @IBAction func nameTextFieldDidEndOnExit(sender: AnyObject) {
        self.nameTextField.resignFirstResponder()
        self.searchButtonPressed(sender);
    }
    
    func getGenderParams() -> String? {
        switch self.genderPicker.selectedRowInComponent(0) {
        case 0:
            return nil
        case 1:
            return "male"
        case 2:
            return "female"
        case 3:
            return "other"
        default:
            return nil;
        }
    }
    
    func getNameParams() -> String? {
        return self.nameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    func getSSNParams() -> String? {
        return self.ssnTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kPickerRows.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kPickerRows[row];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 

        }
    }
    /*
    @IBAction func segmentChanged(sender: AnyObject) {
        switch self.segmentControl.selectedSegmentIndex {
            
        // Name
        case 0:
            self.nameTextField.hidden = false;
            self.ssnTextField.hidden  = true;
            self.datePicker.hidden    = true;
            self.genderPicker.hidden  = true;

        // Identifier
        case 1:
            self.nameTextField.hidden   = true;
            self.ssnTextField.hidden    = false;
            self.datePicker.hidden      = true;
            self.genderPicker.hidden    = true;

        // Gender
        case 2:
            self.nameTextField.hidden   = true;
            self.ssnTextField.hidden    = true;
            self.datePicker.hidden      = true;
            self.genderPicker.hidden    = false;
            
        // Birth Date
        case 3:
            self.nameTextField.hidden   = true;
            self.ssnTextField.hidden    = true;
            self.datePicker.hidden      = false;
            self.genderPicker.hidden    = true;
            
            
        default:
            break;
        }
    }
    */


    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowSearchPatientsListSegue {
            if let navVC = segue.destinationViewController as? UINavigationController,
                vc = navVC.topViewController as? PatientListViewController {
                
                // 1. setup the patient select handler.
                vc.onPatientSelect = { patient in
                    
                    // 2. If patient is selected and is not the same as current patient then dimiss the search screen
                    // and collapse the reveal view so that the user is back on the home screen.
                    if let patient = patient {
                        SMARTFHIRInterpreter.sharedInstance.patient = patient;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC / 2)), dispatch_get_main_queue(), {
                            self.dismissViewControllerAnimated(true, completion: {
                                if let revealViewController = self.revealViewController()  {
                                    revealViewController.revealToggle(self);
                                }
                            })
                        })
                    }
                }
                
                // 3. Inject the patient list
                if let queryParams = self.queryParams {
                    vc.patientList = PatientList(query: PatientListQuery(search: FHIRSearch(query: queryParams)))
                    vc.server = smart.server
                }
            }
        }
    }
    
    /*
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
