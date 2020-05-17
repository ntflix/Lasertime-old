//
//  User.swift
//  App
//
//  Created by Felix Weber on 17/05/2020.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "email")
    var email: String?
    
    @Field(key: "firstName")
    var firstName: String
    
    @Field(key: "lastName")
    var lastName: String?
    
    init() { }

    init(
        id: UUID? = nil,
        username: String,
        password: String,       /// bcrypt
        email: String?,         /// 📸 users do not need to supply email 📧
        firstName: String,
        lastName: String?       /// 🚨 nor do they need to supply their last name 🕵️‍♀️
    ){
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
