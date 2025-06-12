package com.projektowanie.obiektowe_9.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import io.realm.kotlin.Realm
import io.realm.kotlin.ext.query
import com.projektowanie.obiektowe_9.Product
import com.projektowanie.obiektowe_9.CartItem
import kotlinx.coroutines.flow.map

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProductListScreen(
    realm: Realm,
    categoryId: String,
    onBack: () -> Unit,
    onCartClick: () -> Unit
) {
    val products by realm.query<Product>("categoryId == $0", categoryId)
        .asFlow()
        .map { it.list }
        .collectAsState(initial = emptyList())

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Produkty") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Wstecz")
                    }
                },
                actions = {
                    IconButton(onClick = onCartClick) {
                        Icon(Icons.Default.ShoppingCart, contentDescription = "Koszyk")
                    }
                }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .padding(padding)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(products) { product ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Text(
                                text = product.name,
                                style = MaterialTheme.typography.titleMedium
                            )
                            Text(
                                text = "${String.format("%.2f", product.price)} PLN",
                                style = MaterialTheme.typography.bodyMedium
                            )
                        }
                        Button(onClick = {
                            realm.writeBlocking {
                                val existing = query<CartItem>("productId == $0", product.id)
                                    .first()
                                    .find()
                                if (existing != null) {
                                    copyToRealm(existing.apply { quantity += 1 })
                                } else {
                                    copyToRealm(CartItem().apply {
                                        productId = product.id
                                        quantity = 1
                                    })
                                }
                            }
                        }) {
                            Text("Dodaj")
                        }
                    }
                }
            }
        }
    }
}