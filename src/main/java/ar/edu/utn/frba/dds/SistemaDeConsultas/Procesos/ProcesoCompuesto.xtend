package ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos

import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.Proceso
import java.util.List
import java.util.ArrayList
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator

class ProcesoCompuesto implements Proceso {
	
	List<Proceso> procesos = new ArrayList<Proceso>
	
	def agregarProceso(Proceso proc) {
		procesos.add(proc)
	}
	
	override procesar() {
		procesos.forEach[ proceso | proceso.procesar() ]
	}
	
	override getEstadoError() {
		procesos.exists[ proc | proc.getEstadoError() ]
	}
	
	override getReintentos() {
		procesos.get(0).getReintentos
	}
	
}