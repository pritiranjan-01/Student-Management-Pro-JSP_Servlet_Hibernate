package com.prm.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Entity
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
public class Student {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Integer id;
	
	@NonNull
	String name;
	
	@NonNull
	LocalDate DOB;
	
	@NonNull
	String gender;
	
	@NonNull
	Long mobileNumber;
	
	@NonNull
	String email;
	
	@NonNull
	Long aadhaarNumber;
	
	@NonNull
	Double tenthMark;
	
	@NonNull
	Double twelveMark;
	
	@NonNull
	Double gradMark;
	
	@NonNull
	String address;
}
