package ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters

import java.util.Collection
import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi

interface AdapterBuscador {
	def Object getServicioExterno()	
	def Collection<Poi> buscar(String texto)
}