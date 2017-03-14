//
//  SplashScreenPresenter.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/19/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation

class SplashScreenPresenter
{
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    
    func authorize (callback : (success: String?, error: NSError?) -> ()) {
        fhirInterpreter.authorize { (success, error) in
            callback(success: success, error: error);
        }
    }
    
    func logout() {
        fhirInterpreter.logout();
    }
    
}
