package ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters

import org.json.simple.JSONArray
import org.json.simple.JSONObject
import java.util.Collection
import java.util.ArrayList
import ar.edu.utn.frba.dds.SistemaDeConsultas.Banco
import ar.edu.utn.frba.dds.SistemaDeConsultas.mocks.StubBuscadorSucursalBanco
import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.BuscadorSucursalBanco

class BancoAdapter implements AdapterBuscador{
	
	BuscadorSucursalBanco servicioExterno = new BuscadorSucursalBanco()
	
	override buscar(String texto) {
		var JSONArray bancosJson = servicioExterno.buscar(texto)
		var Collection<Banco> listaBancos = convertirDeJson(bancosJson)
		
		var Collection<Poi> listaBancosComoPoi
		listaBancosComoPoi = new ArrayList<Poi>(listaBancos)
		return listaBancosComoPoi
	}
	
	//para settear si se crea vacio
	def setInterfaz(BuscadorSucursalBanco unaInterfaz) {
		servicioExterno = unaInterfaz
	}
		
	def Collection<Banco> convertirDeJson (JSONArray sucursales) {
		val Collection<Banco> resultadoSucursales = new ArrayList()
		sucursales.forEach[ sucursal |
			var Banco resultadoSucursal = new Banco((sucursal as JSONObject).get("banco") as String,
														(sucursal as JSONObject).get("direccion") as String,
														 (sucursal as JSONObject).get("x") as Double,
														 (sucursal as JSONObject).get("y") as Double,
														 (sucursal as JSONObject).get("sucursal") as String,
														 (sucursal as JSONObject).get("gerente") as String)
			resultadoSucursales.add(resultadoSucursal)														 														 
		]
		
		return resultadoSucursales
	}
	
	override getServicioExterno() {
		servicioExterno
	}
	
		override boolean equals(Object obj) {
		if(obj.class == this.class)
		{ 
			return true
		}
		return false
	}
	
	override int hashCode() {
		return (5)
	}
}