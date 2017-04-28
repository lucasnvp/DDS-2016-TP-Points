package ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad

import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.IntervalosDeDisponibilidad
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import javax.persistence.Entity
import javax.persistence.CascadeType
import javax.persistence.FetchType
import javax.persistence.OneToMany
import javax.persistence.Id
import javax.persistence.GeneratedValue
import java.util.List

@Accessors
@Entity 
class DisponibilidadDelPoi {
	
	/* Array de dias de la semana
	 * 1 = Lunes | 2 = Martes | 3 = Miercoles | 4 = Jueves | 5 = Viernes 
	 * 6 = Sabado | 7 = Domingo
	 */
	
	@Id
	@GeneratedValue
	private long id
	
	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL) 
	List<IntervalosDeDisponibilidad> disponibilidades = new ArrayList()
	
	new() {
		
	}
	
	def add(int dia, int horaDeApertura, int minDeApertura, int horaDeCierre, int minDeCierre){
		disponibilidades.add(new IntervalosDeDisponibilidad(dia, horaDeApertura, minDeApertura, horaDeCierre, minDeCierre))
	}
	
	def horarioBancario(){
		for (i : 0 ..< 5) {
			disponibilidades.add(new IntervalosDeDisponibilidad(i, 10, 0, 15, 0))
		}

	}
	
	def horarioDelLocal(int cantDeDias,int horaDeApertura, int minDeApertura, int horaDeCierre, int minDeCierre){
		for (i : 0 ..< cantDeDias) {
			disponibilidades.add(new IntervalosDeDisponibilidad(i, horaDeApertura, minDeApertura, horaDeCierre, minDeCierre))
		}
	}
	 	
	def consultaDeDisponibilidad(DateTime fecha, String rubro){
		disponibilidades.exists[intervalosDeDisponibilidad | intervalosDeDisponibilidad.consultaDeDisponibilidad(fecha)]
	}
	
}
