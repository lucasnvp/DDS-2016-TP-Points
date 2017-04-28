package ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos

import static extension com.google.common.io.CharStreams.*
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator
import java.util.HashMap
import java.util.ArrayList
import java.io.FileReader
import ar.edu.utn.frba.dds.SistemaDeConsultas.RepoPoi
import ar.edu.utn.frba.dds.SistemaDeConsultas.LocalComercial
import java.io.FileNotFoundException
import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ErrorPorMail

class ActualizadorDeLocalesComerciales implements Proceso {
	
	boolean error //estado
	int reintentos = -1
	val lineasDeActualizacionesNoAceptadas = new ArrayList<String>
	
	new(){
		
	}
	
	override getReintentos() {
		reintentos
	}

	override void procesar() {
		error = false
		
		val actualizaciones = this.
			crearEstructuraHMDeActualizacionesConArrayListDeLineas(solicitarLineasDeActualizaciones)
		
		val localesComercialesEnRepoDePoIsLocal = RepoPoi.getInstance.allInstances.filter(cadaPoI | cadaPoI.class.equals(LocalComercial))

		actualizaciones.forEach [ nombreFantasia, nuevaListaDePalabrasClaves |

			val localesComercialesConNombreFantasiaParaActualizarPalabrasClave = localesComercialesEnRepoDePoIsLocal.
				filter[lc|lc.nombre.equals(nombreFantasia)].toList

			localesComercialesConNombreFantasiaParaActualizarPalabrasClave.forEach [ lcpa |
				lcpa.palabrasClave.clear
				lcpa.palabrasClave.addAll(nuevaListaDePalabrasClaves)
			]
		]
		
		if (!this.getEstadoError) ServiceLocator.getInstance().logResults.loggearOk(this)
	} 

	def HashMap<String, ArrayList<String>> crearEstructuraHMDeActualizacionesConArrayListDeLineas(
		ArrayList<String> arrayListDeLineasDeActualizaciones) {

		val estructuraHMDeActualizaciones = new HashMap<String, ArrayList<String>>

		arrayListDeLineasDeActualizaciones.forEach [ cadaLinea |
			val nombreFantasia = (cadaLinea.split(';').get(0) as String).replaceAll('\\s', '')
			val cadenasDePalabrasClaveSeparadasPorEspacio = cadaLinea.split(';').get(1).split('[\\s]')
			val palabrasClave = new ArrayList<String>
			cadenasDePalabrasClaveSeparadasPorEspacio.forEach[cada1|if (!cada1.matches('')) {palabrasClave.add(cada1)}]
			estructuraHMDeActualizaciones.put(nombreFantasia, palabrasClave)
			
			if(!lineasDeActualizacionesNoAceptadas.empty){
				val manejadorDeErrorPorMail = new ErrorPorMail
				manejadorDeErrorPorMail.huboError(this)
//			Además de loguear el error, puedo enviar la lista de líneas rechazadas por mail)
			}
		]
		estructuraHMDeActualizaciones
	}

	def ArrayList<String> solicitarLineasDeActualizaciones() {
		
		try{
		val archivoDeActualizacionDeLocalesComerciales = ServiceLocator.getInstance.obtenerFileReaderDeRutaAArchivo(
			ServiceLocator.getInstance.getRutaAlArchivoDeAcutalizacionDeLocalesComerciales)	
			armarListaDeLineasDeActualizaciones(archivoDeActualizacionDeLocalesComerciales)
		}catch (FileNotFoundException e){
			this.error = true
			if (reintentos < 0) {
				reintentos++
				ServiceLocator.getInstance.servicioErrores.huboError(this)
			}
			else { reintentos++ }
			new ArrayList<String>
		}
	}



	def ArrayList<String> solicitarLineasDeActualizaciones(String ruta) {
		val archivoDeActualizacionDeLocalesComerciales = ServiceLocator.getInstance.
			obtenerFileReaderDeRutaAArchivo(ruta)
		armarListaDeLineasDeActualizaciones(archivoDeActualizacionDeLocalesComerciales)
	}


	def ArrayList<String> armarListaDeLineasDeActualizaciones(FileReader archivoDeActualizacionDeLocalesComerciales) {
		val listaSinDepurar = archivoDeActualizacionDeLocalesComerciales.readLines as ArrayList<String>
		val listaDepurada = new ArrayList<String>
		listaSinDepurar.forEach[cadaLinea|this.siLineaPasaTestDeFormatoAgregaAListaDepurada(cadaLinea, listaDepurada)]
		listaDepurada
	}


	def void siLineaPasaTestDeFormatoAgregaAListaDepurada(String unaLinea, ArrayList<String> unaListaDepurada) {
		/* Este RegEx acepta nombres de fantasía con guiones bajos, guiones medios y apóstrofos. No considera comillas*/
		/* No considera palabras claves con guiones,comillas o apóstrofos*/
	
		if (unaLinea.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$")) {
			unaListaDepurada.add(unaLinea)
		}
		else
		{
			lineasDeActualizacionesNoAceptadas.add(unaLinea)
		}
	}
	
	override getEstadoError() {
		error
	}
	
	def bError() {
		error = !error
	}
	
	def getLineasDeActualizacionesNoAceptadas(){
		lineasDeActualizacionesNoAceptadas
	}

}
