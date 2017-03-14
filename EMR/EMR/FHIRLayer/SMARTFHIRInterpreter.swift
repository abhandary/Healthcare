//
//  SMARTFHIRInterpreter.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/12/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART



class SMARTFHIRInterpreter
{
    // friends don't let friends write singletons
    static var sharedInstance = SMARTFHIRInterpreter();
    var patient : Patient?

    init() {
    }
    
    func authorize (callback : (success: String?, error: NSError?) -> ()) {
        smart.authProperties.granularity = .TokenOnly //.PatientSelectNative;
        smart.authorize() { patient , error in
            if nil != error || nil == patient {
                var callbackError : NSError?
                if let fhirError = error as? FHIRError {
                    callbackError = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                }
                callback(success: nil, error: callbackError);
            }
            else {
                self.patient = patient;
                callback(success: patient!.id!, error: nil);
             }
        }
    }
    
    func logout () {
        smart.reset();
    }
    
    func encounters (callback : (encounters: [Encounter]?, error: NSError?) -> ()) {
        if let patient = self.patient {
            Encounter.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(encounters: nil, error: error);
                    }
                    else {
                        
                        let encounters = bundle?.entry?
                            .filter() { return $0.resource is Encounter }
                            .map() { return $0.resource as! Encounter }
                        
                        callback(encounters: encounters, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(encounters: nil, error:error);
        }
    }
    
    func immunizations (callback : (immunizations: [Immunization]?, error: NSError?) -> ()) {
        if let patient = self.patient {
            Immunization.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(immunizations: nil, error: error);
                    }
                    else {
                        
                        let immunizations = bundle?.entry?
                            .filter() { return $0.resource is Immunization }
                            .map() { return $0.resource as! Immunization }
                        
                        callback(immunizations: immunizations, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(immunizations: nil, error:error);
        }
    }
    
    func conditions (callback : (conditions: [Condition]?, error: NSError?) -> ()) {
        if let patient = self.patient {
            Condition.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(conditions: nil, error: error);
                    }
                    else {
                        
                        let conditions = bundle?.entry?
                            .filter() { return $0.resource is Condition }
                            .map() { return $0.resource as! Condition }
                        
                        callback(conditions: conditions, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(conditions: nil, error:error);
        }
    }
    
    func medicationOrders (callback : (medicationOrders: [MedicationOrder]?, error: NSError?) -> ()) {
        if let patient = self.patient {
            MedicationOrder.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(medicationOrders: nil, error: error);
                    }
                    else {
                        
                        let medicationOrders = bundle?.entry?
                            .filter() { return $0.resource is MedicationOrder }
                            .map() { return $0.resource as! MedicationOrder }
                        
                        callback(medicationOrders: medicationOrders, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(medicationOrders: nil, error:error);
        }
    }

    
    func observations (callback : (observations: [Observation]?, error: NSError?) -> ()) {
        if let patient = self.patient {
            Observation.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(observations: nil, error: error);
                    }
                    else {
                        
                        let observations = bundle?.entry?
                            .filter() { return $0.resource is Observation }
                            .map() { return $0.resource as! Observation }
                        
                        callback(observations: observations, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(observations: nil, error:error);
        }
    }

    func allergies (callback : (allergies: [AllergyIntolerance]?, error: NSError?) -> ()) {
        
        if let patient = self.patient {
            AllergyIntolerance.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(allergies: nil, error: error);
                    }
                    else {
                        
                        let allergies = bundle?.entry?
                            .filter() { return $0.resource is AllergyIntolerance }
                            .map() { return $0.resource as! AllergyIntolerance }
                        
                        callback(allergies: allergies, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(allergies: nil, error:error);
        }
    }
    
    func reports (callback : (reports: [DiagnosticReport]?, error: NSError?) -> ()) {
        
        if let patient = self.patient {
            DiagnosticReport.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(reports: nil, error: error);
                    }
                    else {
                        
                        let reports = bundle?.entry?
                            .filter() { return $0.resource is DiagnosticReport }
                            .map() { return $0.resource as! DiagnosticReport }
                        
                        callback(reports: reports, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(reports: nil, error:error);
        }
    }
    
    func procedures (callback : (procedures: [Procedure]?, error: NSError?) -> ()) {
        
        if let patient = self.patient {
            Procedure.search(["patient": patient.id!])
                .perform(smart.server) { bundle, fhirError in
                    
                    if let fhirError = fhirError {
                        let error = NSError(domain: fhirError.description, code: fhirError._code, userInfo: nil);
                        callback(procedures: nil, error: error);
                    }
                    else {
                        
                        let procedures = bundle?.entry?
                            .filter() { return $0.resource is Procedure }
                            .map() { return $0.resource as! Procedure }
                        
                        callback(procedures: procedures, error: nil);
                    }
            }
        } else {
            let error = NSError(domain: "Patient Info not available", code: 0, userInfo: nil);
            callback(procedures: nil, error:error);
        }
    }
}
