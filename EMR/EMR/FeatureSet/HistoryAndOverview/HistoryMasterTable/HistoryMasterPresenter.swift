//
//  HistoryPresenter.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/14/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation


class HistoryMasterPresenter
{
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    let router   = HistoryMasterTableRouter();
    
    func patientName() -> String {
        if let patient = fhirInterpreter.patient,
            names = patient.name where
            names.count > 0 {
            
            return "\(names[0].family![0]), \(names[0].given![0])";
        }
        else  {
            return "Patient Name Not Available"
        }
    }
    
    func patientBrief() -> String {
        if let patient = fhirInterpreter.patient,
            birthDate = patient.birthDate {
            return "\(patient.gender!.capitalizedString), Age \(DateUtil.ageFromDate(birthDate.nsDate)) (DOB \(birthDate.description))";
        }
        else  {
            return "Patient Brief Not Available"
        }
    }
    
    func patientID() -> String? {
        if let patient = fhirInterpreter.patient {
            return patient.id
        }
        return nil
    }
}
