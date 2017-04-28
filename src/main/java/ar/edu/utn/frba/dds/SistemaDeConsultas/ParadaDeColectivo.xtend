package ar.edu.utn.frba.dds.SistemaDeConsultas

import org.joda.time.DateTime
import org.uqbar.geodds.Point
import javax.persistence.Entity
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Column

@Entity
@Accessors
class ParadaDeColectivo extends Poi{
	
	@Column(length=4)
	String numeroDeLinea;
		
	new(String nombreDelPoi, String direccionDelPoi, Double longitudDelPoi,Double latitudDelPoi, String n){
		nombre = nombreDelPoi
		direccion = direccionDelPoi
		point = new Point(longitudDelPoi, latitudDelPoi)

		numeroDeLinea = n
	}
	
	new() {
		
	}
	
	override miTipoPoi() {
		"ParadaDeColectivo"
	}
	
	override consultaDeCercania(Point consultaDePoint){
		seEncuentraAMenosDe(100.0, consultaDePoint)
	}
	
	override consultaDeDisponibilidad(DateTime fecha, String rubroDelPoi){
		true
	}	
	
	override contieneExtra(String texto) {
		return (numeroDeLinea.equals(texto))
		
	}
}