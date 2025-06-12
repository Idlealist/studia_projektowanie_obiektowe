package com.projektowanie.obiektowe_9

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.lifecycle.lifecycleScope
import com.projektowanie.obiektowe_9.ui.MainScreen
import com.projektowanie.obiektowe_9.ui.theme.Obiektowe_9Theme
import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {
    lateinit var realm: Realm

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        val config = RealmConfiguration.Builder(setOf(Product::class, Category::class, CartItem::class))
            .name("obiektowe.realm")
            .schemaVersion(1)
            .build()

        realm = Realm.open(config)

        lifecycleScope.launch {
            realm.write {
                deleteAll()
                val cat1 = Category().apply { name = "Elektronika" }
                val cat2 = Category().apply { name = "Książki" }
                val cat3 = Category().apply { name = "Gry planszowe" }
                copyToRealm(cat1)
                copyToRealm(cat2)
                copyToRealm(cat3)

                copyToRealm(Product().apply {
                    name = "Smartfon"
                    price = 1500.0
                    categoryId = cat1.id
                })
                copyToRealm(Product().apply {
                    name = "Laptop"
                    price = 3500.0
                    categoryId = cat1.id
                })
                copyToRealm(Product().apply {
                    name = "Pan Tadeusz"
                    price = 25.00
                    categoryId = cat2.id
                })

                copyToRealm(Product().apply {
                    name = "1984"
                    price = 36.90
                    categoryId = cat2.id
                })

                copyToRealm(Product().apply {
                    name = "Catan: Gra o osadnictwo"
                    price = 120.0
                    categoryId = cat3.id
                })
                copyToRealm(Product().apply {
                    name = "Dixit"
                    price = 90.0
                    categoryId = cat3.id
                })
            }
        }


        setContent {
            Obiektowe_9Theme {
                MainScreen(realm = realm)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        realm.close()
    }
}
