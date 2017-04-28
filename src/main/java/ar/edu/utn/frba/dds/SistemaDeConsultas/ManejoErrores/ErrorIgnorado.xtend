package ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores

import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ManejadorDeErrores
import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.Proceso
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator

class ErrorIgnorado implements ManejadorDeErrores {
	override huboError(Proceso p) {
		//no hago nada mas que loggear
		ServiceLocator.getInstance().logResults.loggearError(p)
	}
}