package com.slo.controller;

import javax.servlet.http.HttpSession;

import org.keycloak.adapters.springsecurity.account.SimpleKeycloakAccount;
import org.keycloak.adapters.springsecurity.token.KeycloakAuthenticationToken;
import org.keycloak.representations.AccessToken;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class StudentController {

	@GetMapping("/contact-us")
	public ModelAndView login() {
		ModelAndView modelAndView = new ModelAndView("contact-us");
		return modelAndView;
	}
	
	@GetMapping("/home")
	public ModelAndView home(KeycloakAuthenticationToken authentication, HttpSession httpSession) {
		
		SimpleKeycloakAccount account = (SimpleKeycloakAccount) authentication.getDetails();
        AccessToken token = account.getKeycloakSecurityContext().getToken();
        httpSession.setAttribute(token.getSessionId(), token.getPreferredUsername());

		ModelAndView modelAndView = new ModelAndView("home");
		return modelAndView;
	}
	
	@GetMapping("/manage-students")
	@PreAuthorize("hasAuthority('PROFESSOR')")
	//@PreAuthorize("hasAuthority('PROFESSOR') or hasAuthority('STUDENT')")
	public ModelAndView manageStudents() {
		ModelAndView modelAndView = new ModelAndView("manage-students");
		return modelAndView;
	}
	
	@GetMapping("/access-denied")
	public ModelAndView accessDenied() {
		ModelAndView modelAndView = new ModelAndView("access-denied");
		return modelAndView;
	}
}
