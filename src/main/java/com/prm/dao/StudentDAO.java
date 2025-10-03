package com.prm.dao;

import java.util.List;

import org.hibernate.SessionFactory;

import com.prm.entity.Student;

import jakarta.persistence.Query;

// DAO - Data Access Object
// DTO - Data Transfer Object

// In DAO all operations (CRUD) inside a dedicated class (DAO), and your services 
// just call methods on it.

public final class StudentDAO extends EntityProxy {
	private static final StudentDAO studentdao = new StudentDAO();
	
	private StudentDAO() {} 
	
	public static StudentDAO getStudentDAO() {
		return studentdao;
	}
	
	public String saveStudent(Student object ) {
		super.getEntityTransaction().begin();
		super.getEntityManager().persist(object);
		super.getEntityTransaction().commit();
		return "Student Saved";
	}
	
	public Student getSingleStudent(Integer id) {
		return super.getEntityManager().find(Student.class, id);
	}
	
	public List<Student> getAllStudent(){
		Query query = super.getEntityManager().createQuery("select h from Student h");
		List<Student> students = query.getResultList();
		return students;
	}
	
	public void updateStudent(Student s) {
		super.getEntityTransaction().begin();
		super.getEntityManager().merge(s);
		super.getEntityTransaction().commit();
	}
	
	public void deleteStudent(Integer id) {
		Student student =  this.getSingleStudent(id);
		super.getEntityTransaction().begin();
		super.getEntityManager().remove(student);
		super.getEntityTransaction().commit();
	}
	
	public long getTotalStudents() {
	    return (long) super.getEntityManager().createQuery("SELECT COUNT(s) FROM Student s").getSingleResult();
	}

	public long getMaleCount() {
	    return (long) super.getEntityManager().createQuery("SELECT COUNT(s) FROM Student s WHERE s.gender = 'Male'").getSingleResult();
	}

	public long getFemaleCount() {
	    return (long) super.getEntityManager().createQuery("SELECT COUNT(s) FROM Student s WHERE s.gender = 'Female'").getSingleResult();
	}

	public double getAverageGradMark() {
	    Double avg = (Double) super.getEntityManager().createQuery("SELECT AVG(s.gradMark) FROM Student s").getSingleResult();
	    return avg != null ? avg : 0.0;
	}

	public List<Student> getRecentStudents(int limit) {
	    return super.getEntityManager().createQuery("FROM Student s ORDER BY s.id DESC", Student.class)
	                  .setMaxResults(limit)
	                  .getResultList();
	}

}
