//
//  AdminController.swift
//  App
//
//  Created by Felix Weber on 18/05/2020.
//

import Fluent
import Vapor

struct AdminController {
    func index(req: Request) throws -> EventLoopFuture<[Admin]> {
//         returns all admins with all details (except password hash). only for testing/development.
        if (req.application.environment == .development) || (req.application.environment == .testing) {
            return Admin.query(on: req.db).all().mapEach { admin in
                Admin(
                    id: admin.id!,
                    password: "",
                    email: admin.email
                )   //manually mapping to remove password
            }
        }
        
        return req.eventLoop.makeFailedFuture(Abort(.badRequest))
    }
    
    func getAdmin(req: Request) throws -> EventLoopFuture<Admin> {
        let admin = try req.auth.require(Admin.self)      // checks if email is provided, safely unwraps it
        return Admin.find(admin.id!, on: req.db)
            .unwrap(or: Abort(.notFound))
            .map {
                return $0
        }
    }

    func create(req: Request) throws -> EventLoopFuture<[String]> {
        let admin = try req.content.decode(Admin.self)
        admin.password = try Bcrypt.hash(admin.password)

        return admin.save(on: req.db).map {[
            admin.email,
            admin.id!.uuidString
        ]}
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Admin.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
