//
//  MasterViewControllerTableViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/14/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import SMART
import SWRevealViewController
import CoreData

class PatientOverviewCell : UITableViewCell
{
    @IBOutlet weak var patientBriefDescription: UILabel!
    @IBOutlet weak var patientName: UILabel!
}

class HistoryMasterTableViewController: UITableViewController, SWRevealViewControllerDelegate, NSFetchedResultsControllerDelegate {

    // string constants
    let kShowHistoryDetail = "showHistoryDetail";
    let kSHowPatientOverview = "showPatientOverview";
    let kHomeScreen   = "showHomeScreen";

    
    // outlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //  instance properties
    var  onceToken : dispatch_once_t = 0
    var  tableOnScreen = true;
    
    let rows = [kPatientOverview,
                kEncounters,
                kImmunizations,
                kProcedures,
                kConditions,
                kMedicationOrders,
                kReports,
                kObservations,
                kAllergies];
    
    let historyPresenter = HistoryMasterPresenter();
    var selectedRow = 0;
    
    let homeScreenViewController = HomeScreenViewController();
    
    var fetchedResultsController : [String : NSFetchedResultsController] = [String : NSFetchedResultsController]()
    
    var historyItemDetails = [String:[IHistoryItemDetail]]();

    var lastSeenPatientID : String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let cellNib = UINib(nibName: "PatientOverviewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "PatientOverviewCell")

        // 1. set up reveal view controller
        if let revealViewController = self.revealViewController() {
            self.menuButton.target = revealViewController;
            self.menuButton.action = "revealToggle:"
            revealViewController.delegate = self
        }

//        // Get the NSFetchedResultsController for each of the history items
//        for index in 1..<self.rows.count {
//            if let presenter = HistoryDetailPresenterFactory().historyDetailForItem(self.rows[index]) {
//                
//                // get the NSFetchedResultsController associated with this history item.
//                self.fetchedResultsController[self.rows[index]] = presenter.historyItemsFetchedResultsControllerController();
//            }
//        }
        
        // 2. setup refresh control
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged);
        self.refreshControl = refreshControl
    }

    override func viewWillAppear(animated: Bool) {
        if let revealViewController = self.revealViewController() {
            self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        }
        
        
        if let lastSeenPatientID = self.lastSeenPatientID,
            patientID = self.historyPresenter.patientID() where lastSeenPatientID == patientID {
            return;
        }
        self.lastSeenPatientID = self.historyPresenter.patientID();
        refresh()
    }

    
    override func viewDidAppear(animated: Bool) {
        dispatch_once(&onceToken) {
          //  self.performSegueWithIdentifier(kHomeScreen, sender: self);
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc func refresh() {
        

        var rowsFetched = 0;
        var fetchFailed = false;
        
        // 1. show an activity indicator on the table view
        ActivityIndicator.sharedInstance.showActivityIndicator(self.view)
        
        // 2. get the history items for all rows
        for index in 1..<self.rows.count {
            if let presenter = HistoryDetailPresenterFactory().historyDetailForItem(self.rows[index]) {
                
                // 3. fetch the latest date for this item from the server
                presenter.fetchHistoryItems({ (result) in
                    rowsFetched += 1;
                    
                    if result == nil {
                        // 4. fetch failed, likely network failure
                        fetchFailed = true;
                    }
                    self.historyItemDetails[self.rows[index]] = result;
                    if rowsFetched == self.rows.count - 1 {
                        
                        // 5. hide the activity indicator
                        ActivityIndicator.sharedInstance.hideActivityIndicator(self.view);
                        
                        if fetchFailed == true {
                            // 6. all rows fetched, however some failed, let the user know.
                            let alert = UIAlertView(title: kErrorDialogTitle,
                                message: kErrorDialogMessage, delegate: self, cancelButtonTitle: kErrorCancelTitle);
                            alert.show();
                        }
                        
                        // 7. reload the table.
                        self.tableView.reloadData();
                    }
                })
            }
        }
        self.refreshControl?.endRefreshing();
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("PatientOverviewCell",
                                                                        forIndexPath: indexPath) as! PatientOverviewCell;
            cell.patientName.text = historyPresenter.patientName();
            cell.patientBriefDescription.text = historyPresenter.patientBrief();
            return cell;
            // cell.textLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "Arial-BoldMT", size: 16), size: 16)
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryItemCell",
                                                                        forIndexPath: indexPath);
            cell.textLabel!.text = " " + rows[indexPath.row];
            cell.imageView!.image = UIImage(named: rows[indexPath.row].lowercaseString);
            cell.imageView!.hidden = false;

//            if let fetchedResultsController = self.fetchedResultsController[rows[indexPath.row]],
//                fetchedObjects = fetchedResultsController.fetchedObjects {
//                cell.detailTextLabel?.text = "\(fetchedObjects.count)";
//            } else {
//                cell.detailTextLabel?.text = "0"
//            }
        
            if let itemDetails = self.historyItemDetails[rows[indexPath.row]] {
                cell.detailTextLabel?.text = "\(itemDetails.count)";
            } else {
                cell.detailTextLabel?.text = "0"
            }
            return cell;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100;
        }
        return 60;
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.tableView.deselectRowAtIndexPath(indexPath, animated: true);
        if self.tableOnScreen == false {
            return;
        }
        
        if let itemDetails = self.historyItemDetails[rows[indexPath.row]]
                where itemDetails.count == 0 {
            return;
        }
        
        self.selectedRow = indexPath.row;
        if indexPath.row == 0 {
           self.performSegueWithIdentifier(kSHowPatientOverview, sender: self)
        } else {
            self.performSegueWithIdentifier(kShowHistoryDetail, sender: self)
        }

    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == kShowHistoryDetail {
            if let historyDetailVC = segue.destinationViewController as? HistoryItemBriefTableViewController {
                historyDetailVC.historyItemDetails = self.historyItemDetails[self.rows[self.selectedRow]];
                historyDetailVC.title = self.rows[self.selectedRow];
            }
        }
    }
    
    @IBAction func homeScreenDoneViewController(segue:UIStoryboardSegue) {
        print("exit");
    }
    
    // reveal view controller delegate
    func revealControllerPanGestureShouldBegin(revealController : SWRevealViewController) -> Bool {
        return true;
    }

    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
      //  print(position)
    }

    func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
        switch position {
        case .Left:
            self.tableView.scrollEnabled = true;
            self.tableOnScreen = true;
            print("Left");
        case .Right:
            self.tableView.scrollEnabled = false;
            self.tableOnScreen = false;
            print("Right");
        default:
            break;
        }
    }
    

    
}
