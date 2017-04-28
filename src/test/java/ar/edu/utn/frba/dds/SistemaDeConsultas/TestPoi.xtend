package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Exception.BusinessException
import org.joda.time.DateTime
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import org.junit.After
import java.util.Collection
import java.util.ArrayList
import org.json.simple.JSONArray
import ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters.BancoAdapter
import ar.edu.utn.frba.dds.SistemaDeConsultas.mocks.StubBuscadorSucursalBanco
import ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters.CGPAdapter
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Administrador
import ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda.Notificador
import ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda.AlmacenadorDeRegistros
import java.math.BigDecimal
import ar.edu.utn.frba.dds.SistemaDeConsultas.Reporteria.Reportador
import org.joda.time.format.DateTimeFormat

class TestPoi {
	// Variables 
	Poi starbucksLibertador
	Poi burguerKing
	Poi starbucksMaipu
	Poi carrousel
	Poi colectivoLinea71
	Poi bancoSantander
	Poi poiCGPComuna1
	Poi poiCGPComuna2
	Poi poiCGPComuna3
	Poi poiCGPComuna4
	Poi poiCGPComuna5
	RepoPoi repositorio = RepoPoi.getInstance()
	RepoPerfilesUsuario repoUsuarios = RepoPerfilesUsuario.getInstance()
	ServiceLocator serviceLocator = ServiceLocator.getInstance()
	AlmacenadorDeRegistros almacenRegistros = serviceLocator.servicioAlmacenador
	PoiFactory poiFactory = new PoiFactory

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
		
		starbucksMaipu =	poiFactory.parametrosBasicos("Starbucks", "Dir", -34.528961, -58.481043).
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
		
		//Bancos
		bancoSantander =	poiFactory.parametrosBasicos("Banco Santander", "Dir", -34.528961, -58.481043).
							parametrosBanco("Villa Luro", "Fabio Perez").
							crearBanco
		
		//CGPs
		poiCGPComuna1 = poiFactory.parametrosBasicos("CGPComuna1", "Dir", -34.599867, -58.386839).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP
		poiCGPComuna2 =	poiFactory.parametrosBasicos("CGPComuna2", "Dir", -34.596603, -58.398811).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		poiCGPComuna3 =	poiFactory.parametrosBasicos("CGPComuna3", "Dir", -34.603146, -58.396947).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		poiCGPComuna4 =	poiFactory.parametrosBasicos("CGPComuna4", "Dir", -34.650396, -58.424952).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		poiCGPComuna5 = poiFactory.parametrosBasicos("CGPComuna5", "Dir", -34.623073, -58.412468).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		
		repositorio.addObserverBusqueda(almacenRegistros)
		serviceLocator.servicioEmail.vaciarMails()
		almacenRegistros.vaciarRegistros()
	}

	@Before
	//Creacion del Repositorio
	def init() {
		//Agrego los adapters necesarios al repositorio
		repositorio.agregarAdapter(new BancoAdapter())
	 	repositorio.agregarAdapter(new CGPAdapter())
		//Ingreso las paradas de colectivo al repo
		repositorio.create(colectivoLinea71)
		//Ingreso los locales comerciales al repo
		repositorio.create(starbucksLibertador)
		repositorio.create(burguerKing)
		repositorio.create(starbucksMaipu)
		repositorio.create(carrousel)
	}
	
	@Before
	def void agregarUsuariosARepo() {
		repoUsuarios.addUsuario(new Usuario("terminalAbasto"))
		repoUsuarios.addUsuario(new Usuario("terminalObelisco"))
		repoUsuarios.addUsuario(new Administrador("Carlos", "carlos@sysadmin.com"))
	}

	@After
	//Restablece el Repositorio
	def void restablecerSistema() {	
		repositorio.allInstances.clear
		repositorio.removerAdapter(new BancoAdapter())
	 	repositorio.removerAdapter(new CGPAdapter())
	 	repoUsuarios.vaciarUsuarios()	
	 	serviceLocator.servicioEmail.vaciarMails()
		almacenRegistros.vaciarRegistros()	
		repositorio.vaciarObservers()
	}
	
	/* Comienzo de test de validaciones */

	@Test
	def void testValidateCreatePoiLocalComercialSinError(){
  		starbucksLibertador.validateCreate		
  	}
  	
  	@Test(expected=typeof(BusinessException))
	//Test de validacion con error de nombre 
	def void testValidateCreateConErrorEnElNombre() {
		starbucksLibertador.nombre = ""	
		starbucksLibertador.validateCreate
	}
	
	/* Fin de test de Validaciones */

	/* Comienzo de test de calculos de Cercania */
	
	@Test
	/* Test "seEncuentraAMenosDe" True */
	def void testSeEncuentraAMenosDeXmtsLocalComercal1DelLocalComercial2() {
		Assert.assertTrue(starbucksLibertador.seEncuentraAMenosDe(400.0, burguerKing.point))

	}

	@Test
	/* Test "seEncuentraAMenosDe" False */
	def void testNoSeEncuentraAMenosDeXmtsLocalComercal1DelLocalComercial2() {
		Assert.assertFalse(starbucksLibertador.seEncuentraAMenosDe(4000.0, starbucksMaipu.point))

	}

	@Test
	def void testConsultaDeCercaniaParadaDeColectivoTrue() {
		Assert.assertTrue(colectivoLinea71.consultaDeCercania(new Point(-34.515913, -58.488209)))
	}

	@Test
	def void testConsultaDeCercaniaParadaDeColectivoFalse() {
		Assert.assertFalse(colectivoLinea71.consultaDeCercania(starbucksLibertador.point))
	}

	@Test
	def void testConsultaDeCercaniaCGPFalse() {
		Assert.assertFalse(poiCGPComuna1.consultaDeCercania(colectivoLinea71.point))
	}

	@Test
	/* Test "consultaDeCercania" Poi1 True */
	def void testConsultaDeCercaniaLocalComercial1DelLocalComercial2True() {
		Assert.assertTrue(starbucksLibertador.consultaDeCercania(burguerKing.point))
	}

	@Test
	/* Test "consultaDeCercania" Poi ParadaDeColectivo False */
	def void testConsultaDeCercaniaParadaDeColectivoDeLocalComercial1False() {
		Assert.assertEquals(false, colectivoLinea71.consultaDeCercania(starbucksLibertador.point))
	}

	/* Comienzo de test de busqueda de puntos */
	@Test
	// Test filtrando por numero de linea
	def void testFiltrarParadaDeColectivoPorNroDeLinea() {
		var Collection<Poi> retornoEsperado = new ArrayList()
		retornoEsperado.add(colectivoLinea71)

		Assert.assertArrayEquals(retornoEsperado, repositorio.search("71", repoUsuarios.findByName("terminalAbasto")))
	}

	@Test
	// Test filtrando por Nombre en LocalComercia2
	def void testFiltrarLocalComercialPorNombre() {
		var Collection<Poi> retornoEsperado = new ArrayList()
		retornoEsperado.add(burguerKing)

		Assert.assertArrayEquals(retornoEsperado, repositorio.search("Burger", repoUsuarios.findByName("terminalAbasto")))

	}

	@Test
	// Test filtrando por Rubro en LocalComercial
	def void testFiltrarLocalComercialPorRubro() {
		var Collection<Poi> retornoEsperado = new ArrayList()
		retornoEsperado.add(burguerKing)

		Assert.assertArrayEquals(retornoEsperado, repositorio.search("Comidas", repoUsuarios.findByName("terminalAbasto")))

	}

	@Test
	// Test por nombre y cuando es mas de uno el resultado
	def void testFiltrarLocalComercialPorNombreYDevuelveMasDeUno() {
		var Collection<Poi> retornoEsperado = new ArrayList()
		retornoEsperado.add(starbucksLibertador)
		retornoEsperado.add(starbucksMaipu)

		Assert.assertArrayEquals(retornoEsperado, repositorio.search("Starbucks", repoUsuarios.findByName("terminalAbasto")))

	}

	@Test
	// Test por palabra clave, en este caso hamburguesas y devuelve el Burger King
	def testFiltrarPorPalabraClave() {
		var Collection<Poi> retornoEsperado = new ArrayList()
		burguerKing.addPalabraClave("hamburguesa")
		burguerKing.addPalabraClave("churrasco")
		retornoEsperado.add(burguerKing)

		Assert.assertArrayEquals(retornoEsperado, repositorio.search("hamburguesa", repoUsuarios.findByName("terminalAbasto")))
	}

	/* Comienzo de test de calculos de disponibilidad */
	@Test
	/* Test "consultaDeDisponibilidad" Poi ParadaDeColectivo True */
	def void testDisponibilidadParadaDeColectivoTrue() {
		val testFecha = new DateTime(2016, 1, 15, 12, 0)
		Assert.assertTrue(colectivoLinea71.consultaDeDisponibilidad(testFecha, ""))
	}

	@Test
	/* Test "consultaDeDisponibilidad" Poi CGP True */
	def void testDisponibilidadCGPIngresandoUnServicioTrue() {
		val testFecha = new DateTime(2016, 1, 18, 14, 0)
		Assert.assertTrue(poiCGPComuna5.consultaDeDisponibilidad(testFecha, "Rentas"))
	}

	@Test
	/* Test "consultaDeDisponibilidad" Poi CGP True */
	def void testDisponibilidadCGPSinIngresarUnServicioTrue() {
		val testFecha = new DateTime(2016, 1, 18, 14, 0)
		Assert.assertTrue(poiCGPComuna5.consultaDeDisponibilidad(testFecha, ""))
	}

	@Test
	/* Test "consultaDeDisponibilidad" Poi CGP False */
	def void testDisponibilidadCGPIngresandoUnServicioFalse() {
		val testFecha = new DateTime(2016, 1, 17, 20, 0)
		Assert.assertFalse(poiCGPComuna5.consultaDeDisponibilidad(testFecha, "Rentas"))
	}

	@Test
	/* Test "consultaDeDisponibilidad" Poi Banco True */
	def void testDisponibilidadBancoTrue() {
		val testFecha = new DateTime(2016, 1, 12, 12, 0)
		Assert.assertEquals(2, testFecha.getDayOfWeek)
		Assert.assertTrue(bancoSantander.consultaDeDisponibilidad(testFecha, "bancario"))

	}

	@Test
	/* Test "consultaDeDisponibilidad" Poi Banco False */
	def void testDisponibilidadBancoFalse() {
		val testFecha = new DateTime(2016, 1, 16, 12, 0)
		Assert.assertFalse(bancoSantander.consultaDeDisponibilidad(testFecha, "bancario"))
		Assert.assertEquals(6, testFecha.getDayOfWeek)
	}

	@Test
	/* Test "consultaDeDisponibilidad" Poi LocalComercial True */
	def void testDisponibilidadLocalComercialTrue() {
		val testFecha = new DateTime(2016, 1, 18, 12, 0)
		Assert.assertTrue(starbucksLibertador.consultaDeDisponibilidad(testFecha, "Cafeteria"))
	}

	@Test
	/* Test "consultaDeDisponibilidad" Poi LocalComercial False */
	def void testDisponibilidadLocalComercialFalse() {
		val testFecha = new DateTime(2016, 1, 18, 23, 0)
		Assert.assertFalse(starbucksLibertador.consultaDeDisponibilidad(testFecha, "Cafeteria"))
	}

	/* Fin de test de calculos de Disponibilidad */
	/* Comienzo de test de Repositorio */
	@Test
	/* Test de creacion de un Poi */
	def void testDeCreacionDeUnPoiValidoEnElRepo() {
		repositorio.create(new Banco("Banco Patagonia", "Direccion 1", -34.469248, -58.510460, "San Isidro", "Javier Patru"))
	}

	@Test(expected=typeof(BusinessException))
	/* Test de creacion de un Poi invalido por nombre*/
	def void testDeCreacionDeUnPoiInvalidoPorElNombreEnElRepo() {
		repositorio.create(new Banco("", "Direccion invalida", -34.469248, -58.510460, "San Isidro", "Javier Patru"))
	}

	/* Fin de test de Repositorio */
	@Test
	def testDeSizeDelRepoPoi() {
		Assert.assertEquals(5, repositorio.allInstances.size)
	}

	@Test
	def testPalabraClaveEliminada() {
		starbucksLibertador.removePalabraClave("Cafe")
		Assert.assertFalse(starbucksLibertador.palabrasClave.contains("Cafe"))

	}

	/* Comienzo de test de busquedas en servicios externos */
	@Test
	def testBusquedaBancosServicioExternoDevuelveUnoSolo() {
		Assert.assertEquals(1, repositorio.search("Banco Rio", repoUsuarios.findByName("terminalAbasto")).size)
	}

	@Test
	def testBusquedaBancosServicioExternoDevuelveLosDos() {
		Assert.assertEquals(2, repositorio.search("Banco", repoUsuarios.findByName("terminalAbasto")).size)
	}

	@Test
	def void testAdaptarListaDeBancosJsonRemotosDadaPorLaClaseImpostoraAListaDeBancosLocal() {
		val StubBuscadorSucursalBanco stubBuscadorSucursalBanco = new StubBuscadorSucursalBanco()
		var JSONArray listaBancosJsonRemotos = stubBuscadorSucursalBanco.buscar("Banco")
		val bancoAdapter = new BancoAdapter()
		val Collection<Banco> listaBancosJsonRemotaAdaptada = bancoAdapter.convertirDeJson(listaBancosJsonRemotos)

		Assert.assertEquals(listaBancosJsonRemotaAdaptada.size, 2)
	}

	@Test
	def void testBuscarCGPsRemotosUsandoBuscadorCPGsRemotosQueDevuelvaCGPPorBarrio() {

		var CGPAdapter cgpAdapter = new CGPAdapter()
		
		val Collection<Poi> resultadoBusquedaRemota = cgpAdapter.buscar("Almagro")

		Assert.assertEquals(1, resultadoBusquedaRemota.size)
	}

/*Fin de test de busquedas en servicios externos */

	@Test
	def void testRemoverAdapterDeRepo() {
		RepoPoi.getInstance().removerAdapter(new BancoAdapter())
		Assert.assertEquals(1, RepoPoi.getInstance().cantidadAdapters())
	}
	
	//Tests de 3ra entrega
	
	@Test
	def void testNoAgregaUsuarioVacio() {
		repoUsuarios.addUsuario(new Usuario())
		
		Assert.assertEquals(3, repoUsuarios.cantidadUsuarios())
	}
	
	@Test
	def void testNoAgregaUsuarioRepetido() {
		repoUsuarios.addUsuario(new Usuario("terminalAbasto"))
		
		Assert.assertEquals(3, repoUsuarios.cantidadUsuarios())
	}
	
	@Test
	def void testBorrarUsuarioExistente() {
		repoUsuarios.removeUsuarioByName("terminalObelisco")
		
		Assert.assertEquals(2, repoUsuarios.cantidadUsuarios())
	}
	
	@Test(expected=typeof(BusinessException))
	def void testBorrarUsuarioInexistente() {
		repoUsuarios.removeUsuarioByName("terminalUTN")
	}
	
	@Test
	def void testActualizarUsuarioExistente() {
		Assert.assertTrue(repoUsuarios.findByName("terminalAbasto").debeNotificar)
		
		val terminalAbastoSinNotificacion = new Usuario("terminalAbasto")
		terminalAbastoSinNotificacion.toggleNotificar()
		repoUsuarios.updateUsuario(terminalAbastoSinNotificacion)
		
		Assert.assertFalse(repoUsuarios.findByName("terminalAbasto").debeNotificar)
	}
	
	@Test
	def void testFiltradoDeTerminalesYNoAdministradores() {
		Assert.assertEquals(2, repoUsuarios.listaTerminales.size)
	}
	
	@Test
	def void testMandarEmail() {
		serviceLocator.servicioEmail.enviarMail("Un mail", "a@a.com", "b@b.com", "Esto es un mail.")
		Assert.assertEquals(1, serviceLocator.servicioEmail.mails)
	}
	
	@Test
	def void testBusquedaDemoraMenosDeTiempoParaNotificar() {
		repositorio.addObserverBusqueda(new Notificador(3))
		repositorio.search("71", repoUsuarios.findByName("terminalAbasto"))
		
		Assert.assertEquals(0, serviceLocator.servicioEmail.mails)
	}
	
	@Test
	def void testBusquedaDemoraMasDeTiempoParaNotificarYEstaActivado() {
		repositorio.addObserverBusqueda(new Notificador(0))
		repositorio.search("Burger", new Usuario("terminalAbasto"))
		
		Assert.assertEquals(0, serviceLocator.servicioEmail.mails)
	}
	
	@Test
	def void testBusquedaDemoraMasDeTiempoParaNotificarYEstaDesactivado() {
		repositorio.addObserverBusqueda(new Notificador(1))
		repoUsuarios.findByName("terminalObelisco").toggleNotificar()
		repositorio.search("Burger", repoUsuarios.findByName("terminalObelisco"))
		
		Assert.assertEquals(0, serviceLocator.servicioEmail.mails)
	}
	
	@Test
	def void testAgregarRegistro() {
		almacenRegistros.observarBusqueda(new BusquedaRealizada("Burger", repoUsuarios.findByName("terminalObelisco"), new Double(2), new BigDecimal(10)))
		Assert.assertEquals(1, almacenRegistros.registros.size)
	}
	
	@Test
	def void testRegistraBusquedaEstandoActivado() {
		repositorio.search("71", repoUsuarios.findByName("terminalAbasto"))
		
		Assert.assertEquals(1, almacenRegistros.registros.size)
	}
	
	@Test
	def void testNoRegistraBusquedaEstandoDesactivado() {
		repoUsuarios.findByName("terminalAbasto").toggleRegistrar()
		repositorio.search("Burger", repoUsuarios.findByName("terminalAbasto"))
		
		Assert.assertEquals(0, almacenRegistros.registros.size)
	}
	
	@Test
	def void testReportePorFecha() {
		repositorio.search("Starbucks", repoUsuarios.findByName("terminalAbasto"))
		repositorio.search("Starbucks", repoUsuarios.findByName("terminalObelisco"))
		
		val reportePorFecha = new Reportador().reportarCantidadDeBusquedasPorFecha()
		val formateadorDeFechasddMMYY = DateTimeFormat.forPattern("dd-MM-yyyy")
		
		Assert.assertEquals(new BigDecimal(2), reportePorFecha.get(formateadorDeFechasddMMYY.print(DateTime.now()))) 
		
	}
	
	@Test
	def void testReportePorBusqueda() {
		val reportador = new Reportador()
		
		repositorio.search("Banco", repoUsuarios.findByName("terminalObelisco"))
		repositorio.search("Starbucks", repoUsuarios.findByName("terminalObelisco"))
		repositorio.search("Banco", repoUsuarios.findByName("terminalAbasto"))
		repositorio.search("Banco", repoUsuarios.findByName("terminalObelisco"))
		
		val reportePorBusqueda = reportador.reportarCantidadDeBusquedasPorTerminal("Banco")
		
		Assert.assertEquals(2, reportePorBusqueda.get(repoUsuarios.findByName("terminalObelisco")))
		Assert.assertEquals(1, reportePorBusqueda.get(repoUsuarios.findByName("terminalAbasto")))
	}
	
	@Test
	def void testReportePorTerminal() {
		val reportador = new Reportador()
		
		repositorio.search("Starbucks", repoUsuarios.findByName("terminalAbasto"))
		repositorio.search("Banco Santander", repoUsuarios.findByName("terminalAbasto"))
		repositorio.search("Banco Santander", repoUsuarios.findByName("terminalAbasto"))
		repositorio.search("Banco Santander", repoUsuarios.findByName("terminalAbasto"))
		
		val reportePorTerminal = reportador.reportarBusquedasDeTerminalPorFrase(repoUsuarios.findByName("terminalAbasto"))
		
		Assert.assertEquals(1, reportePorTerminal.get("Starbucks"))
		Assert.assertEquals(3, reportePorTerminal.get("Banco Santander"))
	}

}
