import Vapor
import Fluent

struct TagController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tags = routes.grouped("tags")
        tags.get(use: index)
        tags.get("create", use: create)
        tags.post(use: store)
        tags.get(":tagID", use: show)
        tags.get(":tagID", "edit", use: edit)
        tags.post(":tagID", use: update)
        tags.post(":tagID", "delete", use: delete)
    }

    struct IndexContext: Encodable {
        let tags: [Tag]
    }

    struct CreateContext: Encodable {
        let title: String
    }

    struct EditContext: Encodable {
        let tag: Tag
    }

    struct ShowContext: Encodable {
        let tag: Tag
    }

    func index(req: Request) async throws -> View {
        let tags = try await Tag.query(on: req.db).all()
        let context = IndexContext(tags: tags)
        return try await req.view.render("tags/index", context)
    }

    func create(req: Request) async throws -> View {
        let context = CreateContext(title: "Create Tag")
        return try await req.view.render("tags/create", context)
    }

    func store(req: Request) async throws -> Response {
        let tagData = try req.content.decode(TagForm.self)
        let tag = Tag(label: tagData.label)
        try await tag.save(on: req.db)
        return req.redirect(to: "/tags")
    }

    func show(req: Request) async throws -> View {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await tag.$products.load(on: req.db)
        let context = ShowContext(tag: tag)
        return try await req.view.render("tags/show", context)
    }

    func edit(req: Request) async throws -> View {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let context = EditContext(tag: tag)
        return try await req.view.render("tags/edit", context)
    }

    func update(req: Request) async throws -> Response {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let tagData = try req.content.decode(TagForm.self)
        tag.label = tagData.label
        try await tag.update(on: req.db)
        return req.redirect(to: "/tags")
    }

    func delete(req: Request) async throws -> Response {
        guard let tag = try await Tag.find(req.parameters.get("tagID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await tag.delete(on: req.db)
        return req.redirect(to: "/tags")
    }
}

struct TagForm: Content {
    let label: String
}