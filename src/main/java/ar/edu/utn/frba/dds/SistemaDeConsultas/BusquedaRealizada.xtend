package ar.edu.utn.frba.dds.SistemaDeConsultas

import org.joda.time.DateTime
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import java.math.BigDecimal

@Accessors
class BusquedaRealizada {
	DateTime fechaDeLaBusqueda
	String fraseBuscada
	Usuario fDTerminal
	double tiempoDeConsulta
	BigDecimal cantidadDeElementosEncontrados

	new() {
	}

	new(String cadenaBuscada, Usuario unUsuario, double elTiempoDeLaConsulta, BigDecimal unaCantidadDeElementosEncontrados) {
		fechaDeLaBusqueda = DateTime.now()
		fraseBuscada = cadenaBuscada
		fDTerminal = unUsuario
		tiempoDeConsulta = elTiempoDeLaConsulta
		cantidadDeElementosEncontrados = unaCantidadDeElementosEncontrados
	}
}
