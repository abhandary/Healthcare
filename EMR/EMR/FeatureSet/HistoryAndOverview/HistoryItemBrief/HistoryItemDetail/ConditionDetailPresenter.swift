//
//  ConditionDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART
import CoreData

class ConditionDetail : IHistoryItemDetail {
    var primaryText   : String?
    var secondaryText : String?
    var code          : String?
    var dateRecorded  : String?
    var onsetDateTime : String?
    
    var nsDateRecorded  : NSDate?
    var onsetNSDateTime : NSDate?
    
    var verificationStatus : String?
    var clinicalStatus : String?
}

class ConditionDetailPresenter : IHistoryItemDetailPresenter {
    
    let kCode = "code";
    let kNSDateRecorded     = "nsDateRecorded"
    let kOnsetNSDateTime    = "onsetNSDateTime";
    let kVerificationStatus = "verificationStatus"
    let kClinicalStatus     = "clinicalStatus"
    
    let kConditionDetailEntityName = "ConditionDetail"
    
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // 1. setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kNSDateRecorded, ascending: false)
        builder.sortDescriptors = [sortDescriptor]
        
        // 2. get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: self.kConditionDetailEntityName);
        return interactor
    }()
    
    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }

    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        let conditionDetail = ConditionDetail();
        
        // 1. date recorded
        if let date = managedObject.valueForKey(kNSDateRecorded) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: date);
            conditionDetail.dateRecorded = dateTuple.0.description;
        }
        
        // 2. onset date and time
        if let onsetNSDateTime = managedObject.valueForKey(kOnsetNSDateTime) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: onsetNSDateTime);
            conditionDetail.onsetDateTime = dateTuple.0.description;
        }
        
        // 3. verification status
        if let verificationStatus = managedObject.valueForKey(kVerificationStatus) as? String {
            conditionDetail.verificationStatus = verificationStatus;
        }

        // 4. clinical status
        if let clinicalStatus = managedObject.valueForKey(kClinicalStatus) as? String {
            conditionDetail.clinicalStatus = clinicalStatus;
        }

        // 5. code
        if let code = managedObject.valueForKey(kCode) as? String {
            conditionDetail.code = code;
        }

        
        return conditionDetail;
    }
    
    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.conditions { (conditions, error) in

            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            var conditionDetails : [IHistoryItemDetail]? = [IHistoryItemDetail]()
            if let conditions = conditions {
                for condition in conditions {
                    let conditionDetail = self.buildConditionDetail(condition);
                    conditionDetails?.append(conditionDetail)
                    // self.createManagedObjectFromProcedureDetail(conditionDetail);
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: conditionDetails);
                }
            })
        }
    }
    
    func buildConditionDetail(condition: Condition) -> ConditionDetail {
        let conditionDetail = ConditionDetail();
        
        // 1. Code
        if let code = condition.code,
            text = code.text {
            conditionDetail.primaryText = text;
            conditionDetail.code = text.capitalizedString;
        }
        
        // 2. Date first recorded
        if let dateRecorded = condition.dateRecorded {
            conditionDetail.dateRecorded = dateRecorded.description;
            conditionDetail.nsDateRecorded = dateRecorded.nsDate;
        }
        
        // 3. Onset date
        if let dateTime = condition.onsetDateTime {
            conditionDetail.onsetDateTime = dateTime.description;
            conditionDetail.onsetNSDateTime = dateTime.nsDate;
        }
        
        // 4. Verification Status
        conditionDetail.verificationStatus = condition.verificationStatus?.capitalizedString;
        
        // 5. Clinical Status
        conditionDetail.clinicalStatus = condition.clinicalStatus?.capitalizedString;
        
        return conditionDetail;
    }
    
    func createManagedObjectFromProcedureDetail(conditionDetail : ConditionDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kConditionDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary text
        if let primaryText = conditionDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. secondary text
        if let secondaryText = conditionDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. code
        if let code = conditionDetail.code {
            newManagedObject.setValue(code, forKey: kCode)
        }
        
        // 4. date recorded
        if let nsDate = conditionDetail.nsDateRecorded {
            newManagedObject.setValue(nsDate, forKey: self.kNSDateRecorded)
        }
        
        // 5. onset date
        if let nsDate = conditionDetail.onsetNSDateTime {
            newManagedObject.setValue(nsDate, forKey: self.kOnsetNSDateTime)
        }
        
        // 6. verification status
        if let verificationStatus = conditionDetail.verificationStatus {
            newManagedObject.setValue(verificationStatus, forKey: self.kVerificationStatus)
        }
        
        // 7. clinicial status
        if let clinicalStatus = conditionDetail.clinicalStatus {
            newManagedObject.setValue(clinicalStatus, forKey: self.kClinicalStatus)
        }
        
        // 8. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);
    }
    
}

