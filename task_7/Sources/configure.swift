import Vapor
import Fluent
import FluentSQLiteDriver
import Leaf

public func configure(_ app: Application) async throws {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateProduct())
    app.migrations.add(CreateTag())
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment == .production
    try routes(app)
}