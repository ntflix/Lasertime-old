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
        // returns all lasertime logs.
        return Material.query(on: req.db).all()
    }
}
