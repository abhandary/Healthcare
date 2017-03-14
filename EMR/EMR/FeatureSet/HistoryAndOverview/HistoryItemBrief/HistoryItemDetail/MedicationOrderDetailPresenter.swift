//
//  MedicationOrderDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART
import CoreData


class DosageInstruction {
    var text : String?
    init(text : String) {
        self.text = text;
    }
    init() {
        
    }
}

class MedicationOrderDetail : IHistoryItemDetail {
    var primaryText : String?
    var secondaryText : String?
    
    var dosageInstructions : [DosageInstruction]?
    var code : String?
}


class MedicationOrderDetailPresenter : IHistoryItemDetailPresenter {
    
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?

    let kDosageInstructions = "dosageInstructions";
    let kCode               = "code"
    let kDosageInstructionText = "text";
    let kMedicationOrderDetailEntityName = "MedicationOrderDetail";
    let kDosageInstructionEntityName = "DosageInstruction";

    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kCode, ascending: false)
        builder.sortDescriptors = [sortDescriptor]

        // get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: self.kMedicationOrderDetailEntityName);
        return interactor
    }()
    
    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }

    
    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        
        let medicationOrderDetail = MedicationOrderDetail();
        
        if let code = managedObject.valueForKey(kCode) as? String {
            medicationOrderDetail.code = code;
        }

        // append the dosage instructions
        if let dosageInstructions = managedObject.valueForKeyPath(kDosageInstructions) as? NSSet {
            medicationOrderDetail.dosageInstructions = [DosageInstruction]();
            for dosageInstructionObject in dosageInstructions {
                if let dosageInstructionText = dosageInstructionObject.valueForKey(kDosageInstructionText) as? String {
                    medicationOrderDetail.dosageInstructions!.append(DosageInstruction(text: dosageInstructionText));
                }
            }
        }

        return medicationOrderDetail;
    }

    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.medicationOrders { (medicationOrders, error) in
            
            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            var medicationOrderDetails :  [IHistoryItemDetail]? = [IHistoryItemDetail]();
            if let medicationOrders = medicationOrders {
                for medicationOrder in medicationOrders {
                    let medicationOrderDetail = self.buildMedicationOrderDetail(medicationOrder);
                    medicationOrderDetails?.append(medicationOrderDetail);
                    // self.createManagedObjectFromMedicationOrderDetail(medicationOrderDetail);
                }
            }
            self.coreDataInteractor.saveContext();            
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: medicationOrderDetails);
                }
            })
        }
    }
    
    func buildMedicationOrderDetail(medicationOrder: MedicationOrder) -> MedicationOrderDetail {
        let medicationOrderDetail = MedicationOrderDetail();
        
        // primary text
        if let medicationCodeableConcept = medicationOrder.medicationCodeableConcept,
            text = medicationCodeableConcept.text {
            medicationOrderDetail.primaryText = text.capitalizedString;
            medicationOrderDetail.code = text.capitalizedString;
        }
        
        // dosage instructions
        medicationOrderDetail.dosageInstructions = [DosageInstruction]();
        if let dosageInstructions = medicationOrder.dosageInstruction {
            for dosageInstruction in dosageInstructions {
                if let text = dosageInstruction.text {
                    medicationOrderDetail.dosageInstructions?.append(DosageInstruction(text: text))
                }
            }
            if medicationOrderDetail.dosageInstructions?.count == 0 {
                medicationOrderDetail.dosageInstructions?.append(DosageInstruction(text: kNotAvailableText))
            }
        } else {
            medicationOrderDetail.dosageInstructions?.append(DosageInstruction(text: kNotAvailableText))
        }
        
        
        return medicationOrderDetail;
    }
    
    func createManagedObjectFromMedicationOrderDetail(medicationOrderDetail : MedicationOrderDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kMedicationOrderDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. add primary text
        if let primaryText = medicationOrderDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. add secondary text
        if let secondaryText = medicationOrderDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. add code
        if let code = medicationOrderDetail.code {
            newManagedObject.setValue(code, forKey: kCode)
        }
        
        // 4. add dosage instructions
        if let dosageInstructions = medicationOrderDetail.dosageInstructions {
            if let dosageInstructionsSet = newManagedObject.valueForKeyPath(kDosageInstructions) as? NSMutableSet {
                for dosageInstruction in dosageInstructions {
                    let dosageInstructionObject
                        = NSEntityDescription.insertNewObjectForEntityForName(self.kDosageInstructionEntityName,
                                                                                                inManagedObjectContext: context)
                    dosageInstructionObject.setValue(dosageInstruction.text, forKey: kDosageInstructionText);
                    dosageInstructionObject.setValue(NSDate(), forKey: kTimeStamp);
                    dosageInstructionsSet.addObject(dosageInstructionObject)
                }

            }
        }
        
        // 5. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);

    }

}


