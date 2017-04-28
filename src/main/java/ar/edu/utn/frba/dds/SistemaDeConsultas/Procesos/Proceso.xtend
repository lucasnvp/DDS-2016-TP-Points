package ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos

interface Proceso {
	def void procesar()
	def boolean getEstadoError()
	def int getReintentos()
}