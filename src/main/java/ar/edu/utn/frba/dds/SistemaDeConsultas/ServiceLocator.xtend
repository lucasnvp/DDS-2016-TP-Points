package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Reporteria.Reportador
import ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda.AlmacenadorDeRegistros
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import java.io.FileReader
import java.util.ArrayList
import static extension com.google.common.io.CharStreams.*
import java.util.HashMap
import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ManejadorDeErrores
import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ErrorIgnorado
import java.nio.file.Paths
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Administrador
import ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos.Proceso
//import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ErrorLog
import ar.edu.utn.frba.dds.SistemaDeConsultas.ManejoErrores.ResultsLog
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServidorDeCorreosPosta

class ServiceLocator {
	static ServiceLocator instance
	ServidorDeCorreosPosta servicioEmail
	AlmacenadorDeRegistros servicioAlmacenador
	Reportador servicioReportador
	ManejadorDeErrores servicioErrores
	//ErrorLog logErrores
	ResultsLog logResults
	String elNombreDelArvhivoDeConfiguracion
	HashMap<String,String> hmConfiguracionesDelSistemaDeConsultas = new HashMap<String,String>
	HashMap<String,String> subdirectorioDeArchivosDeConfiguracion = new HashMap<String,String>
	HashMap<String,String> subdirDefaultDeArchivosDeActualizacionDeLocalesComerciales = new HashMap<String,String>
	String sistemaOperativoResidente 
	String directorioActual
		
	
	static def getInstance() { 
		if (instance == null) {
			instance = new ServiceLocator
			instance.instanciarServicios()
			instance.inicializarEstructurasDeConfiguracion()
		}
		return instance
	}

	def getServicioEmail() {
		servicioEmail
	}

	def getServicioReportador() {
		servicioReportador
	}

	def getServicioAlmacenador() {
		servicioAlmacenador
	}
	
	def getServicioErrores() {
		servicioErrores
	}
	
	def setServicioErrores(ManejadorDeErrores nuevoServicioErrores) {
		servicioErrores = nuevoServicioErrores
	}
	
	def getLogResults() {
		logResults
	}

	def instanciarServicios() {
		servicioEmail = new ServidorDeCorreosPosta()
		servicioAlmacenador = new AlmacenadorDeRegistros()
		servicioReportador = new Reportador()
		servicioErrores = new ErrorIgnorado() //por default ignora?
		logResults = new ResultsLog()
	}
	
	def inicializarEstructurasDeConfiguracion(){
		elNombreDelArvhivoDeConfiguracion = "SistemaDeConsultas.conf"
		sistemaOperativoResidente = System.getProperty("os.name").toLowerCase.split(' ').get(0)
		directorioActual = Paths.get(".").toAbsolutePath().normalize().toString()
		
		subdirectorioDeArchivosDeConfiguracion.put("linux", "/ArchivosDeConifguracion/")
		subdirectorioDeArchivosDeConfiguracion.put("mac", "/ArchivosDeConifguracion/")
		subdirectorioDeArchivosDeConfiguracion.put("windows", "\\ArchivosDeConifguracion\\")
		
		
		subdirDefaultDeArchivosDeActualizacionDeLocalesComerciales.put("linux",
			"/src/test/java/ar/edu/utn/frba/dds/SistemaDeConsultas/ArchivosDeActualizacionDeLocalesComerciales_tests/")
			
		subdirDefaultDeArchivosDeActualizacionDeLocalesComerciales.put("mac",
			"/src/test/java/ar/edu/utn/frba/dds/SistemaDeConsultas/ArchivosDeActualizacionDeLocalesComerciales_tests/")
			
		subdirDefaultDeArchivosDeActualizacionDeLocalesComerciales.put("windows",
			"\\src\\test\\java\\ar\\edu\\utn\\frba\\dds\\SistemaDeConsultas\\ArchivosDeActualizacionDeLocalesComerciales_tests\\")
			
			
		hmConfiguracionesDelSistemaDeConsultas.put("directorioDeArchivosDeActualizacionDeLocalesComerciales",
			directorioActual +
				subdirDefaultDeArchivosDeActualizacionDeLocalesComerciales.get(
					sistemaOperativoResidente))
					
		hmConfiguracionesDelSistemaDeConsultas.put("nombreDelArchivoDeActualizacionesDeLocalesComerciales","ArActLocComTestsIntegradores.txt")
	}
	

	def notificarAdministradoresDeTardanza(BusquedaRealizada unaBusqueda) {
		RepoPerfilesUsuario.getInstance.listaTerminales.forEach[usuario|usuario.notificarTardanza(unaBusqueda)]
	}
	
	def notificarAdministradoresDeError(Proceso p) {
		RepoPerfilesUsuario.getInstance.listaAdministradores.forEach[admin | 
			servicioEmail.enviarMail("Error en proceso", "sistema@pois.com", (admin as Administrador).email, "Hubo error en el proceso " + p.class.toString)
		]
	}

	def FileReader obtenerFileReaderDeRutaAArchivo(String unaRuta) {
		new FileReader(unaRuta)
	}

	def String getDirectorioDeArchivosDeConfiguracionDelSistemaDeConsultas() {
		directorioActual + subdirectorioDeArchivosDeConfiguracion.get(sistemaOperativoResidente)
	}
	
	def String getRutAlArchivoDeConfiguracionDelSistemaDeConsultas() {
			this.getDirectorioDeArchivosDeConfiguracionDelSistemaDeConsultas+ this.elNombreDelArvhivoDeConfiguracion
	}
	
	def void cargarConfniguracionDelSistemaDesdeArchivo() {

		val frac = obtenerFileReaderDeRutaAArchivo(this.getDirectorioDeArchivosDeConfiguracionDelSistemaDeConsultas +
			elNombreDelArvhivoDeConfiguracion)
		val lineasDeArchivoDeConfiguracion = frac.readLines as ArrayList<String> 
		lineasDeArchivoDeConfiguracion.forEach [ cadaLinea |
			val itemDeConifguracion = (cadaLinea.split('=').get(0) as String).replaceAll('\\s', '')
			val contenidoDeConfiguracion = cadaLinea.split('=').get(1)
			hmConfiguracionesDelSistemaDeConsultas.put(itemDeConifguracion, contenidoDeConfiguracion)
		]
	}
	
	def HashMap<String,String> gethmConfiguracionesDelSistemaDeConsultas() {
		hmConfiguracionesDelSistemaDeConsultas
	}
	
	def HashMap<String,String> getSubdirectorioDeArchivosDeConfiguracion() {
		subdirectorioDeArchivosDeConfiguracion
	}

	def String getDirectorioDeArchivosDeActualizacionDeLocalesComerciales() {
		hmConfiguracionesDelSistemaDeConsultas.get("directorioDeArchivosDeActualizacionDeLocalesComerciales")
	}
	
	def String getNombreDelArchivoDeAcutalizacionDeLocalesComerciales() {
		hmConfiguracionesDelSistemaDeConsultas.get("nombreDelArchivoDeActualizacionesDeLocalesComerciales")
	}
	
	def String getRutaAlArchivoDeAcutalizacionDeLocalesComerciales() {
		getDirectorioDeArchivosDeActualizacionDeLocalesComerciales + getNombreDelArchivoDeAcutalizacionDeLocalesComerciales
	}
	
}
