//
//  AllergyDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART
import CoreData

class ManifestationDetail {
    init(text : String, severity : String) {
        self.text = text;
        self.severity = severity;
    }
    init() {
        
    }
    var text : String?
    var severity : String?
}

class AllergyDetail : IHistoryItemDetail {
    var primaryText : String?
    var secondaryText : String?
    var substance : String?
    var manifestations : [ManifestationDetail]?
}


class AllergyDetailPresenter : IHistoryItemDetailPresenter {

    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?

    let kSubstance      = "substance"
    let kManifestations = "manifestations"
    let kManifestationText = "text";
    let kManifestationSeverity = "severity"
    let kAllergyDetailEntityName = "AllergyDetail";
    let kManifestationDetailEntityName = "ManifestationDetail";
    
    var manifestations : [(String?, String?)]?

    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // 1. setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kSubstance, ascending: false)
        builder.sortDescriptors = [sortDescriptor]

        // 2. get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: self.kAllergyDetailEntityName);
        return interactor
    }()
    
    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }

    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        
        let allergyDetail = AllergyDetail();
        
        // 1. substance
        if let substance = managedObject.valueForKey(kSubstance) as? String {
            allergyDetail.substance = substance;
        }
        
        // 2. manifestations
        if let manifestations = managedObject.valueForKey(kManifestations) as? [NSManagedObject] {
            allergyDetail.manifestations  = [ManifestationDetail]();
            for manifestationObject in manifestations {
                let manifestation = ManifestationDetail();
                if let manifestationText = manifestationObject.valueForKey(kManifestationText) as? String {
                    manifestation.text = manifestationText;
                }
                if let manifestationSeverity = manifestationObject.valueForKey(kManifestationSeverity) as? String {
                    manifestation.severity = manifestationSeverity;
                }
                allergyDetail.manifestations?.append(manifestation);
            }
        }
        
        return allergyDetail;
    }

    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.allergies { (allergies, error) in
            
            
            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            var allergyDetails : [IHistoryItemDetail]? = [IHistoryItemDetail]();
            if let allergies = allergies {
                for allergy in allergies {
                    let allergyDetail = self.buildAllegyDetail(allergy)
                    allergyDetails?.append(allergyDetail);
                    // self.createManagedObjectFromAllergyDetail(allergyDetail);
                }
            }
            
            self.coreDataInteractor.saveContext();
            
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: allergyDetails);
                }
            })
        }
    }
    
    func buildAllegyDetail(allergy: AllergyIntolerance) -> AllergyDetail  {
        let allergyDetail = AllergyDetail();
        
        // 1. primary and secondary text
        
        if let substance = allergy.substance,
            reactions = allergy.reaction where reactions.count > 0,
            let manifestation = reactions[0].manifestation where manifestation.count > 0,
            let manifestationText = manifestation[0].text {
            
            allergyDetail.primaryText = substance.text?.capitalizedString;
            allergyDetail.secondaryText = manifestationText.capitalizedString
            allergyDetail.substance = substance.text?.capitalizedString
            
            // 2. Manifestations
            allergyDetail.manifestations = [ManifestationDetail]();
            for reaction in reactions {
                if let manifestations = reaction.manifestation {
                    for manifestation in manifestations {
                        let manifestationDetail = ManifestationDetail();
                        manifestationDetail.text = manifestation.text;
                        manifestationDetail.severity = reaction.severity;
                        allergyDetail.manifestations?.append(manifestationDetail)
                    }
                }
            }
        }
        return allergyDetail;
    }
    
    func createManagedObjectFromAllergyDetail(allergyDetail : AllergyDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject
                = NSEntityDescription.insertNewObjectForEntityForName(self.kAllergyDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary text
        if let primaryText = allergyDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. secondary text
        if let secondaryText = allergyDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. substance
        if let substance = allergyDetail.substance {
            newManagedObject.setValue(substance, forKey: kSubstance)
        }
        
        // 4. manifestations
        if let manifestations = allergyDetail.manifestations {
            let manifestationsSet = newManagedObject.valueForKeyPath("manifestations") as! NSMutableSet;
            for manifestation in manifestations {
                let manifestationObject
                    = NSEntityDescription.insertNewObjectForEntityForName(self.kManifestationDetailEntityName,
                                                                          inManagedObjectContext: context)
                manifestationObject.setValue(manifestation.text, forKey: kManifestationText);
                manifestationObject.setValue(manifestation.severity, forKey: kManifestationSeverity);
                manifestationsSet.addObject(manifestationObject);
            }
        }
        
        // 5. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);
    }
}



