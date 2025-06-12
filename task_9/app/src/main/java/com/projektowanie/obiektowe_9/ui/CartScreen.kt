package com.projektowanie.obiektowe_9.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import io.realm.kotlin.Realm
import io.realm.kotlin.ext.query
import com.projektowanie.obiektowe_9.CartItem
import com.projektowanie.obiektowe_9.Product
import kotlinx.coroutines.flow.map

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CartScreen(
    realm: Realm,
    onBack: () -> Unit
) {
    val cartItems by realm.query<CartItem>()
        .asFlow()
        .map { it.list }
        .collectAsState(initial = emptyList())

    val itemsWithProducts by produceState(initialValue = emptyList<Pair<CartItem, Product>>(), cartItems) {
        value = cartItems.mapNotNull { cartItem ->
            realm.query<Product>("id == $0", cartItem.productId)
                .first()
                .find()
                ?.let { product -> cartItem to product }
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Koszyk") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Wstecz")
                    }
                }
            )
        }
    ) { padding ->
        if (itemsWithProducts.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Koszyk jest pusty",
                    style = MaterialTheme.typography.titleMedium
                )
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .padding(padding)
                    .padding(horizontal = 16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(itemsWithProducts) { (cartItem, product) ->
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
                                    text = "Ilość: ${cartItem.quantity}",
                                    style = MaterialTheme.typography.bodyMedium
                                )
                                Text(
                                    text = "Cena: ${String.format("%.2f", product.price * cartItem.quantity)} PLN",
                                    style = MaterialTheme.typography.bodyMedium
                                )
                            }
                            Button(onClick = {
                                realm.writeBlocking {
                                    val managedItem = query<CartItem>("id == $0", cartItem.id)
                                        .first()
                                        .find()
                                    if (managedItem != null) {
                                        if (managedItem.quantity > 1) {
                                            copyToRealm(managedItem.apply { quantity -= 1 })
                                        } else {
                                            delete(managedItem)
                                        }
                                    }
                                }
                            }) {
                                Text("Usuń")
                            }
                        }
                    }
                }
            }
        }
    }
}