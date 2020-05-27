import Fluent
import Vapor

func routes(_ app: Application) throws {

// MARK: - Setting up controllers and authentication middleware

    //  User authentication layer and auth DB
    let userProtected = app.grouped(User.authenticator(), User.guardMiddleware())
    let userController = UserController()

    //  Admin authentication layer and auth DB
    let adminProtected = app.grouped(Admin.authenticator(), Admin.guardMiddleware())
    let adminController = AdminController()
    
    //  Lasertime DB interaction layer
    let lasertimeController = LasertimeController()
    
    
// MARK: - User profile operations
    // Hello!
    userProtected.get("hello", use: userController.hello)
    
    // Allow authenticated users to access their own details
    userProtected.get("user", use: userController.getUser)
    
    // Allow user to update their own details
//    userProtected.patch("user", use: userController.update)
    // Allow user to delete themselves
//    userProtected.delete("user", use: userController.delete)
    
    
// MARK: - Admin operations
    
    // Admin can get specific user's lasertime
    adminProtected.get("admin", "lasertime", ":username", use: lasertimeController.adminGetUserLasertime)
    
    // Allow admins to access all lasertime logs
    adminProtected.get("admin", "lasertime", use: lasertimeController.index)
    adminProtected.post("admin", "lasertime", use: lasertimeController.adminCreate)
    
    // Allow admins to access lists of all users and admins (except password)
    adminProtected.get("admin", "admins", use: adminController.index)
    adminProtected.get("admin", "users", use: userController.index)
    
    // Allow admins to access specific user details
    adminProtected.get("admin", "users", ":username", use: userController.adminGetUser)
    
    // Allow admins to create users and admins
    adminProtected.post("admin", "users", use: userController.create)
    adminProtected.post("admin", "admins", use: adminController.create)
    
// MARK: - User lasertime operations
    // Users can retrieve and add their own lasertime logs
    userProtected.get("lasertime", use: lasertimeController.getUserLasertime)
    userProtected.post("lasertime", use: lasertimeController.create)
//    userProtected.patch("lasertime" ":id", use: lasertimeController.update)
    
// MARK: - Routes for debugging
    if app.environment == .testing || app.environment == .development {
        // testing/debugging routes:
        
    }
    
    
    /// User should be able to:
    ///     • delete themself       🚦 on hold
    ///     • update their own details   🚦 on hold
    ///     • add laser log     ✅
    ///     • view their own laser logs     ✅
    ///     • update laser log      🚦 on hold
    
    /// Laser admins should be able to:
    ///     • view all laser logs       ✅
    ///     • get specific user's laser logs ✅
    ///     • modify laser logs' details (mainly paid date)     🚦 on hold
    ///     • get list of all users with details (except password)     ✅
    ///     • view any user's details (except password)   ✅
    ///     • add laser log in anyone's name
    ///     • create user       ✅
    ///     • create admin ✅
    
    /// The server must:
    ///     • enforce password requirements
    ///     • verify email address
    ///     • not accept empty strings as user details
}
