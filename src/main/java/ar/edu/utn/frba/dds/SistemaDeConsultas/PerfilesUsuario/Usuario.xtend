package ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario

import ar.edu.utn.frba.dds.SistemaDeConsultas.BusquedaRealizada
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi
import java.util.ArrayList
import com.fasterxml.jackson.annotation.JsonIgnore
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import javax.persistence.OneToMany
import javax.persistence.FetchType
import javax.persistence.Inheritance
import javax.persistence.InheritanceType
import javax.persistence.DiscriminatorColumn
import javax.persistence.DiscriminatorType
import ar.edu.utn.frba.dds.SistemaDeConsultas.RepoPoi
import javax.persistence.CascadeType
import org.hibernate.annotations.LazyCollection
import org.hibernate.annotations.LazyCollectionOption
import javax.persistence.ManyToMany
import javax.persistence.JoinColumn
import javax.persistence.JoinTable

@Entity
@Accessors
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="tipoUsuario", discriminatorType=DiscriminatorType.INTEGER)
class Usuario {

	@Id
	@GeneratedValue
	private long id
	
	@Column(length=25)
	String nombre
	
	@Column(length=25)
	String password
	
	@ManyToMany(cascade=CascadeType.ALL)
	@JoinTable(name="usuario_poi", joinColumns=@JoinColumn(name="poi_id"), inverseJoinColumns=@JoinColumn(name="usuario_id"))
	@LazyCollection(LazyCollectionOption.FALSE)
	@JsonIgnore List<Poi> favoritos = new ArrayList<Poi>()
	
	@Column
	boolean debeRegistrar = true
	
	@Column
	boolean debeNotificar = true
	
	new() {
		
	}
		
	new(String unNombre) {
		nombre = unNombre
	}
	
	new(String unNombre, String unPassword) {
		nombre = unNombre
		password = unPassword
	}
	
	def toggleRegistrar() {
		debeRegistrar = !debeRegistrar
	}
	
	def toggleNotificar() {
		debeNotificar = !debeNotificar
	}
	
	override equals(Object obj) {
		if (obj == null) return false
		
		if (this.nombre.equals((obj as Usuario).nombre)) {
			return true
		}
		
		return false
	}
	
	override hashCode() {
		return this.nombre.hashCode
	}
	
	def notificarTardanza(BusquedaRealizada busqueda) {
		
	}
	
	def sosTerminal() {
		true
	}
	
	def favoritear(Poi unPoi) {
		if (favoritos.contains(unPoi)) {
			removeFavorito(unPoi)
		} else {
			addFavorito(unPoi)
		}
		RepoPerfilesUsuario.instance.update(this)
		RepoPoi.instance.update(unPoi)
	}
	
	def getCantidadFavoritos() {
		favoritos.size
	}
	
	def addFavorito(Poi unPoi) {
		favoritos.add(unPoi)
	}
	
	def removeFavorito(Poi unPoi) {
		favoritos.remove(unPoi)
	}
	
	def esFavorito(Poi unPoi) {
		favoritos.contains(unPoi)
	}
	
}