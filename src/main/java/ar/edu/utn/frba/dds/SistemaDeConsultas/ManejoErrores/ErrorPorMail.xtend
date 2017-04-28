package ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores

import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ManejadorDeErrores
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator
import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.Proceso

class ErrorPorMail implements ManejadorDeErrores {
	override huboError(Proceso p) {
		ServiceLocator.getInstance().notificarAdministradoresDeError(p)
		ServiceLocator.getInstance().logResults.loggearError(p)
	}
}