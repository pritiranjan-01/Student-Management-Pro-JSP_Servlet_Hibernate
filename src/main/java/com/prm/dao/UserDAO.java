package com.prm.dao;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.prm.entity.Users;
import com.prm.entity.Usertype;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;

public class UserDAO extends EntityProxy{
	private static final UserDAO userdao = new UserDAO();
	
	private UserDAO() {}
	
	public static UserDAO getUserDAO() {
		return userdao;
	}
	
	public String createUser(Users user) {
		EntityTransaction et = super.getEntityTransaction();
		try {
			et.begin();
			super.getEntityManager().persist(user);
			super.getEntityTransaction().commit();
			return "User Created";
		} catch (Exception e) {
			et.rollback();
			return "Username already present, Try with different Username";
		}
	}
	
	public Users getUserByFullName(String fullname) {
		String hql = "select u from Users u where u.FullName= :name";
		Query query = super.getEntityManager().createQuery(hql);
		query.setParameter("name", fullname);
		List<Users> users = query.getResultList();
		return users.get(0);
	}
	
	public Users getUserByUserName(String name) {
		String hql = "select u from Users u where u.username= :name";
		Query query = super.getEntityManager().createQuery(hql);
		query.setParameter("name", name);
		List<Users> users = query.getResultList();
		if(users.size()==0) return null;
		return users.get(0);
	}
	
	public String addSuperAdmin() {
		String hql = "select u from Users u";
		Query query = super.getEntityManager().createQuery(hql);
		List<Users> users = query.getResultList();
		
		if(users.isEmpty()) {
			Usertype type = Usertype.SUPERADMIN;
			Users user = new Users(1,"superadmin@gmail.com",type,"0000","Pritiranjan",  LocalDateTime.now());
			super.getEntityTransaction().begin();
			super.getEntityManager().persist(user);
			super.getEntityTransaction().commit();
			return "Super Admin Created";
		}
		return "Super Admin Already Exist";
	}
	
	public List<Users> getAllUsers(){
		String hql = "select u from Users u";
		Query query = super.getEntityManager().createQuery(hql);
		List<Users> users = query.getResultList();
		return users;
	}
	

	public void updateUser(Users u) {
		super.getEntityTransaction().begin();
		super.getEntityManager().merge(u);
		super.getEntityTransaction().commit();
	}
	
	public void deleteUser(Integer id) {
		Users user =  this.getUserbyId(id);
		super.getEntityTransaction().begin();
		super.getEntityManager().remove(user);
		super.getEntityTransaction().commit();
	}
	
	public Users getUserbyId(Integer id) {
		return super.getEntityManager().find(Users.class, id);
	}
	
	public long[] getUserCounts() {
		String totalUsersHql = "SELECT COUNT(u) FROM Users u";
		String totalAdminsHql = "SELECT COUNT(u) FROM Users u WHERE u.userrole = 'ADMIN'";
		String totalHRsHql = "SELECT COUNT(u) FROM Users u WHERE u.userrole = 'HR'";
		
		Query query1 = super.getEntityManager().createQuery(totalUsersHql);
		Query query2 = super.getEntityManager().createQuery(totalAdminsHql);
		Query query3 = super.getEntityManager().createQuery(totalHRsHql);
		
		Long totalUsers = (Long) query1.getSingleResult();
		Long totalAdmins = (Long) query2.getSingleResult();
		Long totalHRs = (Long) query3.getSingleResult();
		
		return new long[] {totalUsers,totalAdmins,totalHRs};
	}
	
	public List<UserLastLoginDTO> getLastLoginDetails() {
	    String hql = "select u from Users u";
	    List<Users> users = getEntityManager().createQuery(hql).getResultList();

	    List<UserLastLoginDTO> result = new ArrayList<>();
	    for (Users u : users) {
	    	if(u.getUserrole().name().equals("SUPERADMIN")) continue; //Skips the SuperAdmin lastlogin log.
	    	String fullName = u.getFullName();
	        String role =  u.getUserrole().toString();
	        String lastLogin = (u.getLastLogin() != null) ? u.getLastLogin().format(DateTimeFormatter.ofPattern("yyyy-dd-MM HH:mm:ss")) : "null";
	        
	        result.add(new UserLastLoginDTO(fullName, role, lastLogin));
	    }
	    return result;
	}

}