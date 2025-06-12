package com.projektowanie.obiektowe_9.ui

import androidx.compose.runtime.*
import io.realm.kotlin.Realm

@Composable
fun MainScreen(realm: Realm) {
    var currentScreen by remember { mutableStateOf("categories") }
    var selectedCategoryId by remember { mutableStateOf<String?>(null) }

    when (currentScreen) {
        "categories" -> CategoryListScreen(
            realm = realm,
            onCategorySelected = {
                selectedCategoryId = it
                currentScreen = "products"
            },
            onCartClick = { currentScreen = "cart" }
        )
        "products" -> selectedCategoryId?.let {
            ProductListScreen(
                realm = realm,
                categoryId = it,
                onBack = { currentScreen = "categories" },
                onCartClick = { currentScreen = "cart" }
            )
        }
        "cart" -> CartScreen(
            realm = realm,
            onBack = {
                currentScreen = if (selectedCategoryId != null) "products" else "categories"
            }
        )
    }
}
