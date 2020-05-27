//
//  CreateUser.swift
//  App
//
//  Created by Felix Weber on 17/05/2020.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("email", .string)
            .field("firstName", .string, .required)
            .field("lastName", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
