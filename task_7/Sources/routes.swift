import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: ProductController())
    try app.register(collection: CategoryController())
    try app.register(collection: TagController())
}