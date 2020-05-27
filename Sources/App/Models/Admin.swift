//
//  User.swift
//  App
//
//  Created by Felix Weber on 18/05/2020.
//

import Fluent
import Vapor

final class Admin: Model, Content {
    static let schema = "admins"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "email")
    var email: String
    
    init() { }

    init(
        id: UUID? = nil,
        password: String,        /// bcrypt
        email: String          /// receive email notifications, also login
    ) {
        self.id = id
        self.password = password
        self.email = email
    }
}

extension Admin: Authenticatable {}

extension Admin: ModelAuthenticatable {
    static let usernameKey = \Admin.$email
    
    static let passwordHashKey = \Admin.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
