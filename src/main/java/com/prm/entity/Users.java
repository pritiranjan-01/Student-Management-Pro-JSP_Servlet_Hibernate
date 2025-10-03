package com.prm.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import jakarta.persistence.Id;

@Entity
@Setter
@Getter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@RequiredArgsConstructor
public class Users {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer Id;
	
	@NonNull
	@Column(nullable = false, unique = true)  // 🚀 not null + unique
	private String username;
	
	@NonNull
	@Enumerated(EnumType.STRING)   //  Store as String in DB
	private Usertype userrole;
	
	@NonNull
	private String password;
	
	@NonNull
	private String FullName;
	
	@Column(name = "last_login")
	private LocalDateTime lastLogin;

	public Users(Integer id, @NonNull String username, @NonNull Usertype userrole, @NonNull String password,
			@NonNull String fullName) {
		super();
		Id = id;
		this.username = username;
		this.userrole = userrole;
		this.password = password;
		FullName = fullName;
	}

}
