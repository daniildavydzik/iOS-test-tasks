//
//  LoanMO+CoreDataProperties.swift
//  TestTask
//
//  Created by Daniel Davydzik on 24/03/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//
//

import Foundation
import CoreData


extension LoanMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoanMO> {
        return NSFetchRequest<LoanMO>(entityName: "Loan")
    }

    @NSManaged public var name: String?
    @NSManaged public var loan_amount: Int16
    @NSManaged public var use: String?
    @NSManaged public var country: String?

}
