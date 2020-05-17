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

extension User: Authenticatable {}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

/// don't actually need session authentication, it's just gonna be one request per few hours per user

//extension User: SessionAuthenticatable {
//    typealias SessionID = UUID
//
//    var sessionID: SessionID { self.id! }
//}
//
//struct UserSessionAuthenticator: SessionAuthenticator {
//    typealias User = App.User
//
//    func authenticate(sessionID: User.SessionID, for request: Request) -> EventLoopFuture<Void> {
//        User.find(sessionID, on: request.db).map { user in
//            if let user = user {    // safely unwrapping user
//                request.auth.login(user)
//            }
//        }
//    }
//}
