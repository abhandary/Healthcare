//
//  SearchScreenPresenter.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/12/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation



class HomeScreenPresenter
{
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    let homeScreenRouter = HomeScreenRouter();
    
    init() {

    }
    
    func authorize (callback : (success: String?, error: NSError?) -> ()) {
        fhirInterpreter.authorize { (success, error) in
            callback(success: success, error: error);
        }
    }
}

