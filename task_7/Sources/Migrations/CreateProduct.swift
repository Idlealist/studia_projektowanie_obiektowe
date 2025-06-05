import Fluent

struct CreateProduct: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("products")
            .id()
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("price", .double, .required)
            .field("category_id", .uuid, .required, .references("categories", "id"))
            .field("tag_id", .uuid, .required, .references("tags", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("products").delete()
    }
}