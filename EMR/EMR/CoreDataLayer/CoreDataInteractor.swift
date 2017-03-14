//
//  CoreDataInteractor.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/31/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import CoreData



class CoreDataInteractorBuilder
{
    var sortDescriptors : [NSSortDescriptor]?
    var fetchBatchSize : Int?
    var patientID      : String?
    
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    
    func build(patientID : String, entityName : String) -> CoreDataInteractor  {
        let coreDataInteractor = CoreDataInteractor(patientID: patientID, entityName: entityName);
        coreDataInteractor.sortDescriptors = self.sortDescriptors;
        coreDataInteractor.fetchBatchSize = self.fetchBatchSize;
        coreDataInteractor.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        return coreDataInteractor;
    }
}


class CoreDataInteractor : NSObject {

    // MARK: - internal properties
    private weak var _fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    private let coreDataStack = CoreDataStack.sharedInstance;
    private var _fetchedResultsController: NSFetchedResultsController? = nil
    

    // MARK: - public properties
    var patientID           : String!
    var entityName          : String!
    var sortDescriptors     : [NSSortDescriptor]?
    var fetchBatchSize      : Int?
    
    
    weak var fetchedResultsControllerDelegate   : NSFetchedResultsControllerDelegate? {
        set { _fetchedResultsController?.delegate = newValue;
            _fetchedResultsControllerDelegate = newValue;
        }
        get { return _fetchedResultsControllerDelegate; }
    }
    
    init(patientID : String, entityName : String) {
        self.patientID = patientID;
        self.entityName = entityName;
    }
    
    
    // MARK: - NSFetchedResultsController and related
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequestFor(self.patientID),
                                       managedObjectContext: coreDataStack.managedObjectContext,
                                       sectionNameKeyPath: nil,
                                       cacheName: self.patientID)
        
        aFetchedResultsController.delegate = self.fetchedResultsControllerDelegate;
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            log.error("error while performing fetch using the fetchResultsController: \(error)")
        }
        
        return _fetchedResultsController!
    }
    
    
    func fetchRequestFor(patientID : String) -> NSFetchRequest
    {
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: coreDataStack.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        if let fetchBatchSize = self.fetchBatchSize {
            fetchRequest.fetchBatchSize = fetchBatchSize;
        }
        
        // Set the predicate
        fetchRequest.predicate = NSPredicate(format: "patientID = %@", patientID)
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the sort key as appropriate.
        if let sortDescriptors = self.sortDescriptors {
            // let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        return fetchRequest;
    }
    
    func saveContext() {
        let managedObjectContext = self.fetchedResultsController.managedObjectContext;
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                assert(false);
            }
        }

    }
}
