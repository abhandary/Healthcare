//
//  ObservationDetailTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class ObservationDetailTableViewController: UITableViewController, IHistoryItemDetailViewController {

    var detailData: IHistoryItemDetail?
    var category   : String?
    var dateIssued : String?
    var code       : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let observation = self.detailData as? ObservationDetail {
            self.category   = observation.category;
            self.dateIssued = observation.effectiveDate
            self.code       = observation.code;
        }
        
        self.tableView.allowsSelection = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Code"
        case 1:
            return "Effective Date"
        case 2:
            return "Category"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath);
            cell.textLabel?.text = self.category;
            return cell;
        }
        if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("EffectiveDateCell", forIndexPath: indexPath);
            cell.textLabel?.text = self.dateIssued;
            return cell;
        }
        else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("CodeCell", forIndexPath: indexPath);
            cell.textLabel?.text = self.code
            return cell;
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView;
        header.textLabel?.textColor = UIColor(colorLiteralRed: 23 / 255.0,
                                              green: 94 / 255.0,
                                              blue: 84 / 255.0, alpha: 1.0);
    }

}
