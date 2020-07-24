//
//  MaterialController.swift
//  
//
//  Created by Felix Weber on 23/07/2020.
//

import Fluent
import Vapor

struct MaterialController {
    func index(req: Request) throws -> EventLoopFuture<[Material]> {
        // returns all materials
        return Material.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Material> {
        let material = try req.content.decode(Material.self)
        return material.save(on: req.db).map { material }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Material> {
        let material = try req.content.decode(Material.self)
        
        if let id = material.id {
            return Material.find(id, on: req.db).flatMap { thisMaterial in
                if let _ = thisMaterial {
                    thisMaterial!.name = material.name
                    thisMaterial!.price = material.price
                    
                    return thisMaterial!.update(on: req.db).map {
                        thisMaterial!
                    }
                } else {
                    return req.eventLoop.makeFailedFuture(FluentError.invalidField(name: "id", valueType: UUID.self, error: Abort(.badRequest)))
                }
            }
        } else {
            return req.eventLoop.makeFailedFuture(FluentError.missingField(name: "id"))
        }
    }
}
