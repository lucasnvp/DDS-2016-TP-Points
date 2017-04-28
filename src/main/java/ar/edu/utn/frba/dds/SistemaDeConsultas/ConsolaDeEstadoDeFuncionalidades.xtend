package ar.edu.utn.frba.dds.SistemaDeConsultas

import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.utn.frba.dds.SistemaDeConsultas.Exception.FunctionsConsoleException

@Accessors
class ConsolaDeEstadoDeFuncionalidades {

	Integer ON = new Integer(1)
	Integer OFF = new Integer(0)

	HashMap<String, Integer> tableroDeFuncionalidades = new HashMap<String, Integer>

	def void activadaFuncionalidad(String nombreDeUnaFuncionalidad) {
		tableroDeFuncionalidades.replace(nombreDeUnaFuncionalidad, ON)
	}

	def void desactivadaFuncionalidad(String nombreDeUnaFuncionalidad) {
		tableroDeFuncionalidades.replace(nombreDeUnaFuncionalidad, OFF)
	}

	/*Todas las funcionalidades se agregan con estado OFF por default*/
	def agregarFuncionalidadAlTableroDeFuncionalidades(String nombreDeUnaFuncionalidad) {
		tableroDeFuncionalidades.put(nombreDeUnaFuncionalidad, OFF)
	}

	def quitarFuncionalidadDelTableroDeFuncionalidades(String nombreDeUnaFuncionalidad) {
		if (!tableroDeFuncionalidades.remove(nombreDeUnaFuncionalidad, OFF))
			throw new FunctionsConsoleException("Error al quitar funcionalidad del Tablero de Funcionalidades")
	}

	def consultaDeEstado(String unNombreDeFuncionalidad) {
		tableroDeFuncionalidades.get(unNombreDeFuncionalidad)
	}

}
