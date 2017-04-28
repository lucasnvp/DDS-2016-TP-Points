package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServicioDelCGP
import java.util.ArrayList
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.geodds.Point
import org.uqbar.geodds.Polygon
import javax.persistence.Entity
import javax.persistence.Column
import javax.persistence.OneToMany
import javax.persistence.FetchType
import javax.persistence.Transient

@Accessors
@Entity
class CGP extends Poi {

	@Column(length=3)
	String numeroDeComuna
	
	@Transient
	Polygon comuna
	
	@Column(length=100)
	String director
	
	@Column(length=150)
	String barriosQueIncluye
	
	@Column(length=12)
	String telefono
	
	@OneToMany(fetch=FetchType.LAZY)
	Collection<ServicioDelCGP> servicios = new ArrayList()

	new(String nombreDelPoi, String direccionDelPoi, Double longitudDelPoi, Double latitudDelPoi) {
		nombre = nombreDelPoi
		direccion = direccionDelPoi
		point = new Point(longitudDelPoi, latitudDelPoi)
		comuna = new Polygon()

	}

	new(String nombreDelPoi, String nombreDirector, String barrios, String telef, String direcc, Double longitudDelPoi,
		Double latitudDelPoi) {
			
		nombre = nombreDelPoi
		director = nombreDirector
		barriosQueIncluye = barrios
		telefono = telef
		direccion = direcc
		point = new Point(longitudDelPoi, latitudDelPoi)
		comuna = new Polygon()
		comuna.add(point)
	}

	new(String nombreDelPoi, String nombreDirector, String barrios, String telef, String direcc, Double longitudDelPoi,
		Double latitudDelPoi, Collection<ServicioDelCGP> serv) {
		nombre = nombreDelPoi
		director = nombreDirector
		barriosQueIncluye = barrios
		telefono = telef
		direccion = direcc
		point = new Point(longitudDelPoi, latitudDelPoi)
		servicios = serv
		comuna = new Polygon()
		comuna.add(point)
	}
	
	new() {
		
	}
	
	override miTipoPoi() {
		"CGP"
	}

	override agregarServicio(String nombreDelServicio, int diasDisponibles, int horaDeApertura, int minDeApertura,
		int horaDeCierre, int minDeCierre) {
		servicios.add(
			new ServicioDelCGP(nombreDelServicio, diasDisponibles, horaDeApertura, minDeApertura, horaDeCierre,
				minDeCierre))
	}

	override consultaDeCercania(Point consultaDePoint) {
		comuna.isInside(consultaDePoint)
	}

	override consultaDeDisponibilidad(DateTime fecha, String rubroDelPoi) {

		(servicios.findFirst[buscarServicio(rubroDelPoi)]).estasDisponible(fecha, rubroDelPoi)

	}

	override contieneExtra(String texto) {
		return ((servicios.exists[servicio|servicio.buscarServicio(texto)]))
	}

}
