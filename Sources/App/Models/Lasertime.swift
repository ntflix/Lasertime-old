//
//  File.swift
//  
//
//  Created by Felix Weber on 18/05/2020.
//

import Fluent
import Vapor

final class Lasertime: Model, Content {
    static let schema = "lasertime"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "userID")
    var userID: UUID?
    
    @Field(key: "cutTime")
    var cutTime: Date?
    
    @Field(key: "descript")
    var descript: String?
    
    @Field(key: "paid")
    var paid: Date?
    
    @Field(key: "duration")
    var duration: Int
    
    init() { }

    init(
        id: UUID? = nil,
        userID: UUID?,
        cutTime: Date?,
        descript: String?,
        paid: Date?,
        duration: Int
    ){
        self.id = id
        self.userID = userID
        self.cutTime = cutTime
        self.descript = descript
        self.paid = paid
        self.duration = duration
    }
}
