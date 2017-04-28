package ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores

import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.Proceso
import java.time.LocalDate
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ResultsLog {
	
	List<String> log = new ArrayList<String>
	
	def loggearOk(Proceso p) {
		log.add(LocalDate.now().toString + " - Finalizo correctamente el proceso de tipo " + p.class.toString)
	}
	
	def loggearError(Proceso p) {
		log.add(LocalDate.now().toString + " - Hubo error en la ejecucion del proceso de tipo " + p.class.toString)
	}
}