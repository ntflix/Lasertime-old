//
//  UserController.swift
//  App
//
//  Created by Felix Weber on 17/05/2020.
//

import Fluent
import Vapor

struct UserController {
    func index(req: Request) throws -> EventLoopFuture<[User]> {
        //         returns all users with all details (except password hash). only for admins.
        return User.query(on: req.db).all().mapEach { user in
            User(
                id: user.id!,
                username: user.username,
                password: "",
                email: user.email,
                firstName: user.firstName,
                lastName: user.lastName
            )   //manually mapping to remove password
        }
    }
    
    func adminGetUser(req: Request) throws -> EventLoopFuture<User> {
        guard let username = req.parameters.get("username") else {  // cannot use traditional auth as it is an admin and not the user themselves
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: "username"))
        }
        return User.query(on: req.db)
            .filter(\.$username == username)
            .first()
            .unwrap(or: Abort(.notFound)) // will throw if no user exists
            .map { user in
                User(
                    id: user.id!,
                    username: user.username,
                    password: "", // manually mapping in order to remove password
                    email: user.email ?? "",
                    firstName: user.firstName,
                    lastName: user.lastName ?? ""
                )
        }
    }
    
    func getUser(req: Request) throws -> EventLoopFuture<[String: String]> {
        // if this fails, the function will throw an error to caller
        let user = try req.auth.require(User.self)    // safely unwrap username
        return User.find(user.id!, on: req.db)
            .unwrap(or: Abort(.notFound))
            .map {
                user in [
                    "username": user.username,
                    "email": user.email ?? "",
                    "id": user.id!.uuidString,
                    "firstName": user.firstName,
                    "lastName": user.lastName ?? ""
                    // manually mapping to *not* send back the password
                ]
        }
    }
    
    func hello(req: Request) throws -> String {
        let username = try req.auth.require(User.self).username
        return "Hello " + username + "!"
    }
    
    func create(req: Request) throws -> EventLoopFuture<[String: String]> {
        let user = try req.content.decode(User.self)
        
        do {
            if user.password.count < 8 {
                // TODO: Implement *actual* password requirements checker
                return req.eventLoop.makeFailedFuture(Abort(.custom(code: 502, reasonPhrase: "Password must be at least 8 characters")))
            }
            
            user.password = try Bcrypt.hash(user.password)
        } catch {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }
        
        return user.save(on: req.db).map {[
            "username": user.username,
            "id": user.id!.uuidString,
            ]}
    }
    
    /*
    func update(req: Request) throws -> EventLoopFuture<[String: String]> {
        let user = try req.auth.require(User.self)
        let newUser = try req.content.decode(User.self)
        
        if let _ = newUser.password {
            do {
                user.password = try Bcrypt.hash(user.password)
            } catch {
                return req.eventLoop.makeFailedFuture(Abort(.badRequest))
            }
        }
        
        return user.update(on: req.db).map {[
            "username": user.username,
            "email": user.email ?? "",
            "id": user.id!.uuidString,
            "firstName": user.firstName,
            "lastName": user.lastName ?? ""
            ]}
    }
    */
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.auth.require(User.self)
        return User.find(user.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
