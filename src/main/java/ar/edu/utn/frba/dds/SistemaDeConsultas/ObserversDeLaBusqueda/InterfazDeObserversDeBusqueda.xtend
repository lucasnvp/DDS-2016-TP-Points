package ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda

import ar.edu.utn.frba.dds.SistemaDeConsultas.BusquedaRealizada

interface InterfazDeObserversDeBusqueda {
	
	def void observarBusqueda(BusquedaRealizada laBusqueda)
}