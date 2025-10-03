package com.prm.entity;

import java.util.Arrays;

public enum AuthorizeRoleEnum {
	
	INSERTUSER("superadmin"), INSERTSTUDENT("admin"), 
	DELETEUSER("superadmin"), DELETESTUDENT("admin"),
	FETCHUSER("superadmin"), FETCHSTUDENT("admin","hr"), 
	UPDATEUSER("superadmin"), UPDATESTUDENT("admin","hr","teacher");
	
	private String[] roles;
	
	private AuthorizeRoleEnum (String... roles) {
		this.roles = roles;
	}
	
	public String[] getActionRoles() {   // it will return the String Useroles of an Action
		return roles;
	}
	
//	public static void main(String[] args) {
//		AuthorizeRoleEnum enum1 = AuthorizeRoleEnum.DELETESTUDENT;
//		System.out.println(Arrays.toString(enum1.getActionRoles()));
//	}
	
}
