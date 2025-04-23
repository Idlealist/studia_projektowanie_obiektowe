package com.example.task_3.controller

import com.example.task_3.model.LoginRequest
import com.example.task_3.service.AuthService
import com.example.task_3.service.LazyAuthService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api")
class AuthController {

    @Autowired
    lateinit var authService: AuthService // Eager

    @Autowired
    lateinit var lazyAuthService: LazyAuthService // Lazy

    private val users = listOf("admin", "user1", "guest")

    @PostMapping("/eager/users")
    fun getUsersEager(@RequestBody request: LoginRequest): Any {
        return if (authService.authenticate(request.username, request.password)) {
            users
        } else {
            mapOf("error" to "Unauthorized (eager)")
        }
    }

    @PostMapping("/lazy/users")
    fun getUsersLazy(@RequestBody request: LoginRequest): Any {
        return if (lazyAuthService.authenticate(request.username, request.password)) {
            users
        } else {
            mapOf("error" to "Unauthorized (lazy)")
        }
    }
}
