package ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores

import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.Proceso

interface ManejadorDeErrores {
	def void huboError(Proceso p)
}