package com.example.task_3.service

import org.springframework.context.annotation.Lazy
import org.springframework.stereotype.Service

@Service
@Lazy 
class LazyAuthService {
    fun authenticate(username: String, password: String): Boolean {
        return username == "lazy" && password == "password"
    }
}
