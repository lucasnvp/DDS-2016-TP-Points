package ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos

import ar.edu.utn.frba.dds.SistemaDeConsultas.RepoPoi
import ar.edu.utn.frba.dds.SistemaDeConsultas.mocks.ServicioDeRestMock
import org.json.simple.JSONArray
import org.json.simple.JSONObject
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator
import org.json.simple.JSONValue
import java.util.LinkedHashMap

class BajaDePois implements Proceso {
	
	ServicioDeRestMock servicioRest
	RepoPoi repositorio
	JSONArray jsonPois = new JSONArray();
	JSONArray poisNoDelete = new JSONArray();
	boolean error
	int reintentos = -1
	
	def void setearRepo(RepoPoi repo){
		repositorio = repo
	}
	
	def void setearPois(JSONArray pois){
		jsonPois = pois
	}
	
	def void seterarServicio(ServicioDeRestMock serv){
		servicioRest = serv
	}
	
	override getReintentos() {
		reintentos
	}
	
	override procesar() {
		error = false
		deletePois() //asumo? cambiar si necesario
		if (!this.getEstadoError) 
			ServiceLocator.getInstance().logResults.loggearOk(this) 
		else 
			ServiceLocator.getInstance().logResults.loggearError(this)
	}
	
	def deletePois(){
		//servicioRest.consultarBaja.forEach[ unPoi | 
		jsonPois.forEach[ jsonPoi | 
			var unPoi = (jsonPoi as LinkedHashMap<String,String>)

			 var poiToDelete = repositorio.getCriterioPorNombre(unPoi.get("Valor"))
			
			if(poiToDelete != null){
				repositorio.delete(poiToDelete)
			}
			else{
				poisNoDelete.add(unPoi)
				error = true
				if (reintentos < 0) {
					reintentos++
					ServiceLocator.getInstance.servicioErrores.huboError(this)
				}	
				else { reintentos++ }
			} 
			
		]
	}
	
	def consultarSizeDeNoEliminados(){
		poisNoDelete.size
	}	
	
	override getEstadoError() {
		error
	}
	
}