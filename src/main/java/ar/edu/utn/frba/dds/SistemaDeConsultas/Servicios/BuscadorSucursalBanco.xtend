package ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios

import java.util.ArrayList
import java.util.Collection
import org.json.simple.JSONArray
import org.json.simple.JSONObject

class BuscadorSucursalBanco {
	
	Collection<ar.edu.utn.frba.dds.SistemaDeConsultas.Banco> sucursales	
	JSONObject sucursalJson
	JSONArray sucursalesJson
	JSONArray servicios
	
	new() {
		sucursales = new ArrayList()
		sucursales.add(new ar.edu.utn.frba.dds.SistemaDeConsultas.Banco("Banco Santander", "Direccion 1", -34.528961, -58.481043, "Villa Luro", "Fabio Perez"))
		sucursales.add(new ar.edu.utn.frba.dds.SistemaDeConsultas.Banco("Banco Rio", "Direccion 2",-36.528961, -55.481043, "Villa Soldati", "Juan Perez"))
	}
	
	def JSONArray buscar(String nombreBanco) {
		if (sucursales.size > 0) 			
			buscarBanco(nombreBanco) 						
		
		return sucursalesJson
	}
	
	def buscarBanco(String nombreBanco) {
		sucursalesJson = new JSONArray();
		for(ar.edu.utn.frba.dds.SistemaDeConsultas.Banco sucursal : sucursales) 
			if (sucursal.nombre.toLowerCase().contains(nombreBanco.toLowerCase())) 
				convertirAJson(sucursal)														
	}
	
	def convertirAJson(ar.edu.utn.frba.dds.SistemaDeConsultas.Banco sucursal) {
		sucursalJson= new JSONObject()								
				
		sucursalJson.put("banco", sucursal.nombre) 
		sucursalJson.put("x", sucursal.point.latitude)
		sucursalJson.put("y", sucursal.point.longitude)
		sucursalJson.put("sucursal", sucursal.sucursal) 
		sucursalJson.put("gerente", sucursal.gerente)		
		
		if (sucursal.servicios.size > 0) 
			agregarServicios(sucursal)														
					 						
		sucursalesJson.add(sucursalJson)
	}
	
	def agregarServicios(ar.edu.utn.frba.dds.SistemaDeConsultas.Banco sucursal) {
		servicios = new JSONArray()
		
		for(String servicio : sucursal.servicios) 
			servicios.add(servicio)	
			
		sucursalJson.put("servicios", servicios)
	}
	
	def agregarBanco(ar.edu.utn.frba.dds.SistemaDeConsultas.Banco banco) {
		sucursales.add(banco)
	}
	
}
		