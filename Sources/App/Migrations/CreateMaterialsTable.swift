//
//  CreateMaterialsTable.swift
//  
//
//  Created by Felix Weber on 23/07/2020.
//

import Fluent

struct CreateMaterial: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("materials")
            .id()
            .field("name", .string)
            .field("price", .int) // pence per second
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("materials").delete()
    }
}
