import Fluent

struct CreateTag: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tags")
            .id()
            .field("label", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("tags").delete()
    }
}