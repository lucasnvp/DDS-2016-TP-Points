package ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad

import org.joda.time.DateTime
import org.joda.time.Interval
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Column
import javax.persistence.OneToOne
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Transient

@Accessors
@Entity
class IntervalosDeDisponibilidad {
	
	@Id
	@GeneratedValue
	private long id

	@Column
	int diaDeLaSemana
	
	@Column
	int horaDeApertura
	
	@Column
	int minDeApertura
	
	@Column
	int horaDeCierre
	
	@Column
	int minDeCierre
	
	@Transient
	Interval intervaloDeTrabajo
	
	new() {
		
	}

	new(int diaDeLaSemanaDelPoi, int horaDeAperturaDelPoi, int minDeAperturaDelPoi, int horaDeCierreDelPoi,
		int minDeCierreDelPoi) {
		diaDeLaSemana = diaDeLaSemanaDelPoi
		horaDeApertura = horaDeAperturaDelPoi
		minDeApertura = minDeAperturaDelPoi
		horaDeCierre = horaDeCierreDelPoi
		minDeCierre = minDeCierreDelPoi
	}

	def consultaDeDisponibilidad(DateTime fecha) {

		val start = new DateTime(fecha.getYear, fecha.getMonthOfYear, fecha.getDayOfMonth, horaDeApertura,
			minDeApertura)
		val end = new DateTime(fecha.getYear, fecha.getMonthOfYear, fecha.getDayOfMonth, horaDeCierre, minDeCierre)
		intervaloDeTrabajo = new Interval(start, end)

		diaDeLaSemana == fecha.getDayOfWeek && intervaloDeTrabajo.contains(fecha)

	}

}
