//
//  File.swift
//  
//
//  Created by Felix Weber on 18/05/2020.
//

import Fluent
import Vapor

struct LasertimeController {
    func index(req: Request) throws -> EventLoopFuture<[Lasertime]> {
        // returns all lasertime logs.
        return Lasertime.query(on: req.db).all()
    }
    
    func adminGetUserLasertime(req: Request) throws -> EventLoopFuture<EventLoopFuture<[Lasertime]>> {
        guard let username = req.parameters.get("username") else {  // cannot use traditional auth as it is an admin and not the user themselves
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: "username"))
        }
        return User.query(on: req.db)
            .filter(\.$username == username)
            .first()
            .unwrap(or: Abort(.notFound)) // will throw if no user exists
            .map {
                $0.id!
        }.map { userID in
            return Lasertime.query(on: req.db)
                .filter(\.$userID == userID)
                .all()
        }
    }
    
    func getUserLasertime(req: Request) throws -> EventLoopFuture<[Lasertime]> {
        guard let user = try? req.auth.require(User.self) else {    // can extract userID from result of (auth.require() -> User)
            throw Abort(.unauthorized)
        }
        return Lasertime.query(on: req.db)
            .filter(\.$userID == user.id!)
            .all()
    }

    func adminCreate(req: Request) throws -> EventLoopFuture<[String: String]> {
        let lasertime = try req.content.decode(Lasertime.self)
        guard let _ = lasertime.userID else {   // checking userID was sent
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: "userID"))
        }
        
        return try self.create(lasertime, req: req)
    }
    
    func create(req: Request) throws -> EventLoopFuture<[String: String]> {
        guard let user = try? req.auth.require(User.self) else {    // safely unwrap userID
            throw FluentError.idRequired
        }
        
        let lasertime = try req.content.decode(Lasertime.self)
        lasertime.userID = user.id!
        
        return try self.create(lasertime, req: req)
    }
    
    private func create(_ lasertime: Lasertime, req: Request) throws -> EventLoopFuture<[String: String]> {
        if let _ = lasertime.cutTime {
            // here, lasertime.cutTime is defined so there's no need to set it to something
        } else {    // if cutTime is not given it will set it to the current date/time
            lasertime.cutTime = Date.init() // sets the cut time to current date/time
        }
                
        // todo: validate duration
        
        return lasertime.save(on: req.db).map {[
            "cutTime": lasertime.cutTime!.description,   // force unwrap because value is guaranteed to be set from the `if`
            "descript": lasertime.descript ?? "",
            "userID": lasertime.userID!.description,
            "paid": lasertime.paid?.description ?? "",
            "duration": lasertime.duration.description
        ]}
    }
}


