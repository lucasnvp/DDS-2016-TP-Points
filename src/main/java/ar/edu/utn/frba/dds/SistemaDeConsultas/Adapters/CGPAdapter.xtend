package ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters

import ar.edu.utn.frba.dds.SistemaDeConsultas.CGP
import java.util.List
import java.util.ArrayList
import org.uqbar.geodds.Point
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServicioDelCGP
import ar.edu.utn.frba.dds.SistemaDeConsultas.mocks.ServicioDeConsultaCGPRemotosMock
import java.util.Collection
import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServicioDeConsultaCGPRemotos

class CGPAdapter implements AdapterBuscador {

	ServicioDeConsultaCGPRemotos servicioExterno = new ServicioDeConsultaCGPRemotos()

	new() {
	}

	override buscar(String texto) {

		adaptarCentrosDTOACGPsLocales(servicioExterno.consultarCentrosDTO(texto))

	}

	def private ArrayList<Poi> adaptarCentrosDTOACGPsLocales(List<CGP> listaDeCentrosDTO) {

		val listaCGPS = new ArrayList<Poi>

		listaDeCentrosDTO.forEach[centroDTO|listaCGPS.add(adaptarUnCGPDTOAUnCGPLocal(centroDTO))]

		listaCGPS

	}
	
	override getServicioExterno() {
		servicioExterno
	}

	def CGP adaptarUnCGPDTOAUnCGPLocal(CGP unCentroDTO) {

		var String nombre = "CGP Comuna #" + unCentroDTO.numeroDeComuna
		var String director = unCentroDTO.director
		var String barrios = unCentroDTO.barriosQueIncluye
		var String telefono = unCentroDTO.telefono
		var String direccion = unCentroDTO.direccion
		var Point point = unCentroDTO.point
		var Collection<ServicioDelCGP> servicios = unCentroDTO.servicios

		var CGP unCGP = new CGP(nombre, director, barrios, telefono, direccion, point.latitude, point.longitude,
			servicios)
		unCGP

	}
	
	override boolean equals(Object obj) {
		if(obj.class == this.class)
		{ 
			return true
		}
		return false
	}
	
	override int hashCode() {
		return (2)
	}
}
