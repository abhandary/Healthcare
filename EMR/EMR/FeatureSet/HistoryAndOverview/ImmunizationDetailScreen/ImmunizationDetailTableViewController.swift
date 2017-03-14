//
//  ImmunizationDetailTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class ImmunizationDetailTableViewController: UITableViewController, IHistoryItemDetailViewController {

    @IBOutlet weak var vaccineCode: UILabel!
    @IBOutlet weak var vaccineAdministrationDate: UILabel!
    @IBOutlet weak var given: UILabel!
    @IBOutlet weak var selfReported: UILabel!
    
    var detailData: IHistoryItemDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let immunizationDetail = detailData as? ImmunizationDetail {
            self.vaccineCode.text = immunizationDetail.vaccineCode;
            self.vaccineAdministrationDate.text = immunizationDetail.date;
            self.given.text = immunizationDetail.given;
            self.selfReported.text = immunizationDetail.selfReported
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

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView;
        header.textLabel?.textColor = UIColor(colorLiteralRed: 23 / 255.0,
                                              green: 94 / 255.0,
                                              blue: 84 / 255.0, alpha: 1.0);
    }
}
