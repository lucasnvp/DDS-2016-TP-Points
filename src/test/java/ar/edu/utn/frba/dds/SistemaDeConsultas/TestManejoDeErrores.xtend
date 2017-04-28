package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.BajaDePois
import ar.edu.utn.frba.dds.SistemaDeConsultas.mocks.ServicioDeRestMock
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ErrorPorMail
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Administrador
import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ErrorReintentable
import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ErrorIgnorado
import java.time.LocalDate

class TestManejoDeErrores {
	// Variables 
	Poi starbucksLibertador
	Poi burguerKing
	Poi starbucksMaipu
	Poi carrousel
	Poi colectivoLinea71
	
	RepoPoi repositorio = RepoPoi.getInstance()
	PoiFactory poiFactory = new PoiFactory
	ServiceLocator serviceLocator = ServiceLocator.getInstance()
	RepoPerfilesUsuario repoUsuarios = RepoPerfilesUsuario.getInstance()
	//Servicio Externo de bajas de pois
	BajaDePois procesoBajaPois = new BajaDePois
	ServicioDeRestMock servicioRest = new ServicioDeRestMock
	
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
		procesoBajaPois.setearRepo(repositorio)
			
	}
	
	@Before
	def void agregarUsuariosARepo() {
		repoUsuarios.addUsuario(new Usuario("terminalAbasto"))
		repoUsuarios.addUsuario(new Usuario("terminalObelisco"))
		repoUsuarios.addUsuario(new Administrador("Carlos", "carlos@sysadmin.com"))
	}
	
	/* Comienzo de test de Manejo de errores */
	
	@Test
	/* Test de borrado */
	def void testElProcesoSeEjecutaCorrectamente(){
		//Armo el servicio externo
		servicioRest.serviciosValidos
		procesoBajaPois.seterarServicio(servicioRest)
		
		//Ejecuto el proceso
		Assert.assertEquals(5, repositorio.allInstances.size)
		procesoBajaPois.procesar
		Assert.assertEquals(4, repositorio.allInstances.size)
		
		//Manejo de errores
		Assert.assertEquals(serviceLocator.logResults.log.last, LocalDate.now().toString +
			" - Finalizo correctamente el proceso de tipo class ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.BajaDePois")

	}
	
	@Test
	/* Test de borrado */
	def void testElProcesoSeEjecutaConErrorSinRealizarAccion() {
		serviceLocator.servicioErrores = new ErrorIgnorado

		servicioRest.serviciosInvalidos
		procesoBajaPois.seterarServicio(servicioRest)

		// Ejecuto el proceso
		procesoBajaPois.procesar

		// Manejo de errores
		serviceLocator.getLogResults.loggearError(procesoBajaPois)

		Assert.assertEquals(serviceLocator.logResults.log.last, LocalDate.now().toString +
			" - Hubo error en la ejecucion del proceso de tipo class ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.BajaDePois")
	}
	
	@Test
	def void testElProcesoTieneErrorYManejoAvisando() {
		serviceLocator.servicioErrores = new ErrorPorMail
		
		servicioRest.serviciosInvalidos
		procesoBajaPois.seterarServicio(servicioRest)
		
		procesoBajaPois.procesar
		
		//1 admin, 1 mail que se manda
		Assert.assertEquals(1, serviceLocator.servicioEmail.mails)
	}
	
	@Test
	def void testProcesoConErrorYSeReintenta() {
		serviceLocator.servicioErrores = new ErrorReintentable(4)
		
		servicioRest.serviciosInvalidos
		procesoBajaPois.seterarServicio(servicioRest)
		
		procesoBajaPois.procesar
		
		Assert.assertEquals(4, procesoBajaPois.reintentos)
	}
	
	/* Fin de test de Manejo de errores */
	
	@After
	//Restablece el Repositorio
	def void restablecerSistema() {	
		repositorio.allInstances.clear
		repoUsuarios.vaciarUsuarios()
		serviceLocator.servicioEmail.vaciarMails()
	}
	
}