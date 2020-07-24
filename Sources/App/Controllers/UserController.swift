//
//  UserController.swift
//  App
//
//  Created by Felix Weber on 17/05/2020.
//

import Fluent
import Vapor

struct UserController {
    func index(req: Request) throws -> EventLoopFuture<[[String: String]]> {
        return User.query(on: req.db).all().mapEach { user in
            [
                "id": user.id!.description,
                "username": user.username,
                "email": user.email ?? "",
                "firstName": user.firstName,
                "lastName": user.lastName ?? ""
            ]   //manually mapping to remove password
        }
    }
    
    func adminGetUser(req: Request) throws -> EventLoopFuture<[String: String]> {
        guard let username = req.parameters.get("username") else {  // cannot use traditional auth as it is an admin and not the user themselves
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: "username"))
        }
        return User.query(on: req.db)
            .filter(\.$username == username)
            .first()
            .unwrap(or: Abort(.notFound)) // will throw if no user exists
            .map { user in
                [
                    "id": user.id!.description,
                    "username": user.username,
                    "email": user.email ?? "",
                    "firstName": user.firstName,
                    "lastName": user.lastName ?? ""
                ]
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
        
        // Should probably put the following into a function
        
        /// Checks whether the items supplied actually have values and are not just empty strings
        let itemsWhichCannotBeEmpty: [String: String] = [
            user.firstName: "First name",
            user.username: "Username"
        ]
        
        var missingItem: String?
        
        itemsWhichCannotBeEmpty.forEach { item in
            if item.0.count == 0 {
                missingItem = item.1
            }
        }
        
        if let _ = missingItem {
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: missingItem!))
        }
        
        // Done checking. User supplied details seem OK here
        
        do {
            if user.password.count < 8 {
                // TODO: Implement *actual* password requirements checker. Not urgent. We can trust our users for now ;)
                return req.eventLoop.makeFailedFuture(Abort(.custom(code: 502, reasonPhrase: "Password must be at least 8 characters")))
            }
            user.password = try Bcrypt.hash(user.password)
        } catch {
            /// bcrypt hashing failed
            return req.eventLoop.makeFailedFuture(Abort(.internalServerError))
        }
        
        return user.save(on: req.db).map {[
            "username": user.username,
            "id": user.id!.uuidString,
            ]}
    }
    
    /*
    func update(req: Request) throws -> EventLoopFuture<[String: String]> {
        let authenticatedUser = try req.auth.require(User.self)
        let newUser = try req.content.decode(User.self)

        if let userID = authenticatedUser.id {
            return User.find(userID, on: req.db).flatMap { thisUser in
                // found authenticated user in database
                if let _ = thisUser {
                    // user exists
                    
                    //modifying authenticated user's details
                    thisUser?.username = newUser.username
                    thisUser?.email = newUser.email
                    thisUser?.firstName = newUser.firstName
                    thisUser?.lastName = newUser.lastName
                                        
                    if newUser.password != "" {
                        do {
                            if newUser.password.count < 8 {
                                // TODO: put password checking into its own function
                                return req.eventLoop.makeFailedFuture(Abort(.custom(code: 502, reasonPhrase: "Password must be at least 8 characters")))
                            }
                            thisUser?.password = try Bcrypt.hash(newUser.password)
                        } catch {
                            /// bcrypt hashing failed
                            return req.eventLoop.makeFailedFuture(Abort(.internalServerError))
                        }
                    }
                    
                    return thisUser!.update(on: req.db).map {
                        [
                            "username": thisUser!.username,
                            "email": thisUser!.email ?? "",
                            "id": thisUser!.id!.uuidString,
                            "firstName": thisUser!.firstName,
                            "lastName": thisUser!.lastName ?? ""
                        ]
                    }
                }
                return req.eventLoop.makeFailedFuture(Abort(.internalServerError))
            }
        } else {
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: "id"))
        }
    }
    */
     
    /*
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.auth.require(User.self)
        return User.find(user.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
     */
}
