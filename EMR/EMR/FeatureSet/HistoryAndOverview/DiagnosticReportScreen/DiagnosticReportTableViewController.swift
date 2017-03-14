//
//  DiagnosticReportTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/24/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class DiagnosticReportTableViewController: UITableViewController, IHistoryItemDetailViewController {

    var detailData: IHistoryItemDetail?
    
    var category   : String?
    var dateIssued : String?
    var code      : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let report = self.detailData as? ReportDetail {
            self.category   = report.category;
            self.dateIssued = report.dateIssued;
            self.code       = report.code;
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return "Category"
        case 1:
            return "Date Issued"
        case 0:
            return "Code"
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
            let cell = self.tableView.dequeueReusableCellWithIdentifier("IssuedDateCell", forIndexPath: indexPath);
            cell.textLabel?.text = self.dateIssued;
            return cell;
        }
        else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("CodeCell", forIndexPath: indexPath);
            if let code = self.code {
                cell.textLabel?.text = code;
            }
            return cell;
        }
    }
    
    // MARK: - Table view data source    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView;
        header.textLabel?.textColor = UIColor(colorLiteralRed: 23 / 255.0,
                                              green: 94 / 255.0,
                                              blue: 84 / 255.0, alpha: 1.0);
    }
}
