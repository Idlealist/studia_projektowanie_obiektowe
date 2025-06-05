import Fluent
import Vapor

final class Tag: Model, Content {
    static let schema = "tags"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "label")
    var label: String

    @Children(for: \.$tag)
    var products: [Product]

    init() {}

    init(id: UUID? = nil, label: String) {
        self.id = id
        self.label = label
    }
}