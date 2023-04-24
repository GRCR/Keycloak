package com.slo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.slo.entity.User;
import com.slo.repository.UserRepository;

@Service
public class UserService {

	@Autowired
	UserRepository userRepository;
	
	public User getUserByUsername(String username) {
		return userRepository.findByUsername(username);
	}
}
