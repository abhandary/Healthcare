//
//  PatientOverviewViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/14/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class PatientOverviewViewController: UITableViewController {

    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    
    // name, gender, age
   
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    
    // contacts
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    
    // address
    @IBOutlet weak var address: UILabel!
    
    let presenter = PatientOverviewPresenter();
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // patent name, age and gender
        self.patientName.text = presenter.patientName();
        self.gender.text      = presenter.patientGender();
        self.age.text         = presenter.patientAge();
        
        // address
        self.address.text = presenter.patientAddress();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView;
        header.textLabel?.textColor = UIColor(colorLiteralRed: 237/255.0, green: 237/255.0, blue: 238/255.0, alpha: 1.0);
        header.contentView.backgroundColor = UIColor(colorLiteralRed: 67/255.0, green: 83/255.0, blue: 87/255.0, alpha: 1.0);
        // header.backgroundColor = UIColor(colorLiteralRed: 0/255.0, green: 80/255.0, blue: 92/255.0, alpha: 1.0);
    }

}
