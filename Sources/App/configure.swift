import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "dev",
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "lammrulEz2020hehe",
        database: Environment.get("DATABASE_NAME") ?? "laser",
        tlsConfiguration: .none
    ), as: .mysql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateLasertime())
    
    app.passwords.use(.bcrypt)
    
    // register routes
    try routes(app)
}
