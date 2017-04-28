package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Disponibilidad.IntervalosDeDisponibilidad
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServicioDelCGP
import java.util.ArrayList
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class PoiFactory {
	
	Poi unPoi
	//ParametrosBasicos
	String Nombre
	String Direccion
	Double Longitud
	Double Latitud
	Collection<String> WordsKey = new ArrayList()
	Collection<IntervalosDeDisponibilidad> Availability = new ArrayList()
	
	//Parametros de Local Comercial
	Double Cercania
	String RubroDelLocal
	
	//Parametros del Banco
	String Sucursal
	String Gerente
	
	//Parametros de Parada De Colectivo
	String Nro
	
	//Parametros del CGP
	Collection<ServicioDelCGP> Servicios = new ArrayList()
	
	def parametrosBasicos(String nombre, String direccion, Double longitud,Double latitud){
		Nombre = nombre
		Direccion = direccion
		Longitud = longitud
		Latitud = latitud
		this
	}
	
	//Bancos
	def parametrosBanco(String sucursal, String gerente){
		Sucursal = sucursal
		Gerente = gerente	
		this	
	}
	
	def crearBanco(){
		unPoi = new Banco(Nombre, Direccion, Longitud, Latitud, Sucursal, Gerente)
		unPoi.addPalabrasClaves(WordsKey)
		WordsKey.clear
		unPoi
	}
	
	//CGPs
	def crearCGP(){
		unPoi = new CGP(Nombre, Direccion, Longitud, Latitud)
		Servicios.forEach[unServicio | unPoi.agregarServicio(
			unServicio.nombreDelServicio,
			unServicio.disponibilidadDelPoi.disponibilidades.last.diaDeLaSemana,
			unServicio.disponibilidadDelPoi.disponibilidades.last.horaDeApertura,
			unServicio.disponibilidadDelPoi.disponibilidades.last.minDeApertura,
			unServicio.disponibilidadDelPoi.disponibilidades.last.horaDeCierre,
			unServicio.disponibilidadDelPoi.disponibilidades.last.minDeCierre
		)]
		Servicios.clear
		unPoi
	}
	
	def addServicio(String nombreDelServicio,int diasHabiles,int horaDeApertura,int minDeApertura,int horaDeCierre, int minDeCierre){
		var unServicio = new ServicioDelCGP(nombreDelServicio,diasHabiles,horaDeApertura,minDeApertura,horaDeCierre,minDeCierre)
		Servicios.add(unServicio)
		this
	}
	
	//Local Comercial
	def parametrosLocalComercial(Double cercania, String rubroDelLocal){
		Cercania = cercania
		RubroDelLocal = rubroDelLocal
		this
	}
	
	def crearLocalComercial(){
		unPoi = new LocalComercial(Nombre, Direccion, Longitud, Latitud, Cercania, RubroDelLocal)
		unPoi.addPalabrasClaves(WordsKey)
		WordsKey.clear
		Availability.forEach[unInt | unPoi.configurarDisponibilidadDelPoi(
			unInt.diaDeLaSemana,unInt.horaDeApertura,unInt.minDeApertura,unInt.horaDeCierre,unInt.minDeCierre
		)]
		Availability.clear
		unPoi
	}
	
	//Parada de colectivo
	def parametrosParadaDeColectivo(String nro){
		Nro = nro
		this
	}
	
	def crearParadaDeColecnivo(){
		unPoi = new ParadaDeColectivo(Nombre, Direccion, Longitud, Latitud, Nro)
		unPoi.addPalabrasClaves(WordsKey)
		WordsKey.clear
		unPoi
	}
	
	//Parametros adicionales
	def addWordsKey(String palabra){
		WordsKey.add(palabra)
		this
	}
	
	def addAllWordsKey(Collection<String> palabrasClaves){
		WordsKey.addAll(palabrasClaves)
		this
	}
	
	
	def disponibilidad(int diasHabiles,int horaDeApertura,int minDeApertura,int horaDeCierre, int minDeCierre){
		var unaDisponibilidad = new IntervalosDeDisponibilidad(diasHabiles,horaDeApertura,minDeApertura,horaDeCierre,minDeCierre)
		Availability.add(unaDisponibilidad)
		this
	}
	
	def disponibilidadLaV9a17(){
		var unaDisponibilidad = new IntervalosDeDisponibilidad(5,9,0,17,0)
		Availability.add(unaDisponibilidad)
		this
	}
	
	def disponibilidadLaV10a18(){
		var unaDisponibilidad = new IntervalosDeDisponibilidad(5,10,0,18,0)
		Availability.add(unaDisponibilidad)
		this
	}
	
	def disponibilidadTodosLosDiasDe8a23(){
		var unaDisponibilidad = new IntervalosDeDisponibilidad(7,8,0,23,0)
		Availability.add(unaDisponibilidad)
		this
	}
	
}