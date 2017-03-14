//
//  ReportDetail.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import SMART
import CoreData

class ReportDetail : IHistoryItemDetail {
    var primaryText     : String?
    var secondaryText   : String?
    
    var category        : String?
    var dateIssued      : String?
    var nsDateIssued    : NSDate?
    var code            : String?
}


class ReportDetailPresenter : IHistoryItemDetailPresenter {
    
    let kReportDetailEntityName = "ReportDetail";
    let kCategory = "category";
    let kNSDateIssued = "nsDateIssued"
    let kCode = "code"
    
    let fhirInterpreter = SMARTFHIRInterpreter.sharedInstance;
    
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate?
    
    lazy var coreDataInteractor : CoreDataInteractor =  {
        
        // 1. setup the core date interactor builder
        let builder = CoreDataInteractorBuilder();
        builder.fetchedResultsControllerDelegate = self.fetchedResultsControllerDelegate;
        let sortDescriptor = NSSortDescriptor(key: self.kNSDateIssued, ascending: false)
        builder.sortDescriptors = [sortDescriptor]

        // 2. get the core data interactor
        let interactor = builder.build(self.fhirInterpreter.patient!.id!, entityName: self.kReportDetailEntityName);
        return interactor
    }()
    
    
    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController {
        return self.coreDataInteractor.fetchedResultsController
    }
    
    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail {
        
        let reportDetail = ReportDetail();
        
        let kCategory = "category";
        let kNSDateIssued = "nsDateIssued"

        
        // 1. date issued
        if let date = managedObject.valueForKey(kNSDateIssued) as? NSDate {
            let dateTuple = DateNSDateConverter.sharedConverter.parse(date: date);
            reportDetail.dateIssued = dateTuple.0.description;
        }
        
        // 2. code
        if let code = managedObject.valueForKey(kCode) as? String {
            reportDetail.code = code;
        }

        // 3. category
        if let category = managedObject.valueForKey(kCategory) as? String {
            reportDetail.category = category;
        }

        return reportDetail;
    }
    
    
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? ) {
        fhirInterpreter.reports { (reports, error) in

            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), {
                    if let callback = callback {
                        callback(result: nil);
                    }
                })
            }
            
            // 1. create the report details
            var reportDetails : [IHistoryItemDetail]? = [IHistoryItemDetail]();
            if let reports = reports {
                for report in reports {
                    let reportDetail = self.buildReportDetails(report);
                    reportDetails?.append(reportDetail);
                    // self.createManagedObjectFromReportDetail(reportDetail);
                }
            }
            
            // 2. sync to core data
            self.coreDataInteractor.saveContext();
            
            // 3. send callback
            dispatch_async(dispatch_get_main_queue(), {
                if let callback = callback {
                    callback(result: reportDetails);
                }
            })
        }
    }
    
    func buildReportDetails(report : DiagnosticReport) -> ReportDetail {
        let reportDetail = ReportDetail();
        
        // primary and secondary text
        if let code = report.code,
            coding = code.coding where coding.count > 0,
            let display = coding[0].display ,
            let date = report.effectiveDateTime {
            
            reportDetail.primaryText = display;
            reportDetail.secondaryText = " on \(date)"
            
            // date issued
            reportDetail.dateIssued = date.description;
            reportDetail.nsDateIssued = date.nsDate;
            
            // code
            if coding.count > 0 {
                reportDetail.code = coding[0].display;
            }
        }
        
        // category 
        if let category = report.category,
            coding = category.coding where coding.count > 0,
            let code = coding[0].display {
            reportDetail.category = code;
        }
        
        return reportDetail;
    }
    
    func createManagedObjectFromReportDetail(reportDetail : ReportDetail)  {
        
        let context = historyItemsFetchedResultsControllerController().managedObjectContext
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(self.kReportDetailEntityName,
                                                                                   inManagedObjectContext: context)
        
        // 1. primary text
        if let primaryText = reportDetail.primaryText {
            newManagedObject.setValue(primaryText, forKey: kPrimaryText)
        }
        
        // 2. secondary text
        if let secondaryText = reportDetail.secondaryText {
            newManagedObject.setValue(secondaryText, forKey: kSecondaryText)
        }
        
        // 3. code
        if let code = reportDetail.code {
            newManagedObject.setValue(code, forKey: kCode)
        }
        
        // 4. date issued
        if let nsDate = reportDetail.nsDateIssued {
            newManagedObject.setValue(nsDate, forKey: self.kNSDateIssued)
        }
        
        // 5. category
        if let category = reportDetail.category {
            newManagedObject.setValue(category, forKey: self.kCategory)
        }
        
        // 6. patient ID
        newManagedObject.setValue(self.fhirInterpreter.patient!.id!, forKey: kPatientID);
    }

}





