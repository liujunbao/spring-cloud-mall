package com.example.userservice.dto;

import lombok.Data;

@Data
public class LoginResponse {
    private UserDTO user;
    private String token;

    public LoginResponse(UserDTO user, String token) {
        this.user = user;
        this.token = token;
    }
} 