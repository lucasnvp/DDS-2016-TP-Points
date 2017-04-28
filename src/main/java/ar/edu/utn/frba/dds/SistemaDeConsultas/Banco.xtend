package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.DisponibilidadDelPoi
import java.util.ArrayList
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point
import javax.persistence.ElementCollection
import javax.persistence.CollectionTable
import javax.persistence.Column
import javax.persistence.JoinColumn
import javax.persistence.Entity
import org.hibernate.annotations.LazyCollectionOption
import org.hibernate.annotations.LazyCollection

@Accessors
@Entity
class Banco extends Poi {
	
	@Column(length=30)
	String rubroDelPoi
	
	@Column(length=50)	
	String sucursal
	
	@Column(length=50)
	String gerente
	
	@ElementCollection
	@LazyCollection(LazyCollectionOption.FALSE)
	@CollectionTable(name="Servicios", joinColumns=@JoinColumn(name="poi_id"))
	@Column(name="servicios")
	Collection<String> servicios
	
	new (){}
	
	new(String nombreDelPoi, String direccionDelPoi,Double longitudDelPoi,Double latitudDelPoi, String sucursal, String gerente) {
		nombre = nombreDelPoi 
		direccion = direccionDelPoi
		point = new Point(longitudDelPoi, latitudDelPoi)
		rubroDelPoi = "bancario"
		servicios = new ArrayList()	
		this.sucursal = sucursal
		this.gerente = gerente	
		
		//Configuro la disponibilidad del poi
		disponibilidadDelPoi = new DisponibilidadDelPoi()
		disponibilidadDelPoi.horarioBancario()	

	}
	
	override contieneExtra(String texto) {
		return (rubroDelPoi.contains(texto))
	}
	
	override miTipoPoi() {
		"Banco"
	}
	
	def agregarServicio(String servicio) {
		servicios.add(servicio)
	}
}