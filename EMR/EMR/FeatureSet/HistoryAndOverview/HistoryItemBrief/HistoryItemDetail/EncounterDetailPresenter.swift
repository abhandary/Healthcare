//
//  EncounterDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART
import CoreData

class EncounterDetail : IHistoryItemDetail {
    var primaryText : String?
    var secondaryText : String?
    
    var encounterStart  : String?
    var encounterEnd    : String?
    
    var encounterStartDate  : NSDate?
    var encounterEndDate    : NSDate?
    
    var encounterClass  : String?
    var encounterStatus : String?
    var encounterReason : String?
}

class EncounterDetailPresenter : IHistoryItemDetailPresenter
{
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    
    
    
    let kEncounterDetailEntity = "EncounterDetail";
    let kEncounterStart        = "encounterStart";
    let kEncounterEnd          = "encounterEnd";
    let kEncounterStartDate    = "encounterStartDate";
    let kEncounterEndDate      = "encounterEndDate";
    let kEncounterClass        = "encounterClass";
    let kEncounterStatus       = "encounterStatus"
    let kEncounterReason       = "encounterReason";
    
    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // 1. setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kEncounterStartDate, ascending: false)
        builder.sortDescriptors = [sortDescriptor]

        // 2. get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: self.kEncounterDetailEntity);
        return interactor
    }()
    
    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }

    
    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        let encounterDetail = EncounterDetail();
        
        // 1. encouter start
        if let start = managedObject.valueForKey(kEncounterStart) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: start);
            encounterDetail.encounterStart = dateTuple.0.description;
        }
        
        // 2. encounter end
        if let end = managedObject.valueForKey(kEncounterEnd) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: end);
            encounterDetail.encounterEnd = dateTuple.0.description;
        }
        
        // 3. encounter class
        if let encounterClass = managedObject.valueForKey(kEncounterClass) as? String {
            encounterDetail.encounterClass = encounterClass;
        }

        // 4. encounter status
        if let encounterStatus = managedObject.valueForKey(kEncounterStatus) as? String {
            encounterDetail.encounterStatus = encounterStatus;
        }

        // 5. encounter reason
        if let encounterReason = managedObject.valueForKey(kEncounterReason) as? String {
            encounterDetail.encounterReason = encounterReason;
        }

        return encounterDetail;
    }
    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.encounters { (encounters, error) in
            
            
            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            var encountersDetailsList : [IHistoryItemDetail]?  = [IHistoryItemDetail]();
            
            if var encounters = encounters {
                
                // 1. encounters sort descending in time
                encounters = encounters.sort({ (lhs, rhs) -> Bool in
                    if let lperiod = lhs.period,
                        rperiod  = rhs.period,
                        lstart = lperiod.start,
                        rstart = rperiod.start {
                        
                        return lstart.nsDate.compare(rstart.nsDate) == NSComparisonResult.OrderedDescending;
                    }
                    return true;
                })
                
                // 2. Created rows for history detail table view and
                //    create encounters data set
                for encounter in encounters {
                    let encounterDetail = self.buildEncounterDetail(encounter);
                    // self.createManagedObjectFromEncounterDetail(encounterDetail);
                    encountersDetailsList?.append(encounterDetail);
                }
            }
            
            self.coreDataInteractor.saveContext();
            
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: encountersDetailsList);
                }
            })
        }
    }
    
    func buildEncounterDetail(encounter: Encounter) -> EncounterDetail {
        let encounterDetail = EncounterDetail();
        
        // primary, secondary text and period
        if let period = encounter.period,
            start = period.start,
            end   = period.end {
            encounterDetail.primaryText = "Admitted on \(start.date.description)";
            encounterDetail.secondaryText = "Discharged on \(end.date.description)";
            encounterDetail.encounterStart = "Admitted on \(start.date.description)";
            encounterDetail.encounterEnd   = "Discharged on \(end.date.description)";
            encounterDetail.encounterStartDate = start.date.nsDate;
            encounterDetail.encounterEndDate   = end.date.nsDate;
        }
        
        // class
        if let class_str = encounter.class_str {
            encounterDetail.encounterClass = class_str.capitalizedString

        }
        
        // reason
        if let reason = encounter.reason {
            encounterDetail.encounterReason = reason.description;

        }
        
        // status
        if let status = encounter.status {
            encounterDetail.encounterStatus = status.capitalizedString;
        }
        
        return encounterDetail;
    }
    
    func createManagedObjectFromEncounterDetail(encounterDetail : EncounterDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kEncounterDetailEntity,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary text
        if let primaryText = encounterDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. secondary text
        if let secondaryText = encounterDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. encounter start date
        if let encounterStartDate = encounterDetail.encounterStartDate {
            newManagedObject.setValue(encounterStartDate, forKey: kEncounterStartDate)
        }
        
        // 4. encounter end date
        if let encounterEndDate = encounterDetail.encounterEndDate {
            newManagedObject.setValue(encounterEndDate, forKey: kEncounterEndDate)
        }
        
        // 5. encounter class
        if let encounterClass = encounterDetail.encounterClass {
            newManagedObject.setValue(encounterClass, forKey: kEncounterClass)
        }
        
        // 6. encounter status
        if let encounterStatus = encounterDetail.encounterStatus {
            newManagedObject.setValue(encounterStatus, forKey: kEncounterStatus)
        }
        
        // 7. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);

    }
    
}

