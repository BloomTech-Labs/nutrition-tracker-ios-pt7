//
//  User+Convenience.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRepresentation: UserRepresentation? {
        guard let name = self.name else { return nil }
        return UserRepresentation(id: id, name: name, email: email, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    convenience init(id: UUID = UUID(), name: String, email: String, updatedAt: String, createdAt: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.email = email
    }
    
    convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let id = userRepresentation.id,
            let email = userRepresentation.email,
            let updatedAt = userRepresentation.updatedAt,
            let createdAt = userRepresentation.createdAt else { return nil }
        self.init(id: id, name: userRepresentation.name, email: email, updatedAt: updatedAt, createdAt: createdAt, context: context)
    }
}
