//
//  ActivityIndicator.swift
//  Healthcare
//
//  Created by Akshay Bhandary on 7/30/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    
    static let sharedInstance = ActivityIndicator()
    
    var activityIndicator : UIActivityIndicatorView!
    var activityView      : UIView!
    
    
    // MARK: - init and init related
    init() {
        setupIndicatorView()
    }
    
    
    private func setupIndicatorView() {
        
        self.activityView = UIView()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        self.activityView.addSubview(self.activityIndicator);
        self.activityView.hidden        = true
        // self.activityView.alpha         = 0.2
    }
    
    
    // MARK: - activity indicator methods
    func showActivityIndicator(view : UIView) {
        
        self.activityView.frame         = view.frame
        self.activityView.hidden        = false
        self.activityIndicator.hidden   = false
        self.activityIndicator.startAnimating()
        view.addSubview(self.activityView)
        self.activityIndicator.center   = self.activityView.center;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func hideActivityIndicator(view : UIView) {
        
        self.activityView.removeFromSuperview()
        self.activityView.hidden        = true;
        self.activityIndicator.hidden   = true
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}
