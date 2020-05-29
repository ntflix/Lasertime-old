//
//  AdminController.swift
//  App
//
//  Created by Felix Weber on 18/05/2020.
//

import Fluent
import Vapor

struct AdminController {
    func index(req: Request) throws -> EventLoopFuture<[[String: String]]> {
//         returns all admins with all details (except password hash). only for testing/development.
        if (req.application.environment == .development) || (req.application.environment == .testing) {
            return Admin.query(on: req.db).all().mapEach { admin in
                [
                    "id": admin.id!.description,
                    "email": admin.email
                ]
            }
        }
        
        return req.eventLoop.makeFailedFuture(Abort(.badRequest))
    }
    
    func getAdmin(req: Request) throws -> EventLoopFuture<[String: String]> {
        let admin = try req.auth.require(Admin.self)      // checks if email is provided, safely unwraps it
        return Admin.find(admin.id!, on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { admin in
                [
                    "id": admin.id!.description,
                    "email": admin.email
                ]
        }
    }

    func create(req: Request) throws -> EventLoopFuture<[String: String]> {
        let admin = try req.content.decode(Admin.self)

        do {
            if admin.password.count < 8 {
                return req.eventLoop.makeFailedFuture(Abort(.custom(code: 502, reasonPhrase: "Password must be at least 8 characters")))
            }
            admin.password = try Bcrypt.hash(admin.password)
        } catch {
            /// bcrypt hashing failed
            return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }
        
        return admin.save(on: req.db).map {[
            "email": admin.email,
            "id": admin.id!.uuidString
        ]}
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Admin.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
