//
//  ImmunizationDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART
import CoreData

class ImmunizationDetail : IHistoryItemDetail {
    
    var primaryText : String?
    var secondaryText : String?
    

    var date            : String?
    var nsDate          : NSDate?
    var vaccineCode     : String?
    var given           : String?
    var selfReported    : String?
    var givenBool           : Bool?
    var selfReportedBool    : Bool?

}


class ImmunizationDetailPresenter : IHistoryItemDetailPresenter {
    
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    
    let kDate           = "date"
    let kNSDate         = "nsDate"
    let kVaccineCode    = "vaccineCode"
    let kGiven          = "given"
    let kSelfReported   = "selfReported"
    let kImmunizationDetailEntityName = "ImmunizationDetail";

    // MARK: - Public Methods
    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kNSDate, ascending: false)
        builder.sortDescriptors = [sortDescriptor]

        // get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: self.kImmunizationDetailEntityName);
        return interactor
    }()

    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }

    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        let immunizationDetail = ImmunizationDetail();
        
        if let date = managedObject.valueForKey(kNSDate) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: date);
            immunizationDetail.date = dateTuple.0.description;
        }
        
        if let vaccineCode = managedObject.valueForKey(kVaccineCode) as? String {
            immunizationDetail.vaccineCode = vaccineCode;
        }
        
        if let given = managedObject.valueForKey(kGiven) as? Bool {
            immunizationDetail.given = (given == true ?  "YES" : "NO");
        }
        
        if let selfReported = managedObject.valueForKey(kSelfReported) as? Bool {
            immunizationDetail.selfReported = (selfReported == true ?  "YES" : "NO");
        }
        
        return immunizationDetail;
    }

    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.immunizations { (immunizations, error) in

            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            var immunizationDetails : [IHistoryItemDetail]? = [IHistoryItemDetail]()
            if let immunizations = immunizations {
                for immunization in immunizations {
                    let immunizationDetail = self.buildImmunizationDetail(immunization);
                    immunizationDetails!.append(immunizationDetail);
                    // self.createManagedObjectFromImmunizationDetail(immunizationDetail);
                }
            }
            self.coreDataInteractor.saveContext();            
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: immunizationDetails);
                }
            })
        }
    }
    
    // MARK: - Internal private routines
    
    private func buildImmunizationDetail(immunization: Immunization) -> ImmunizationDetail {
        let immunizationDetail = ImmunizationDetail();
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kImmunizationDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary and secondary text
        if let vaccinationCode = immunization.vaccineCode,
            coding = vaccinationCode.coding where coding.count > 0,
            let display = coding[0].display,
            date = immunization.date {
            
            immunizationDetail.primaryText = display.capitalizedString;
            newManagedObject.setValue(immunizationDetail.primaryText, forKey: kPrimaryText)

    
            if let wasNotGiven = immunization.wasNotGiven where wasNotGiven == true {
                immunizationDetail.secondaryText = "Noted as NOT GIVEN on \(date)"
                immunizationDetail.given = "No";
            } else {
                immunizationDetail.secondaryText = "Noted as GIVEN on \(date)"
                immunizationDetail.given = "Yes";
            }
            
            newManagedObject.setValue(immunizationDetail.secondaryText, forKey: kSecondaryText)
            
            immunizationDetail.date = date.description
            immunizationDetail.nsDate = date.nsDate;
            immunizationDetail.vaccineCode = display.capitalizedString;
        }

        // 2. Self Reported
        if let selfReproted = immunization.reported {
            immunizationDetail.selfReported = selfReproted == true ? "Yes" : "No"
        }
        
        return immunizationDetail;
    }
    
    func createManagedObjectFromImmunizationDetail(immunizationDetail : ImmunizationDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kImmunizationDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary text
        if let primaryText = immunizationDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. secondary text
        if let secondaryText = immunizationDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. vaccine code
        if let vaccineCode = immunizationDetail.vaccineCode {
            newManagedObject.setValue(vaccineCode, forKey: kVaccineCode)
        }
        
        // 4. date
        if let nsDate = immunizationDetail.nsDate {
            newManagedObject.setValue(nsDate, forKey: kNSDate)
        }
        
        // 5. given
        if let givenBool = immunizationDetail.givenBool {
            newManagedObject.setValue(givenBool, forKey: kGiven)
        }
        
        // 6. self reported
        if let selfReportedBool = immunizationDetail.selfReportedBool {
            newManagedObject.setValue(selfReportedBool, forKey: kSelfReported)
        }
        
        // 7. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);
    }

}
