import Fluent
import Vapor

func routes(_ app: Application) throws {
    let userController = UserController()
    app.get("users", use: userController.index)
    app.post("users", use: userController.create)
    app.delete("users", ":userID", use: userController.delete)
    
    let protected = app.grouped(User.authenticator())
    protected.get("protected") { req -> String in
        try req.auth.require(User.self).username
    }
}
