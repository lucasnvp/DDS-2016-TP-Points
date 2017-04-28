package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.BajaDePois
import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.ProcesoCompBuilder
import ar.edu.utn.frba.dds.SistemaDeConsultas.mocks.ServicioDeRestMock
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestProcesosMultiples {
	// Variables 
	Poi starbucksLibertador
	Poi burguerKing
	Poi starbucksMaipu
	Poi carrousel
	Poi colectivoLinea71
	RepoPoi repositorio = RepoPoi.getInstance()
	PoiFactory poiFactory = new PoiFactory
	
	//Servicio Externo de bajas de pois
	BajaDePois servicioRest = new BajaDePois
	
	//Builder de procesos
	ProcesoCompBuilder procesoCompBuilder = new ProcesoCompBuilder
	
	@Before
	//Creacion de pois
	def void setUp() {
		//Locales Comerciales
		starbucksLibertador =	poiFactory.parametrosBasicos("Starbucks", "Dir", -34.483346, -58.489661).
								parametrosLocalComercial(500.0, "Cafeteria").
								addWordsKey("Cafe").
								disponibilidadTodosLosDiasDe8a23().
								crearLocalComercial
		
		burguerKing = 	poiFactory.parametrosBasicos("Burger King", "Dir", -34.480581, -58.492341).
						parametrosLocalComercial(500.0, "Comidas Rapidas").
						addWordsKey("hamburguesa").addWordsKey("churrascos").
						disponibilidad(7, 8, 0, 23, 0).
						crearLocalComercial
		
		starbucksMaipu =	poiFactory.parametrosBasicos("Starbucks Maipu", "Dir", -34.528961, -58.481043).
							parametrosLocalComercial(500.0, "Cafeteria").
							disponibilidadTodosLosDiasDe8a23().
						 	crearLocalComercial
		
		carrousel =	poiFactory.parametrosBasicos("Carrousel", "Dir", -34.453317, -58.541989).
					parametrosLocalComercial(1000.0, "Plaza").
					disponibilidad(6, 10, 30, 13, 0).
					disponibilidad(6, 17, 0, 20, 30).
					crearLocalComercial
		
		//Paradas de colectivo
		colectivoLinea71 = 	poiFactory.parametrosBasicos("Parada 1", "Dir", -34.515246, -58.488491).
							parametrosParadaDeColectivo("71").
							crearParadaDeColecnivo
		
		//Creacion del Repositorio
		//Ingreso las paradas de colectivo al repo
		repositorio.create(colectivoLinea71)
		//Ingreso los locales comerciales al repo
		repositorio.create(starbucksLibertador)
		repositorio.create(burguerKing)
		repositorio.create(starbucksMaipu)
		repositorio.create(carrousel)
		
		//Servicio Externo de Baja de pois
		servicioRest.setearRepo(repositorio)
			
	}
	
	/* Comienzo de test de Procesos Multiples */
	
	@Test
	/* Test de borrado */
	def void testProcesoMultipleConBajaDePois(){
		var servicio = new ServicioDeRestMock
		servicio.serviciosValidos
		servicioRest.seterarServicio(servicio)
		
		Assert.assertEquals(5, repositorio.allInstances.size)
		
		var procesoCompuesto = procesoCompBuilder.baja(servicioRest).build
		procesoCompuesto.procesar
		
		Assert.assertEquals(4, repositorio.allInstances.size)
	}
	
	@Test
	/* Test de borrado */
	def void testProcesoMultipleConBajaDePoisConServiciosInvalidosYValidos(){
		var servicio = new ServicioDeRestMock
		servicio.serviciosInvalidosYValidos
		servicioRest.seterarServicio(servicio)
		
		Assert.assertEquals(5, repositorio.allInstances.size)
		
		var procesoCompuesto = procesoCompBuilder.baja(servicioRest).build
		procesoCompuesto.procesar
		
		Assert.assertEquals(4, repositorio.allInstances.size)
		Assert.assertEquals(1, servicioRest.consultarSizeDeNoEliminados)
		
	}
	
	/* Fin de test de Procesos Multiples */
	
	@After
	//Restablece el Repositorio
	def void restablecerSistema() {	
		repositorio.allInstances.clear
	}
	
}