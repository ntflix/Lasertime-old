//
//  Material.swift
//  
//
//  Created by Felix Weber on 23/07/2020.
//

import Fluent
import Vapor

final class Material: Model, Content {
    static let schema = "materials"
    
    /*
     .id()
     .field("name", .string)
     .field("price", .double)
     */
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Int
    
    init() { }

    init(
        id: UUID? = nil,
        name: String,
        price: Int
    ) {
        self.id = id
        self.name = name
        self.price = price
    }
}
