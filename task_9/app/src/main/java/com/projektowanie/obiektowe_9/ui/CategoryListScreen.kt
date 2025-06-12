package com.projektowanie.obiektowe_9.ui

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import io.realm.kotlin.Realm
import io.realm.kotlin.ext.query
import com.projektowanie.obiektowe_9.Category
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ShoppingCart
import kotlinx.coroutines.flow.map

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CategoryListScreen(
    realm: Realm,
    onCategorySelected: (String) -> Unit,
    onCartClick: () -> Unit
) {
    val categories by realm.query<Category>()
        .asFlow()
        .map { it.list }
        .collectAsState(initial = emptyList())

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Kategorie") },
                actions = {
                    IconButton(onClick = onCartClick) {
                        Icon(Icons.Default.ShoppingCart, contentDescription = "Koszyk")
                    }
                }
            )
        }
    ) { padding ->
        LazyColumn(modifier = Modifier.padding(padding)) {
            items(categories) { category ->
                Text(
                    text = category.name,
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { onCategorySelected(category.id) }
                        .padding(16.dp),
                    style = MaterialTheme.typography.titleMedium
                )
            }
        }
    }
}
