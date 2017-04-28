package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.DisponibilidadDelPoi
import ar.edu.utn.frba.dds.SistemaDeConsultas.Exception.BusinessException
import java.util.ArrayList
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.geodds.Point
import org.uqbar.commons.utils.Observable
import com.fasterxml.jackson.annotation.JsonIgnore
import org.uqbar.xtrest.json.JSONUtils
import com.fasterxml.jackson.annotation.JsonProperty
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import javax.persistence.OneToMany
import javax.persistence.FetchType
import javax.persistence.OneToOne
import javax.persistence.InheritanceType
import javax.persistence.Inheritance
import javax.persistence.ElementCollection
import javax.persistence.CollectionTable
import javax.persistence.JoinColumn
import javax.persistence.CascadeType
import javax.persistence.Transient
import org.hibernate.annotations.LazyCollection
import org.hibernate.annotations.LazyCollectionOption

@Accessors
@Observable
@Entity
@Inheritance(strategy=InheritanceType.TABLE_PER_CLASS)
abstract class Poi {
	
	@Id
	@GeneratedValue
	private long id
	
	@Transient
	@JsonIgnore extension JSONUtils = new JSONUtils
	
	@Column(length=150)
	String nombre
	
	@ElementCollection
	@LazyCollection(LazyCollectionOption.FALSE)
	@CollectionTable(name="PalabrasClave", joinColumns=@JoinColumn(name="poi_id"))
	@Column(name="palabrasClave")
	Collection<String> palabrasClave = new ArrayList()
	
	@Transient
	@JsonIgnore Point point //TODO: ver si se deja asi
	
	@Column(length=150)
	String direccion
	
	@OneToOne(cascade=CascadeType.ALL)
	@JsonIgnore DisponibilidadDelPoi disponibilidadDelPoi
	
	@OneToMany(cascade=CascadeType.ALL)
	@LazyCollection(LazyCollectionOption.FALSE)
	@JsonIgnore Collection<Review> reviews = new ArrayList()

	def validateCreate() {
		//Validar nombre
		if (nombre == "")
			throw new BusinessException("Debe ingresar un nombre valido")
		//Validar point
		if (point == null)
			throw new BusinessException("Debe ingresar una localizacion valida")
	}	

	def mtsAKms(Double mts){
		return mts * 0.001
	}
	
	def seEncuentraAMenosDe(Double mts, Point otherPoint){
		val kms = mtsAKms(mts)
		return ( kms > point.distance(otherPoint))
	}
	
	def consultaDeCercania(Point consultaDePoint){
		seEncuentraAMenosDe(500.0, consultaDePoint)
	}
	
	@JsonProperty("listaReviews")
	def getListaReviews() {
		val listaJsonReviews = new ArrayList<String>
		
		reviews.forEach[ review | listaJsonReviews.add(review.toJson) ]
		
		return listaJsonReviews
	}
	
	@JsonProperty("tipoDePoi")
	def getTipoDePoi() {
		miTipoPoi
	}
	
	@JsonProperty("favorito")
	def getFavorito() {
		val usuarioActivo = RepoPoi.instance.usuarioActivo
		
		if (usuarioActivo == null) { return false }
		
		return usuarioActivo.esFavorito(this)
	}
	
	def miTipoPoi() {
		"POI ABSTRACTO"
	}
	
	def consultaDeDisponibilidad(DateTime fecha, String rubroDelPoi){
		disponibilidadDelPoi.consultaDeDisponibilidad( fecha, rubroDelPoi)
	}
	
	def configurarDisponibilidadDelPoi(int diasHabiles,int horaDeAperturaDelPoi,int minDeAperturaDelPoi,int horaDeCierreDelPoi, int minDeCierreDelPoi){
		disponibilidadDelPoi.horarioDelLocal(diasHabiles, horaDeAperturaDelPoi, minDeAperturaDelPoi, horaDeCierreDelPoi, minDeCierreDelPoi)
	}
	
	def contiene(String texto){
		return (nombre.contains(texto) || (palabrasClave.exists[pClave | pClave.contains(texto)]) || contieneExtra(texto))
	}
	
	def contieneExtra(String texto) {
		return false
	}

	def agregarServicio(String nombreDelServicio,int diasDisponibles,int horaDeApertura,int minDeApertura,int horaDeCierre, int minDeCierre) {
		
	}
	
	def addPalabraClave(String palabra) {
		palabrasClave.add(palabra)
	}
	
	def addPalabrasClaves(Collection<String> palabrasClaves) {
		palabrasClaves.forEach[palabra | addPalabraClave(palabra)]
	}
	
	def removePalabraClave(String palabra) {
		palabrasClave.remove(palabra)
	}
	
	def addReview(Review unRev) {
		if(!reviews.exists[review | review.calificador.equals(unRev.calificador)]) {
			reviews.add(unRev)
			RepoPoi.instance.update(this)
		} else {
			throw new BusinessException("Este usuario ya ha realizado una calificacion.")
		}
	}
	
	def removeReview(Review unRev) {
		reviews.remove(unRev)
	}

	override equals(Object obj) {
		if (obj == null) return false
		
		if (this.id.equals((obj as Poi).id)) {
			return true
		}
		
		return false
	}
	
	override hashCode() {
		return this.id.hashCode
	}

}
