//
//  HistoryDetailFactory.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/22/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation
import CoreData

protocol IHistoryItemDetail {
    var primaryText : String?  { get set }
    var secondaryText : String? { get set }
}

protocol IHistoryItemDetailPresenter : class {
    
    func historyItemsFetchedResultsControllerController () -> NSFetchedResultsController;
    func fetchHistoryItems (callback : ((result: [IHistoryItemDetail]?) -> ())? );
    func historyItemFromManagedObject(managedObject : NSManagedObject) -> IHistoryItemDetail;
    weak var fetchedResultsControllerDelegate : NSFetchedResultsControllerDelegate? { get set }
}

class HistoryDetailPresenterFactory {    
    func historyDetailForItem(id : String) -> IHistoryItemDetailPresenter? {
        switch id {
        case kEncounters:
            return EncounterDetailPresenter();
        case kImmunizations:
            return ImmunizationDetailPresenter();
        case kProcedures:
            return ProcedureDetailPresenter();
        case kConditions:
            return ConditionDetailPresenter();
        case kMedicationOrders:
            return MedicationOrderDetailPresenter();
        case kObservations:
            return ObservationDetailPresenter();
        case kAllergies:
            return AllergyDetailPresenter();
        case kReports:
            return ReportDetailPresenter();
        default:
            return nil
        }
    }
}
