//
//  AboutTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/30/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import SafariServices
import TOWebViewController;

class AboutTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                openFullPageWebview(kShowHelpURL)
            case 1:
                break;
            case 2:
                openFullPageWebview(kShowTermsAndPrivacyPolicyURL)
            case 3:
                openFullPageWebview(kShowLicensesURL)
            default:
                break;
            }
        }
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func openFullPageWebview(urlString : String) {
        
        let url = NSURL(string: urlString);
        if url == nil { return; }
        if #available(iOS 9, *) {
            let sfVC = SFSafariViewController(URL: url!)
            self.presentViewController(sfVC, animated: true, completion: nil)
        } else {
            let toWebVC = TOWebViewController(URL: url!)
            let navVC = UINavigationController(rootViewController: toWebVC);
            self.presentViewController(navVC, animated: true, completion: nil)
        }
    }
    
}
