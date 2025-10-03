package com.prm.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;

public abstract class EntityProxy {
	private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("servlettask");
	private static final EntityManager em = emf.createEntityManager();
	private static final EntityTransaction et = em.getTransaction();
	
	public final static EntityManager getEntityManager() {
		return em;
	}
	
	public final static EntityTransaction getEntityTransaction() {
		return et;
	}
	
	public static final void closeConnection() {
		em.close();
		emf.close();
		System.out.println("Connection with data source closed");
	}
}
