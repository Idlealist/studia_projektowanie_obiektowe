package com.example.task_3.service

import org.springframework.stereotype.Service

@Service 
class AuthService {
    fun authenticate(username: String, password: String): Boolean {
        return username == "admin" && password == "password"
    }
}
