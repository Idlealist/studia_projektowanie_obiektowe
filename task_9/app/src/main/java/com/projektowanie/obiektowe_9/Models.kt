package com.projektowanie.obiektowe_9

import io.realm.kotlin.types.RealmObject
import io.realm.kotlin.types.annotations.PrimaryKey
import java.util.UUID

class Category : RealmObject {
    @PrimaryKey
    var id: String = UUID.randomUUID().toString()
    var name: String = ""
}

class Product : RealmObject {
    @PrimaryKey
    var id: String = UUID.randomUUID().toString()
    var name: String = ""
    var price: Double = 0.0
    var categoryId: String = ""
}

class CartItem : RealmObject {
    @PrimaryKey
    var id: String = UUID.randomUUID().toString()
    var productId: String = ""
    var quantity: Int = 1
}
