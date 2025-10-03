package com.prm.dao;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class UserLastLoginDTO {
	private String fullName;
	private String role;
	private String lastLogin;
}
