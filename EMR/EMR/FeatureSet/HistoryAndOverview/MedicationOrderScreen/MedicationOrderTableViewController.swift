//
//  MedicationOrderTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/23/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit

class MedicationOrderTableViewController: UITableViewController, IHistoryItemDetailViewController {

    var detailData: IHistoryItemDetail?
    
    let kCodeSection              = "Code"
    let kDosageInstructionSection = "Dosage Instructions"
    let kCodeCell                 = "CodeCell"
    let kDosageInstructionCell    = "DosageInstructionsCell"
    
    var dosageInstructions : [DosageInstruction]?
    var code : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let medicationOrderDetail = self.detailData as? MedicationOrderDetail {
            self.dosageInstructions = medicationOrderDetail.dosageInstructions;
            self.code               = medicationOrderDetail.code;
        }
        
        self.tableView.allowsSelection = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }
        if let dosageInstructions = self.dosageInstructions {
            return dosageInstructions.count;
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return kCodeSection
        }
        
        return kDosageInstructionSection
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(kCodeCell, forIndexPath: indexPath);
            cell.textLabel?.text = self.code;
            return cell;
        }
        
        // section 1
        let cell = self.tableView.dequeueReusableCellWithIdentifier(kDosageInstructionCell, forIndexPath: indexPath);
        if let dosageInstructions = self.dosageInstructions {
            cell.textLabel?.text = dosageInstructions[indexPath.row].text;
        }

        
        return cell;
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView;
        header.textLabel?.textColor = UIColor(colorLiteralRed: 23 / 255.0,
                                              green: 94 / 255.0,
                                              blue: 84 / 255.0, alpha: 1.0);
    }
}
