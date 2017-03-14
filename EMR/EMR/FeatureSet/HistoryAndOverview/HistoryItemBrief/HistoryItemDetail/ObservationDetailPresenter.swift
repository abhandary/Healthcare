//
//  ObservationDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//


import Foundation
import SMART
import CoreData

class ObservationDetail : IHistoryItemDetail {
    var primaryText : String?
    var secondaryText : String?
    
    var code : String?
    var category : String?
    var effectiveDate : String?
    var effectiveNSDate : NSDate?
}


class ObservationDetailPresenter : IHistoryItemDetailPresenter {
    
    let kObservationDetailEntityName = "ObservationDetail";
    
    let kCode       = "code"
    let kCategory   = "category"
    let kEffectiveDate      = "effectiveDate"
    let kEffectiveNSDate    = "effectiveNSDate"
    
    
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // 1. setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kEffectiveNSDate, ascending: false)
        builder.sortDescriptors = [sortDescriptor]
        
        // 2. get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: "ObservationDetail");
        return interactor
    }()
    
    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }

    
    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        
        let observationDetail = ObservationDetail();
        
        // 1. effective date
        if let date = managedObject.valueForKey(kEffectiveNSDate) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: date);
            observationDetail.effectiveDate = dateTuple.0.description;
        }
        
        // 2. code
        if let code = managedObject.valueForKey(kCode) as? String {
            observationDetail.code = code;
        }
        
        // 3. category
        if let category = managedObject.valueForKey(kCategory) as? String {
            observationDetail.category = category;
        }
        
        return observationDetail;
    }
    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.observations { (observations, error) in

            
            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            
            
            var observationDetails : [IHistoryItemDetail]? = [IHistoryItemDetail]();
            if var observations = observations {
                
                // 1. encounters sort descending in time
                observations = observations.sort({ (lhs, rhs) -> Bool in
                    
                   if let lDate = lhs.effectiveDateTime,
                    rDate = rhs.effectiveDateTime {
                        return lDate.nsDate.compare(rDate.nsDate) == NSComparisonResult.OrderedDescending;
                    }
                    return true;
                })
                
                // 2. create the observation details array from the fetched observations
                for observation in observations {
                    let observationDetail = self.buildObservationDetail(observation);
                    observationDetails?.append(observationDetail);
                    // self.createManagedObjectFromObservationDetail(observationDetail);
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: observationDetails);
                }
            })
        }
    }
    
    func buildObservationDetail(observation: Observation) -> ObservationDetail {
        let observationDetail = ObservationDetail();
        
        if let code = observation.code,
            text = code.text {
            observationDetail.primaryText = text.capitalizedString;
            observationDetail.code = text.capitalizedString;
        }
        
        if let date = observation.effectiveDateTime {
            observationDetail.secondaryText = "Noted on \(date.description)";
            observationDetail.effectiveDate = date.description;
            observationDetail.effectiveNSDate = date.nsDate;
        } else {
            observationDetail.effectiveDate = kNotAvailableText
        }
        
        if let category = observation.category {
            observationDetail.category = category.text
        } else {
            observationDetail.category = kNotAvailableText
        }
        
        return observationDetail;
    }
    
    func createManagedObjectFromObservationDetail(observationDetail : ObservationDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kObservationDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary text
        if let primaryText = observationDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. secondary text
        if let secondaryText = observationDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. code
        if let code = observationDetail.code {
            newManagedObject.setValue(code, forKey: kCode)
        }
        
        // 4. effective date
        if let nsDate = observationDetail.effectiveNSDate {
            newManagedObject.setValue(nsDate, forKey: self.kEffectiveNSDate)
        }
        
        // 5. categroy
        if let category = observationDetail.category {
            newManagedObject.setValue(category, forKey: self.kCategory)
        }
        
        // 6. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);
    }

}

