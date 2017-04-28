package ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario

import java.util.Set
import java.util.HashSet
import ar.edu.utn.frba.dds.SistemaDeConsultas.Exception.BusinessException
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.utn.frba.dds.SistemaDeConsultas.RepoBase
import org.hibernate.Criteria
import org.hibernate.criterion.Restrictions
import org.hibernate.HibernateException
import java.util.List

@Accessors
class RepoPerfilesUsuario extends RepoBase<Usuario> {
	static RepoPerfilesUsuario instance
	Set<Usuario> listaUsuarios = new HashSet()
	
	static def getInstance() {
		if (instance == null) {
			instance = new RepoPerfilesUsuario
		}
		return instance
	}	
	
	def existeUsuario(Usuario usuario) {
		listaUsuarios.contains(usuario)
	}
	
	def addUsuario(Usuario usuario) {
		//if (usuario.nombre != "") {
		//	listaUsuarios.add(usuario)
		//}
		val usu = this.findByName(usuario.nombre)
		
		if (usu == null) {
			this.create(usuario)
		}
	}
	
	def updateUsuario(Usuario usuario) {
		//removeUsuario(usuario)
		//addUsuario(usuario)
		this.update(usuario)
	}
	
	def removeUsuario(Usuario usuario) {
		//if(!listaUsuarios.remove(usuario)) {
		//	throw new BusinessException("Usuario inexistente")
		//}
		this.delete(usuario)
	}
	
	def removeUsuarioByName(String unNombre) {
		//if(!listaUsuarios.remove(listaUsuarios.findFirst[usu | usu.nombre.equals(unNombre)])) {
		//	throw new BusinessException("Usuario inexistente")
		//}
		this.delete(this.findByName(unNombre))
	}
	
	def findByName(String nombre) {
		//listaUsuarios.findFirst[usuario | usuario.nombre.equals(nombre)]
		val session = openSession
		try {
			session.createCriteria(Usuario)
				//.setFetchMode("candidatos", FetchMode.JOIN)
				.add(Restrictions.eq("nombre", nombre))
				.uniqueResult as Usuario
		} catch (HibernateException e) {
			throw new BusinessException(e.message)
		} finally {
			session.close
		}
	}
	
	def cantidadUsuarios() {
		listaUsuarios.size
	}
	
	def List<Usuario> listaTerminales() {
		//listaUsuarios.filter[usuario | usuario.sosTerminal()].toList
		val session = openSession
		try {
			session.createCriteria(Usuario)
				.add(Restrictions.eq("tipoUsuario", 0))
				.list
		} catch (HibernateException e) {
			throw new BusinessException(e.message)
		} finally {
			session.close
		}
	}
	
	def List<Administrador> listaAdministradores() {
		//listaUsuarios.filter[usu | !(usu.sosTerminal())].toList
		val session = openSession
		try {
			session.createCriteria(Usuario)
				.add(Restrictions.eq("tipoUsuario", 1))
				.list
		} catch (HibernateException e) {
			throw new BusinessException(e.message)
		} finally {
			session.close
		}
	}
	
	def getUsuarios() {
		//listaUsuarios.toList
		this.allInstances
	}
	
	
	def vaciarUsuarios() {
		listaUsuarios = new HashSet()
	}
	
	override getEntityType() {
		typeof(Usuario)
	}
	
	override addQueryByExample(Criteria criteria, Usuario usu) {
		if (usu.nombre != null) {
			criteria.add(Restrictions.eq("nombre", usu.nombre))
		}
	}
	
}