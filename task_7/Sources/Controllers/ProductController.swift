import Vapor
import Fluent

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.get(use: index)
        products.get("create", use: create)
        products.post(use: store)
        products.get(":productID", use: show)
        products.get(":productID", "edit", use: edit)
        products.post(":productID", use: update)
        products.post(":productID", "delete", use: delete)
    }

    struct IndexContext: Encodable {
        let products: [Product]
    }

    struct CreateContext: Encodable {
        let categories: [Category]
        let tags: [Tag]
    }

    struct EditContext: Encodable {
        let product: Product
        let categories: [Category]
        let tags: [Tag]
    }

    struct ShowContext: Encodable {
        let product: Product
    }

    func index(req: Request) async throws -> View {
        let products = try await Product.query(on: req.db).all()
        for product in products {
            try await product.$category.load(on: req.db)
            try await product.$tag.load(on: req.db)
        }
        let context = IndexContext(products: products)
        return try await req.view.render("products/index", context)
    }

    func create(req: Request) async throws -> View {
        let categories = try await Category.query(on: req.db).all()
        let tags = try await Tag.query(on: req.db).all()
        let context = CreateContext(categories: categories, tags: tags)
        return try await req.view.render("products/create", context)
    }

    func store(req: Request) async throws -> Response {
        let productData = try req.content.decode(ProductForm.self)
        let product = Product(
            name: productData.name,
            description: productData.description,
            price: productData.price,
            categoryID: productData.categoryId,
            tagID: productData.tagId
        )
        try await product.save(on: req.db)
        return req.redirect(to: "/products")
    }

    func show(req: Request) async throws -> View {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.$category.load(on: req.db)
        try await product.$tag.load(on: req.db)
        let context = ShowContext(product: product)
        return try await req.view.render("products/show", context)
    }

    func edit(req: Request) async throws -> View {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.$category.load(on: req.db)
        try await product.$tag.load(on: req.db)
        let categories = try await Category.query(on: req.db).all()
        let tags = try await Tag.query(on: req.db).all()
        let context = EditContext(product: product, categories: categories, tags: tags)
        return try await req.view.render("products/edit", context)
    }

    func update(req: Request) async throws -> Response {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let productData = try req.content.decode(ProductForm.self)
        product.name = productData.name
        product.description = productData.description
        product.price = productData.price
        product.$category.id = productData.categoryId
        product.$tag.id = productData.tagId
        try await product.update(on: req.db)
        return req.redirect(to: "/products")
    }

    func delete(req: Request) async throws -> Response {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return req.redirect(to: "/products")
    }
}

struct ProductForm: Content {
    let name: String
    let description: String
    let price: Double
    let categoryId: UUID
    let tagId: UUID
}