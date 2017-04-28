package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.DisponibilidadDelPoi
import org.uqbar.geodds.Point
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Column

@Entity
@Accessors
class LocalComercial extends Poi{
	
	@Column
	double cercaniaDistancia
	
	@Column(length=30)
	String rubroDelPoi
	
	new(String nombreDelPoi, String direccionDelPoi, Double longitudDelPoi, Double latitudDelPoi, Double cercaniaDelPoi, String rubroDelLocal) {
		nombre = nombreDelPoi
		direccion = direccionDelPoi
		point = new Point(longitudDelPoi, latitudDelPoi)
		cercaniaDistancia = cercaniaDelPoi
		rubroDelPoi = rubroDelLocal
		//Configuro la disponibilidad del poi
		disponibilidadDelPoi = new DisponibilidadDelPoi()
	}
	
	new() {
		
	}
	
	override miTipoPoi() {
		"LocalComercial"
	}
	
	override consultaDeCercania(Point consultaDePoint){
		seEncuentraAMenosDe(cercaniaDistancia, consultaDePoint)
	}
					
	override contieneExtra(String texto) {
		return (rubroDelPoi.contains(texto))
	}

}