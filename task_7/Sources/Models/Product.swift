import Fluent
import Vapor

final class Product: Model, Content {
    static let schema = "products"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    @Field(key: "price")
    var price: Double

    @Parent(key: "category_id")
    var category: Category

    @Parent(key: "tag_id")
    var tag: Tag

    init() {}

    init(id: UUID? = nil, name: String, description: String, price: Double, categoryID: UUID, tagID: UUID) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.$category.id = categoryID
        self.$tag.id = tagID
    }
}