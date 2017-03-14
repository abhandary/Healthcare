//
//  ProcedureDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART
import CoreData

class ProcedureDetail : IHistoryItemDetail {
    var primaryText : String?
    var secondaryText : String?
 
    var code          : String?
    var datePerformed : String?
    var nsDatePerformed : NSDate?
}


class ProcedureDetailPresenter : IHistoryItemDetailPresenter {

    let kDatePerformed      = "datePerformed";
    let kNSDatePerformed    = "nsDatePerformed";
    let kCode               = "code";
    let kProcedureDetailEntityName = "ProcedureDetail"
    
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;

    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // 1. setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kNSDatePerformed, ascending: false)
        builder.sortDescriptors = [sortDescriptor]

        // 2. get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: "ProcedureDetail");
        return interactor
    }()

    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }

    
    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        let procedureDetail = ProcedureDetail();
        
        // 1. date performed
        if let date = managedObject.valueForKey(kNSDatePerformed) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: date);
            procedureDetail.datePerformed = dateTuple.0.description;
        }
        
        // 2. code
        if let code = managedObject.valueForKey(kCode) as? String {
            procedureDetail.code = code;
        }
        
        return procedureDetail;
    }

    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.procedures { (procedures, error) in

            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            var procedureDetails : [IHistoryItemDetail]?  = [IHistoryItemDetail]();
            if let procedures = procedures {
                for procedure in procedures {
                    let procedureDetail = self.buildProcedureDetails(procedure);
                    procedureDetails?.append(procedureDetail)
                    // self.createManagedObjectFromProcedureDetail(procedureDetail);
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: procedureDetails);
                }
            })
        }
    }
    
    func buildProcedureDetails(procedure : Procedure) -> ProcedureDetail {
        let procedureDetail = ProcedureDetail();
        
        // primary text and secondary text
        if let code = procedure.code,
            text = code.text {
            procedureDetail.primaryText = text.capitalizedString;
            procedureDetail.code = text.capitalizedString;
        }
        
        if let date = procedure.performedDateTime {
            procedureDetail.secondaryText = " on \(date)"
            procedureDetail.datePerformed = date.description;
            procedureDetail.nsDatePerformed = date.nsDate;
        } else {
            procedureDetail.datePerformed = kNotAvailableText
        }
        
        return procedureDetail;
    }
    
    func createManagedObjectFromProcedureDetail(procedureDetail : ProcedureDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kProcedureDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary text
        if let primaryText = procedureDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. secondary text
        if let secondaryText = procedureDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. code
        if let code = procedureDetail.code {
            newManagedObject.setValue(code, forKey: kCode)
        }
        
        // 4. date performed
        if let nsDate = procedureDetail.nsDatePerformed {
            newManagedObject.setValue(nsDate, forKey: self.kNSDatePerformed)
        }
        
        // 5. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);
    }
}



