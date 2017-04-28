package ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores

import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ManejadorDeErrores
import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.Proceso
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator

class ErrorReintentable implements ManejadorDeErrores {
	
	int reintentos
	
	new(int cantidad) {
		reintentos = cantidad
	}
	
	override huboError(Proceso p) {
		for(var i = 0; i < reintentos; i++) {
			if (p.getEstadoError) {
				p.procesar()
			}
		}
		
		if (p.getEstadoError) ServiceLocator.getInstance().logResults.loggearError(p)
	}
}