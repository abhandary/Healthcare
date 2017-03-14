//
//  PatientOverviewPresenter.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/14/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation

class PatientOverviewPresenter
{
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    let NotAvailable = "N/A"
    
    func patientName() -> String {
        if let patient = fhirInterpreter.patient,
            names = patient.name where
            names.count > 0 {
            
            return "\(names[0].family![0]), \(names[0].given![0])";
        }

        return "Patent Name is " + NotAvailable
    }
    
    func patientAge() -> String {
        if let patient = fhirInterpreter.patient,
            birthDate = patient.birthDate {
            return "Age \(DateUtil.ageFromDate(birthDate.nsDate)) (DOB \(birthDate.description))";
        }

        return "Age: "  + NotAvailable
    }
    
    func patientGender() -> String {
        if let patient = fhirInterpreter.patient {
            return "\(patient.gender!.capitalizedString)"
        }
        return "Gender: " + NotAvailable
    }
    
 
    func patientAddress() -> String {
        if let patient = fhirInterpreter.patient,
            address = patient.address where
            address.count > 0,
            let lines = address[0].line,
            city   = address[0].city,
            state  = address[0].state,
            postalCode = address[0].postalCode,
            country = address[0].country
        {
            var addressStr = "";
            for line in lines {
                addressStr += line + "\n"
            }
            addressStr += "\(city)\n\(state), \(postalCode)\n\(country)"
            return addressStr;
        }
        return "Address: " + NotAvailable
    }
    
    func phoneNumber() -> String {
        if let patient = fhirInterpreter.patient,
            telecom = patient.telecom where telecom.count > 0,
            let num = telecom[0].value {
            return num;
        }
        return "N/A"
    }
    
}
