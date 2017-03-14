//
//  ProcedureDetailTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/23/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class ProcedureDetailTableViewController: UITableViewController, IHistoryItemDetailViewController {

    
    
    @IBOutlet weak var datePerformed: UILabel!
    @IBOutlet weak var code: UILabel!
    
    var detailData: IHistoryItemDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let procedureDetail = self.detailData as? ProcedureDetail {
            self.datePerformed.text = procedureDetail.datePerformed;
            self.code.text          = procedureDetail.code;
        }
        
        self.tableView.allowsSelection = false;
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
