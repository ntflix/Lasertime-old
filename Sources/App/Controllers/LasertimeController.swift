//
//  File.swift
//  
//
//  Created by Felix Weber on 18/05/2020.
//

import Fluent
import Vapor

//enum LasertimeControllerError: Error {
//    case noID
//
//    var errorDescription: String? {
//        switch self {
//        case .noID:
//            return "No ID provided"
//        }
//    }
//}

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
    
    func getUserLasertime(req: Request) throws -> EventLoopFuture<[[String: String]]> {
        guard let user = try? req.auth.require(User.self) else {    // safely unwrap userID
            throw FluentError.idRequired
//            throw LasertimeControllerError.noID
        }
        return Lasertime.query(on: req.db)
            .filter(\.$userID == user.id!)
            .all()
            .mapEach { laser in
                [
                    "cutTime": laser.cutTime!.description,  // guaranteed to have a value
                    "id": laser.id!.description,
                    "descript": laser.descript ?? "",
                    "paid": laser.paid?.description ?? "",
                    "duration": laser.duration.description
                ]
        }
    }
    
    /*
    func update(req: Request) throws -> EventLoopFuture<Lasertime> {
        guard let idString = req.parameters.get("id") else {
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: "id"))
        }
        
        let newLasertime = try req.content.decode(Lasertime.self)
        
        return Lasertime.query(on: req.db)
            .filter(\.id == idString)
            .unwrap(or: Abort(.notFound))
            .flatMap { laserLog in
                laserLog.update(on: req.db)
        }
        
    }
    */
    
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
            // lasertime.cutTime is defined so there's no need to set it to something
        } else {    // if cutTime is not given it will set it to the current date/time
            lasertime.cutTime = Date.init() // sets the cut time to current date/time
        }
                
        return lasertime.save(on: req.db).map {[
            "cutTime":lasertime.cutTime!.description,   // force unwrap because value is guaranteed to be set from the `if`
            "descript":lasertime.descript ?? "",
            "userID":lasertime.userID!.description,
            "paid":lasertime.paid?.description ?? "false",
            "duration": lasertime.duration.description
        ]}
    }
    
    //    func closuresStuff(items: [Int], name: String, itemValue: Int) -> [Int] {
    //
    //        let a: (Int) -> Bool
    //
    //        if name.starts(with: "Fred") {
    //            a = { value in
    //                return value > 5
    //            }
    //        } else {
    //            a = { value in
    //                return value > 1
    //            }
    //        }
    //
    //        let result = items.filter(isIncluded: a)
    //
    //        let b = items.filter {
    //            if name.starts(with: "Fred") {
    //                return $0 > 5
    //            } else {
    //                return $0 > 1
    //            }
    //        }
    //
    //        return result
    //    }
}


