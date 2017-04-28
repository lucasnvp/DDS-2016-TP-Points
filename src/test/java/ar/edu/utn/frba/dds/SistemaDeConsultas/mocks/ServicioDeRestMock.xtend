package ar.edu.utn.frba.dds.SistemaDeConsultas.mocks

import org.json.simple.JSONArray
import org.json.simple.JSONObject
import org.joda.time.DateTime

class ServicioDeRestMock {
	JSONArray pois = new JSONArray();
	JSONObject poiburguerKing = new JSONObject()	
	
	def consultarBaja(){
		pois
	}
	
	def serviciosValidos(){
		poiburguerKing.put("Valor", "Burger King")
		poiburguerKing.put("Date", new DateTime)
		pois.add(poiburguerKing)
	}
	
	def serviciosInvalidos(){
		poiburguerKing.put("Valor", "Mostaza")
		poiburguerKing.put("Date", new DateTime)
		pois.add(poiburguerKing)
	}
	
	def serviciosInvalidosYValidos(){
		poiburguerKing.put("Valor", "Mostaza")
		poiburguerKing.put("Date", new DateTime)
		pois.add(poiburguerKing)
		poiburguerKing.put("Valor", "Burger King")
		poiburguerKing.put("Date", new DateTime)
		pois.add(poiburguerKing)
	}
	
}