//
//  AllergyIntoleranceTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class AllergyIntoleranceTableViewController: UITableViewController, IHistoryItemDetailViewController {

    var substanceText : String?
    var manifestations : [ManifestationDetail]?
    
    let kSubstanceSectionHeader = "Substance";
    let kManifestationsSectionHeader = "Manifestations";
    
    var detailData: IHistoryItemDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let allergyIntolerance = self.detailData as? AllergyDetail {
            self.substanceText  = allergyIntolerance.substance;
            self.manifestations = allergyIntolerance.manifestations;
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 1,
            let manifestations = self.manifestations {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ManifestationCell", forIndexPath: indexPath);
            cell.textLabel?.text = manifestations[indexPath.row].text
            cell.detailTextLabel?.text = manifestations[indexPath.row].severity
            return cell;
        }
        
        // section 0
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SubstanceCell", forIndexPath: indexPath);  //self.tableView.dequeueReusableCellWithIdentifier("SubstanceCell", forIndexPath: indexPath);
        cell.textLabel?.text = self.substanceText
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }
        
        // section 1
        return self.manifestations != nil ? self.manifestations!.count : 0;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return kSubstanceSectionHeader;
        }
        
        return kManifestationsSectionHeader;
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView;
        header.textLabel?.textColor = UIColor(colorLiteralRed: 23 / 255.0,
                                              green: 94 / 255.0,
                                              blue: 84 / 255.0, alpha: 1.0);
    }
}
