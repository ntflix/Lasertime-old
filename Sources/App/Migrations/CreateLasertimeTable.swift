//
//  File.swift
//  
//
//  Created by Felix Weber on 18/05/2020.
//

import Fluent

struct CreateLasertime: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lasertime")
            .id()
            .field("userID", .string, .required)
            .field("cutTime", .datetime)
            .field("descript", .string)
            .field("paid", .datetime)
            .field("duration", .int)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lasertime").delete()
    }
}
