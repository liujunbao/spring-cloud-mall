package com.example.userservice.service;

import com.example.userservice.dto.UserDTO;
import com.example.userservice.dto.UserLoginRequest;
import com.example.userservice.dto.UserRegisterRequest;

public interface UserService {
    UserDTO register(UserRegisterRequest request);

    UserDTO login(UserLoginRequest request);

    UserDTO getUserById(Long id);

    UserDTO getUserByUsername(String username);

    UserDTO updateUser(Long id, UserDTO userDTO);

    void deleteUser(Long id);
}