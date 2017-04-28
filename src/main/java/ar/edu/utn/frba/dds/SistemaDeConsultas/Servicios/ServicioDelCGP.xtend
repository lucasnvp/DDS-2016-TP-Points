package ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios

import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.DisponibilidadDelPoi
import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.IntervalosDeDisponibilidad
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import javax.persistence.OneToOne
import javax.persistence.CascadeType

@Entity
@Accessors
class ServicioDelCGP {
	
	@Id
	@GeneratedValue
	private long id

	@Column(length=50)
	String nombreDelServicio
	
	@OneToOne(cascade=CascadeType.ALL)
	DisponibilidadDelPoi disponibilidadDelPoi
	
	new() {
		
	}

	new(String nombreDelNuevoServicio, int diaDeLaSemanaDelPoi, int horaDeAperturaDelPoi, int minDeAperturaDelPoi,
		int horaDeCierreDelPoi, int minDeCierreDelPoi) {
		nombreDelServicio = nombreDelNuevoServicio

		// Configuro la disponibilidad del poi
		disponibilidadDelPoi = new DisponibilidadDelPoi()
		disponibilidadDelPoi.horarioDelLocal(diaDeLaSemanaDelPoi, horaDeAperturaDelPoi, minDeAperturaDelPoi,
			horaDeCierreDelPoi, minDeCierreDelPoi)
	}

	new(String nombreDelNuevoServicio, ArrayList<IntervalosDeDisponibilidad> unalistaDeIntervalosDeDispnibilidades) {
		nombreDelServicio = nombreDelNuevoServicio
		// Configuro la disponibilidad del poi
		disponibilidadDelPoi = new DisponibilidadDelPoi()
		unalistaDeIntervalosDeDispnibilidades.forEach( cadaIntervalo |
			disponibilidadDelPoi.disponibilidades.add(cadaIntervalo)
		)

	}

	def estasDisponible(DateTime fecha, String rubroDelCGP) {
		disponibilidadDelPoi.consultaDeDisponibilidad(fecha, rubroDelCGP)
	}

	def buscarServicio(String rubroDelCGP) {
		nombreDelServicio.contains(rubroDelCGP)
	}

}
