package ar.edu.utn.frba.dds.SistemaDeConsultas

import org.hibernate.SessionFactory
import org.hibernate.cfg.Configuration
import java.util.List
import org.hibernate.HibernateException
import org.hibernate.Criteria
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Administrador
import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.DisponibilidadDelPoi
import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.IntervalosDeDisponibilidad
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServicioDelCGP

abstract class RepoBase<T> {
	
	protected static final SessionFactory sessionFactory = new Configuration().configure()
		.addAnnotatedClass(Usuario)
		.addAnnotatedClass(Administrador)
		.addAnnotatedClass(Poi)
		.addAnnotatedClass(Banco)
		.addAnnotatedClass(CGP)
		.addAnnotatedClass(LocalComercial)
		.addAnnotatedClass(ParadaDeColectivo)
		.addAnnotatedClass(Review)
		.addAnnotatedClass(DisponibilidadDelPoi)
		.addAnnotatedClass(IntervalosDeDisponibilidad)
		.addAnnotatedClass(ServicioDelCGP)
		.buildSessionFactory()
		
	def List<T> allInstances() {
		val session = sessionFactory.openSession
		try {
			return session.createCriteria(getEntityType).list()
		} finally {
			session.close
		}
	}
	
		def List<T> searchByExample(T t) {
		val session = sessionFactory.openSession
		try {
			val criteria = session.createCriteria(getEntityType)
			this.addQueryByExample(criteria, t)
			return criteria.list()
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}
	
	def void create(T t) {
		val session = sessionFactory.openSession
		try {
			session.beginTransaction
			session.save(t)
			session.getTransaction.commit
		} catch (HibernateException e) {
			session.getTransaction.rollback
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}

	def void update(T t) {
		val session = sessionFactory.openSession
		try {
			session.beginTransaction
			session.update(t)
			session.getTransaction.commit
		} catch (HibernateException e) {
			session.getTransaction.rollback
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}
	
	def void delete(T t) {
		val session = sessionFactory.openSession
		try {
			session.beginTransaction
			session.delete(t)
			session.getTransaction.commit
		} catch (HibernateException e) {
			session.getTransaction.rollback
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}

	def abstract Class<T> getEntityType()

	def abstract void addQueryByExample(Criteria criteria, T t)

	def openSession() {
		sessionFactory.openSession
	}
}