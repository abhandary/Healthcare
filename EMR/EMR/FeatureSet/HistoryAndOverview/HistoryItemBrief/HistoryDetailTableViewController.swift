//
//  HistoryItemBriefTableViewController
//  EMR
//
//  Created by Akshay Bhandary on 10/15/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import CoreData

class HistoryItemBriefTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var activityIndicator = UIActivityIndicatorView()

    var historyItemDetails : [IHistoryItemDetail]?
    var selectedRow = 0;
    var selectedIndexPath : NSIndexPath?
    var fetchedResultsController : NSFetchedResultsController!
    var presenter : IHistoryItemDetailPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell");
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let title = self.title,
            presenter = HistoryDetailPresenterFactory().historyDetailForItem(title) {
            self.presenter = presenter
            
//       //     showActivityIndicator();
//            presenter.fetchedResultsControllerDelegate = self;
//            self.fetchedResultsController = presenter.historyItemsFetchedResultsControllerController();
            
//            presenter?.fetchHistoryItems({ (result) in
//                self.historyItemDetails = result;
//                self.hideActivityIndicator();
//                self.tableView.reloadData();
//            })
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        if let title = self.title {
//            let presenter = HistoryDetailPresenterFactory().historyDetailForItem(title);
//            showActivityIndicator();
//            presenter?.fetchedResultsControllerDelegate = self;
//            presenter?.fetchHistoryItems({ (result) in
//                self.historyItemDetails = result;
//                self.hideActivityIndicator();
//                self.tableView.reloadData();
//            })
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let historyItemDetails = self.historyItemDetails {
            return historyItemDetails.count;
        }
//        if let sections = self.fetchedResultsController.sections {
//            return sections[section].numberOfObjects;
//        }
        return 0;
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let rows = self.historyItemDetails {
            if let secondaryText = rows[indexPath.row].secondaryText where secondaryText.characters.count > 0 {
                let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryDetailWithSubtitleCell", forIndexPath: indexPath) ;
                cell.textLabel?.text       =  rows[indexPath.row].primaryText
                cell.detailTextLabel?.text = rows[indexPath.row].secondaryText
                return cell
        
            } else {
                let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryDetailCell", forIndexPath: indexPath) ;
                cell.textLabel?.text  =  rows[indexPath.row].primaryText
                return cell
            }
        } else {
            return self.tableView.dequeueReusableCellWithIdentifier("HistoryDetailCell", forIndexPath: indexPath);
        }
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let detailObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
//        
//        if let primaryText = detailObject.valueForKey("primaryText") as? String,
//            secondaryText = detailObject.valueForKey("secondaryText") as? String {
//            
//            if secondaryText.characters.count > 0 {
//                let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryDetailWithSubtitleCell", forIndexPath: indexPath) ;
//                cell.textLabel?.text       =  primaryText;
//                cell.detailTextLabel?.text = secondaryText
//                return cell
//            } else {
//                let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryDetailCell", forIndexPath: indexPath) ;
//                cell.textLabel?.text       =  primaryText;
//                return cell
//            }
//        }
//        return self.tableView.dequeueReusableCellWithIdentifier("HistoryDetailCell", forIndexPath: indexPath);
//     }
//    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedRow = indexPath.row;
        self.selectedIndexPath = indexPath;
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true);
        if let title = self.title {
            let segue = "show" + title + "Detail";
            performSegueWithIdentifier(segue, sender: self);
        }
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if var historyItemDetailVC = segue.destinationViewController as? IHistoryItemDetailViewController,
                rows = self.historyItemDetails{
            
            // let managedObject = self.fetchedResultsController.objectAtIndexPath(selectedIndexPath) as! NSManagedObject;
            // historyItemDetailVC.detailData = presenter.historyItemFromManagedObject(managedObject)
            historyItemDetailVC.detailData = rows[selectedRow]
        } else {
            assert(false);
            log.error("nil checks failed!")
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                     atIndex sectionIndex: Int,
                                             forChangeType type: NSFetchedResultsChangeType) {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Activity Indicator
    func showActivityIndicator()
    {
        self.activityIndicator.frame = CGRectMake(0, 0, 24, 24);
        let window = UIApplication.sharedApplication().delegate!.window!!
        window.addSubview(self.activityIndicator);
        self.activityIndicator.color = UIColor.blackColor()
        self.activityIndicator.center = self.view.center;
        self.activityIndicator.startAnimating();
    }
    
    func hideActivityIndicator()
    {
        self.activityIndicator.stopAnimating()
    }


}
