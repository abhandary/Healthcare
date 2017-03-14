//
//  SlashScreenViewController.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/19/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import UIKit
import SwiftSpinner
import ReachabilitySwift

class SlashScreenViewController: UIViewController {

    @IBOutlet weak var loginBUtton: UIButton!
    
    let presenter = SplashScreenPresenter();
    let kShowRevealViewSegueID = "showRevealViewController"
    let kShowMenuScreenSegueID = "showFirstTimeLaunchScreen"
    
    let kSpinnerWaiting = NSLocalizedString("", comment: "");
    var reachability : Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [:]
        if let font = UIFont(name: "Gill Sans SemiBold ", size: 20.0) {
            appearance.titleTextAttributes?[NSFontAttributeName] = font
        }
        appearance.titleTextAttributes?[NSForegroundColorAttributeName]
                = UIColor(colorLiteralRed: 0/255.0, green: 80/255.0, blue: 92/255.0, alpha: 1.0)
        
        self.loginBUtton.layer.borderWidth = 1.0
        self.loginBUtton.layer.borderColor = UIColor.grayColor().CGColor
        self.loginBUtton.layer.cornerRadius = 8.0;
        
       // appearance.barTintColor = UIColor(colorLiteralRed: 113/255.0, green: 160/255.0, blue: 106/255.0, alpha: 1.0)

        //authorize the user
        authorize();
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handleLogout(segue: UIStoryboardSegue) {
        self.presenter.logout()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.presenter.authorize { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    SwiftSpinner.hide();
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier(self.kShowMenuScreenSegueID, sender: self)
                    };
                }
            })
        }
    }

    func authorize() {
        SwiftSpinner.useContainerView(self.view);
        SwiftSpinner.show(kSpinnerWaiting);
        self.presenter.authorize({ (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    SwiftSpinner.hide();
                    self.stopReachability();
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier(self.kShowMenuScreenSegueID, sender: self)
                    };
                } else {
                    log.error("\(error)")
                    self.startReachabilityNotifier();
                }
            })
        })
    }
    
    
    func startReachabilityNotifier() {
        
        do {
            try self.reachability = Reachability(hostname: kReachabilityHostName)
        } catch {
            log.error("Unable to register for network reachability")
            assert(false);
            return;
        }

        self.reachability!.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                log.debug("Network reachable, attempting to authorize")
                self.authorize();
            }
        }
        self.reachability!.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                log.debug("Network not reachable")
            }
        }
        
        do {
            try self.reachability!.startNotifier()
        } catch {
            log.error("Unable to start notifier")
            assert(false);
        }
    }
    
    func stopReachability() {
        self.reachability?.stopNotifier();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
