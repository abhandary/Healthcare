//
//  Money.swift
//  SwiftFHIR
//
//  Generated from FHIR 1.6.0.9663 (http://hl7.org/fhir/StructureDefinition/Money) on 2016-08-12.
//  2016, SMART Health IT.
//

import Foundation


/**
 *  An amount of economic utility in some recognised currency.
 */
public class Money: Quantity {
	override public class var resourceName: String {
		get { return "Money" }
	}
	
	
	/** Initialize with a JSON object. */
	public required init(json: FHIRJSON?, owner: FHIRAbstractBase? = nil) {
		super.init(json: json, owner: owner)
	}

}

