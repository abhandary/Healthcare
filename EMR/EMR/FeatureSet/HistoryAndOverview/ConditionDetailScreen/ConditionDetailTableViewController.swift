//
//  ConditionDetailTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class ConditionDetailTableViewController: UITableViewController, IHistoryItemDetailViewController {

    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var onsetDate: UILabel!
    @IBOutlet weak var verificationStatus: UILabel!
    @IBOutlet weak var clinicalStatus: UILabel!

    @IBOutlet weak var dateRecorded: UILabel!
    
    var detailData: IHistoryItemDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let condition = detailData as? ConditionDetail {
            self.code.text          = condition.code;
            self.onsetDate.text     = condition.onsetDateTime;
            self.verificationStatus.text = condition.verificationStatus;
            self.clinicalStatus.text     = condition.clinicalStatus;
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
