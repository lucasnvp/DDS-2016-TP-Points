
package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda.AlmacenadorDeRegistros
import org.junit.Before
import ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters.BancoAdapter
import ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters.CGPAdapter
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Administrador
import org.junit.After
import org.junit.Test
import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.ActualizadorDeLocalesComerciales
import org.junit.Assert
import java.io.FileNotFoundException
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator
import java.util.ArrayList
import java.io.FileReader
import static extension com.google.common.io.CharStreams.*
import java.nio.file.Paths

//@formatter:off
class TestsDeProcesoDeActualizacionDeLocalesComerciales {

	Poi casaDeRopaReverpass
	Poi casaDeRopaCarrousel
	Poi starbucksLibertador
	Poi bancoSantander
	Poi poiCGPComuna1
	Poi colectivoLinea71
	Poi burguerKing

	RepoPoi repoDePoIs = RepoPoi.getInstance()
	RepoPerfilesUsuario repoUsuarios = RepoPerfilesUsuario.getInstance()
	ServiceLocator serviceLocator = ServiceLocator.getInstance()
	AlmacenadorDeRegistros almacenRegistros = serviceLocator.servicioAlmacenador
	PoiFactory poiFactory = new PoiFactory
	String directorioDeArchivosDeActualizacionDeLocalesComercialesTest 
	 
		


	@Before
	// Creacion de pois
	def void setUp() {
		// Locales Comerciales
		casaDeRopaReverpass = poiFactory.parametrosBasicos("ReverPass", "Dir", -34.483346, -58.489661).
			parametrosLocalComercial(500.0, "Ropa").addWordsKey("pantalones").addWordsKey("remeras").addWordsKey("camisas").disponibilidad(7, 9, 0, 21, 0).
			crearLocalComercial
			
		casaDeRopaCarrousel = poiFactory.parametrosBasicos("Carrousel", "Dir", -34.480581, -58.492341).
			parametrosLocalComercial(500.0, "Ropa").addWordsKey("colegio").addWordsKey("escolar").addWordsKey("corbatas").addWordsKey("jumpers").addWordsKey(
				"uniformes").addWordsKey("modas").disponibilidad(7, 8, 0, 23, 0).crearLocalComercial

		starbucksLibertador = poiFactory.parametrosBasicos("Starbucks", "Dir", -34.483346, -58.489661).
			parametrosLocalComercial(500.0, "Cafeteria").addWordsKey("Cafe").addWordsKey("muffins").disponibilidadTodosLosDiasDe8a23().
			crearLocalComercial
				
		bancoSantander = poiFactory.parametrosBasicos("Banco Santander", "Dir", -34.528961, -58.481043).
			parametrosBanco("Villa Luro", "Fabio Perez").crearBanco

		poiCGPComuna1 = poiFactory.parametrosBasicos("CGPComuna1", "Dir", -34.599867, -58.386839).addServicio("Rentas",
			5, 10, 0, 18, 0).crearCGP

		colectivoLinea71 = poiFactory.parametrosBasicos("Parada 1", "Dir", -34.515246, -58.488491).
			parametrosParadaDeColectivo("71").crearParadaDeColecnivo

		burguerKing = poiFactory.parametrosBasicos("Burger King", "Dir", -34.480581, -58.492341).
			parametrosLocalComercial(500.0, "Comidas Rapidas").addWordsKey("hamburguesa").addWordsKey("churrascos").addWordsKey("papas").addWordsKey("stacker").disponibilidad(7, 8, 0, 23, 0).crearLocalComercial

		repoDePoIs.addObserverBusqueda(almacenRegistros)
		serviceLocator.servicioEmail.vaciarMails()
		almacenRegistros.vaciarRegistros()
		directorioDeArchivosDeActualizacionDeLocalesComercialesTest = serviceLocator.getDirectorioDeArchivosDeActualizacionDeLocalesComerciales
		}
		
		


	@Before
	
	
	// Creacion del Repositorio
	def init() {
		// Agrego los adapters necesarios al repositorio
		repoDePoIs.agregarAdapter(new BancoAdapter())
		repoDePoIs.agregarAdapter(new CGPAdapter())
		repoDePoIs.create(casaDeRopaReverpass)
		repoDePoIs.create(casaDeRopaCarrousel)
		repoDePoIs.create(starbucksLibertador)
		repoDePoIs.create(bancoSantander)
		repoDePoIs.create(poiCGPComuna1)
		repoDePoIs.create(colectivoLinea71)
		repoDePoIs.create(burguerKing)
	}

	@Before
	def void agregarUsuariosARepo() {
		repoUsuarios.addUsuario(new Usuario("terminalAbasto"))
		repoUsuarios.addUsuario(new Usuario("terminalObelisco"))
		repoUsuarios.addUsuario(new Administrador("Carlos", "carlos@sysadmin.com"))
	}

	@After
	// Restablece el Repositorio
	def void restablecerSistema() {
		repoDePoIs.allInstances.clear
		repoDePoIs.removerAdapter(new BancoAdapter())
		repoDePoIs.removerAdapter(new CGPAdapter())
		repoUsuarios.vaciarUsuarios()
		serviceLocator.servicioEmail.vaciarMails()
		almacenRegistros.vaciarRegistros()
		repoDePoIs.vaciarObservers()
	}

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
* 	Crear un directorio, y copiar los arhvivos de actualizaciones                                                          
*     que se encuentran en al ruta debajo allí, permisos de lectura. Modificar la ruta en Service Locator, más tarde en SC.conf 				                                	 
*     2016-mn-group-10/src/test/java/ar/edu/utn/frba/dds/SistemaDeConsultas/ArchivosDeActualizacionDeLocalesComerciales_tests/ 
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



	@Test
	def void testAperturaDeArchivoDeActualizacionesQueNoSeaNullElFileReaderConRuta3() {
		val fr = serviceLocator.obtenerFileReaderDeRutaAArchivo(
			directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
				'ArActLocCom.txt')
				Assert.assertTrue(fr != null)			
		}

	@Test(expected=typeof(FileNotFoundException))
	def void testAperturaDeArchivoDeActualizacionesConRutaInexistente() {
			val fr = serviceLocator.obtenerFileReaderDeRutaAArchivo(
				directorioDeArchivosDeActualizacionDeLocalesComercialesTest + 'NoExisto.txt')

	}

	@Test(expected=typeof(FileNotFoundException))
	def void testAperturaDeArchivoDeActualizacionesConRutaADirectorio() {

			val fr = serviceLocator.obtenerFileReaderDeRutaAArchivo(
				directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
					'ArchivosDeActualizacionDeLocalesComerciales_tests/')
	}

	@Test
	def void testPruebaDeAperturaDeArchivoDeActualizacionesDefaultQueNoSeaNullElFileReader() {
		val fr = ServiceLocator.getInstance.obtenerFileReaderDeRutaAArchivo(
			ServiceLocator.getInstance.getRutaAlArchivoDeAcutalizacionDeLocalesComerciales)
		Assert.assertTrue(fr != null)
	}

////////////////////////////////////////////////////////////////////////////////////////
/* Este RegEx acepta nombres de fantasía con guiones bajos, guiones medios y apóstrofos */
/*                                  Pruebas de Regex                                    */
////////////////////////////////////////////////////////////////////////////////////////

	@Test
	def void testRegExLineaFormatoCorrectoIdeal() {
		val chain = "Pepe;colegio escolar uniformes modas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoCorrectoIdealConGuiones() {
		val chain = "P--e-p-e;colegio escolar uniformes modas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoCorrectoIdealConComas() {
		val chain = "Pe,pe,;colegio escolar uniformes modas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoCorrectoIdealConGuionesYComas() {
		val chain = "Pe,pe-,;colegio escolar uniformes modas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoCorrectoEspaciosAntesDeNombreDeFantasia() {
		val chain = "   Pepe; colegio escolar uniformes modas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoCorrectoEspaciosEntreLasPalabrasClaves() {
		val chain = "Pepe; colegio     escolar uniformes    modas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoCorrectoEspaciosAntesDeNombreDeFantasiaYEntreLasPalabrasClaves() {
		val chain = "   Pepe; colegio    escolar uniformes	 modas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoIncorrectoConDosPuntosYComas() {
		val chain = "Pepe; colegio    ; escolar uniformes    modas"
		Assert.assertFalse(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoIncorrectoComienzaConPuntoYComa() {
		val chain = ";colegio escolar uniformes modas"
		Assert.assertFalse(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoIncorrectoComienzaConEspaciosAntesDePuntoYComa() {
		val chain = "   ;colegio escolar uniformes modas"
		Assert.assertFalse(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoIncorrectoSinPalabrasClavesSinEspacios() {
		val chain = "Carrousel;"
		Assert.assertFalse(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoIncorrectoSinPalabrasClavesConEspacios() {
		val chain = "Carrousel;      "
		Assert.assertFalse(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testRegExLineaFormatoIncorrectoSinPalabrasClavesConEspaciosw() {
		val chain = "   Pe,pe-,	;colegio escolar uniformes fiestas"
		Assert.assertTrue(chain.matches("^\\s*[\\w-,']+\\s*;\\s*\\w+(\\s+\\w+)*\\s*$"))
	}

	@Test
	def void testArchivoActualizacionDesdeDeActualizacionDeLocalesComerciales1EntradaFormatoCorrectoDevuleve1Lineas() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(serviceLocator.getRutaAlArchivoDeAcutalizacionDeLocalesComerciales)
		Assert.assertEquals(actualizaciones.size,
			1)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaCorrectaNombreFantasiaConGuiones() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1OKNFantGuiones.txt')
		Assert.assertTrue(actualizaciones.get(0).equals("P--e-p-e;colegio escolar uniformes modas"))
		Assert.assertEquals(actualizaciones.size,
			1)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaCorrectaNombreFantasiaConComas() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1OKNFantComas.txt')
		Assert.assertTrue(actualizaciones.get(0).equals("Pe,pe,;colegio escolar uniformes modas"))
		Assert.assertEquals(1,
			actualizaciones.
				size)
			}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaCorrectaNombreFantasiaConGuionesYComas() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1OKNFantGuionesYComas.txt')
		Assert.assertTrue(actualizaciones.get(0).equals("Pe,pe-,;colegio escolar uniformes modas"))
		Assert.assertEquals(actualizaciones.size,
			1)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaCorrectaEspaciosAntesDeNombreDeFantasia() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1OKEspaciosPreNFantasia.txt')
		Assert.assertTrue(actualizaciones.get(0).equals("   Pepe; colegio escolar uniformes modas"))
		Assert.assertEquals(actualizaciones.size,
			1)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaCorrectaEspaciosEntreLasPalabrasClaves() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1OKEspaciosEntrekeys.txt')
		Assert.assertTrue(actualizaciones.get(0).equals("Pepe; colegio     escolar uniformes    modas"))
		Assert.assertEquals(actualizaciones.size,
			1)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaCorrectaEspaciosAntesDeNombreDeFantasiaYEntreLasPalabrasClaves() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1OKEspaciosPreNFantYEntrekeys.txt')
		Assert.assertTrue(actualizaciones.get(0).equals("   Pepe; colegio    escolar uniformes	 modas"))
		Assert.assertEquals(actualizaciones.size,
			1)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaIncorrectaConDosPuntoYComa() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1NoOKDosPuntoYComa.txt')
		Assert.assertEquals(actualizaciones.size,
			0)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaIncorrectaEmpiezaConPuntoYComa() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1NoOKEmpiezaPuntoYComa.txt')
		Assert.assertEquals(actualizaciones.size,
			0)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaIncorrectaComienzaSoloConEspaciosAntesDePuntoYComa() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1NoOKEspaciosPreDePuntoYComa.txt')
		Assert.assertEquals(actualizaciones.size,
			0)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaIncorrectaSinPalabrasClavesSinEspacios() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1NoOKSinKeysSinEspacios.txt')
		Assert.assertEquals(actualizaciones.size, 0)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComerciales1EntradaIncorrectaSinPalabrasClavesConEspacios() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocCom1NoOKSinkeysConEspacios.txt')
		Assert.assertEquals(actualizaciones.size, 0)
	}

	@Test
	def void testRecuperar1LíneaSinProcesarDeArchivoDeActualizacionDeLocalesComercialesTodosLosCasosAnteriores() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocComTodosCasosAnteriores.txt')
		Assert.assertEquals(actualizaciones.size, 7)
	}

//	////////////////////////////////////////////////////////////////////////////////////////
//	/* Pruebas de las armado de estructura de actualizaciones HM                             */
//	// ////////////////////////////////////////////////////////////////////////////////////////
	@Test
	def void testSepararLineaPorPuntoYComa() {
		val chain = "	Pe,pe-,  ;   		 colegio escolar    uniformes modas   "
		val nombreFantasia = (chain.split(';').get(0) as String).replaceAll('\\s', '')
		val cadenasSeparadasPorEspacio = chain.split(';').get(1).split('[\\s]')
		val palabrasClave = new ArrayList<String>
		cadenasSeparadasPorEspacio.forEach [ cada1 |
			if (!cada1.matches('')) {
				palabrasClave.add(cada1)
			}
		]
		Assert.assertEquals(4, palabrasClave.size)
		Assert.assertTrue(nombreFantasia.equals("Pe,pe-,"))
		Assert.assertTrue(palabrasClave.get(0).equals("colegio"))
		Assert.assertTrue(palabrasClave.get(1).equals("escolar"))
		Assert.assertTrue(palabrasClave.get(2).equals("uniformes"))
		Assert.assertTrue(palabrasClave.get(3).equals("modas"))
	}

	@Test
	def void testCrearEstructuraHMDeActualizacionesConArrayListDeLineas1() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocComTodosCasosAnteriores.txt')
		val estructuraDeactualizaciones = ac.crearEstructuraHMDeActualizacionesConArrayListDeLineas(actualizaciones)
		Assert.assertEquals(estructuraDeactualizaciones.get("Pepe").size, 4)
		Assert.assertTrue(estructuraDeactualizaciones.get("Pepe").get(0).equals("colegio"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pepe").get(1).equals("escolar"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pepe").get(2).equals("uniformes"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pepe").get(3).equals("modas"))
	}

	@Test
	def void testCrearEstructuraHMDeActualizacionesConArrayListDeLineas2() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocComTodosCasosAnteriores.txt')
		val estructuraDeactualizaciones = ac.crearEstructuraHMDeActualizacionesConArrayListDeLineas(actualizaciones)
		Assert.assertEquals(estructuraDeactualizaciones.get("Pe,pe,").size, 4)
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe,").get(0).equals("colegio"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe,").get(1).equals("escolar"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe,").get(2).equals("uniformes"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe,").get(3).equals("modas"))
	}

	@Test
	def void testCrearEstructuraHMDeActualizacionesConArrayListDeLineas3() {
		val ac = new ActualizadorDeLocalesComerciales
		val actualizaciones = ac.solicitarLineasDeActualizaciones(directorioDeArchivosDeActualizacionDeLocalesComercialesTest +
			'ArActLocComTodosCasosAnteriores.txt')
		val estructuraDeactualizaciones = ac.crearEstructuraHMDeActualizacionesConArrayListDeLineas(actualizaciones)
		Assert.assertEquals(estructuraDeactualizaciones.get("Pe,pe-,").size, 4)
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe-,").get(0).equals("colegio"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe-,").get(1).equals("escolar"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe-,").get(2).equals("uniformes"))
		Assert.assertTrue(estructuraDeactualizaciones.get("Pe,pe-,").get(3).equals("modas"))
	}
	
	@Test
	def void testContarCantidadDeLocalesComercialesEnRepoDePoIs() {
		val cantidad = repoDePoIs.allInstances.filter[cadaPoI|cadaPoI.class.equals(LocalComercial)].size
		Assert.assertEquals(cantidad, 4)
	}
		
	@Test
	def void testActualizar1LocalComercialExistenteEnRepoDePoIsLocal(){
		val ac = new ActualizadorDeLocalesComerciales
		ac.procesar()
		Assert.assertEquals(repoDePoIs.allInstances.size,7)
		Assert.assertEquals(repoDePoIs.buscarLocal("Carrousel").size,1)	
		Assert.assertEquals(repoDePoIs.buscarLocal("Carrousel").get(0).palabrasClave.size,1)
		Assert.assertEquals(repoDePoIs.buscarLocal("Carrousel").get(0).palabrasClave.get(0), "circo")
		Assert.assertEquals(repoDePoIs.buscarLocal("ReverPass").size,1)
		Assert.assertEquals(repoDePoIs.buscarLocal("ReverPass").get(0).palabrasClave.size,3)
		Assert.assertTrue(repoDePoIs.buscarLocal("ReverPass").get(0).palabrasClave.contains("pantalones"))
		Assert.assertTrue(repoDePoIs.buscarLocal("ReverPass").get(0).palabrasClave.contains("remeras"))
		Assert.assertTrue(repoDePoIs.buscarLocal("ReverPass").get(0).palabrasClave.contains("camisas"))
		Assert.assertTrue(repoDePoIs.buscarLocal("Starbucks").get(0).palabrasClave.contains("Cafe"))
		Assert.assertTrue(repoDePoIs.buscarLocal("Starbucks").get(0).palabrasClave.contains("muffins"))
	}	
	
}