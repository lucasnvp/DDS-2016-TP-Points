package ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Busqueda

import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi
import ar.edu.utn.frba.dds.SistemaDeConsultas.PoiFactory
import ar.edu.utn.frba.dds.SistemaDeConsultas.RepoPoi
import org.uqbar.arena.bootstrap.CollectionBasedBootstrap
import org.uqbar.commons.utils.ApplicationContext

class BusquedaBootstrap extends CollectionBasedBootstrap{
	
	new() {
		ApplicationContext.instance.configureSingleton(typeof(Poi), new RepoPoi)
		ApplicationContext.instance.configureSingleton(typeof(Usuario), new RepoPerfilesUsuario)
	}
	
	override run(){
		val repoPoi = ApplicationContext.instance.getSingleton(typeof(Poi)) as RepoPoi
		val repoUsers = ApplicationContext.instance.getSingleton(typeof(Usuario)) as RepoPerfilesUsuario 
		
		val poiFactory = new PoiFactory
		
		repoPoi => [
			create(poiFactory.parametrosBasicos("Starbucks", "Dir", -34.483346, -58.489661).
								parametrosLocalComercial(500.0, "Cafeteria").
								addWordsKey("Cafe").
								disponibilidadTodosLosDiasDe8a23().
								crearLocalComercial)
								
			create(poiFactory.parametrosBasicos("Starbucks", "Dir", -34.483346, -58.489661).
								parametrosLocalComercial(500.0, "Cafeteria").
								addWordsKey("Cafe").
								disponibilidadTodosLosDiasDe8a23().
								crearLocalComercial)
								
			create(poiFactory.parametrosBasicos("Starbucks Maipu", "Dir", -34.528961, -58.481043).
							parametrosLocalComercial(500.0, "Cafeteria").
							disponibilidadTodosLosDiasDe8a23().
						 	crearLocalComercial)
						 	
			create(poiFactory.parametrosBasicos("Carrousel", "Dir", -34.453317, -58.541989).
					parametrosLocalComercial(1000.0, "Plaza").
					disponibilidad(6, 10, 30, 13, 0).
					disponibilidad(6, 17, 0, 20, 30).
					crearLocalComercial)
					
			create(poiFactory.parametrosBasicos("Parada 1", "Dir", -34.515246, -58.488491).
							parametrosParadaDeColectivo("71").
							crearParadaDeColecnivo)
		]
		
		repoUsers => [
			addUsuario(new Usuario("terminalAbasto"))
			addUsuario(new Usuario("terminalObelisco"))
			//addUsuario(new Administrador("Carlos", "carlos@sysadmin.com"))
		]
		
	}
}