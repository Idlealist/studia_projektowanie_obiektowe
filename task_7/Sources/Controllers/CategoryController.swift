import Vapor
import Fluent

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categories")
        categories.get(use: index)
        categories.get("create", use: create)
        categories.post(use: store)
        categories.get(":categoryID", use: show)
        categories.get(":categoryID", "edit", use: edit)
        categories.post(":categoryID", use: update)
        categories.post(":categoryID", "delete", use: delete)
    }

    struct IndexContext: Encodable {
        let categories: [Category]
    }

    struct ShowContext: Encodable {
        let category: Category
    }

    func index(req: Request) async throws -> View {
        let categories = try await Category.query(on: req.db).all()
        req.logger.info("Fetched \(categories.count) categories")
        let context = IndexContext(categories: categories)
        return try await req.view.render("categories/index", context)
    }

    func create(req: Request) async throws -> View {
        return try await req.view.render("categories/create")
    }

    func store(req: Request) async throws -> Response {
        let categoryData = try req.content.decode(CategoryForm.self)
        let category = Category(title: categoryData.title)
        try await category.save(on: req.db)
        return req.redirect(to: "/categories")
    }

    func show(req: Request) async throws -> View {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await category.$products.load(on: req.db)
        let context = ShowContext(category: category)
        return try await req.view.render("categories/show", context)
    }

    func edit(req: Request) async throws -> View {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await req.view.render("categories/edit", ["category": category])
    }

    func update(req: Request) async throws -> Response {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let categoryData = try req.content.decode(CategoryForm.self)
        category.title = categoryData.title
        try await category.update(on: req.db)
        return req.redirect(to: "/categories")
    }

    func delete(req: Request) async throws -> Response {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await category.delete(on: req.db)
        return req.redirect(to: "/categories")
    }
}

struct CategoryForm: Content {
    let title: String
}