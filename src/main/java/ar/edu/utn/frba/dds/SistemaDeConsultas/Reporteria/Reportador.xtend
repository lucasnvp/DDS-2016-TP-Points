package ar.edu.utn.frba.dds.SistemaDeConsultas.Reporteria

import java.util.HashMap
import org.joda.time.format.DateTimeFormat
import java.math.BigDecimal
import ar.edu.utn.frba.dds.SistemaDeConsultas.BusquedaRealizada
import java.util.ArrayList
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.IterableToArray
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator

class Reportador {


	val formateadorDeFechasddMMYY = DateTimeFormat.forPattern("dd-MM-yyyy")

	def HashMap<String, BigDecimal> reportarCantidadDeBusquedasPorFecha() { // ISO Format
	// TODO: valicación de Fechas
		val reporteCantidadDeBusquedasPorFecha = new HashMap<String, BigDecimal>

		ServiceLocator.getInstance().servicioAlmacenador.registros.forEach [ cadaBusqueda |
			agregarAlReporteCantidadDeBusquedasPorFecha(cadaBusqueda, reporteCantidadDeBusquedasPorFecha)
		]
		reporteCantidadDeBusquedasPorFecha
	}
	
	//metodo para pedir la tabla <terminal, cantidad> de una frase
	def HashMap<Usuario, Integer> reportarCantidadDeBusquedasPorTerminal(String fraseBusqueda) {
		val  tablaFinal = new HashMap<Usuario, Integer>()
		val listaDeBusquedasRelevantes = filtrarListaPorBusqueda(ServiceLocator.getInstance().servicioAlmacenador.registros, fraseBusqueda)
		
		RepoPerfilesUsuario.getInstance().listaTerminales().forEach[terminal | 
			tablaFinal.put(terminal, filtrarListaPorTerminal(listaDeBusquedasRelevantes, terminal).size)
		]

		tablaFinal
	}
	
	//metodo para pedir la tabla <frase, cantidad> de una terminal
	def HashMap<String, Integer> reportarBusquedasDeTerminalPorFrase(Usuario terminal) {
		val tablaFinal = new HashMap<String, Integer>()
		val listaBusquedasRelevantes = filtrarListaPorTerminal(ServiceLocator.getInstance().servicioAlmacenador.registros,terminal)
		
		ServiceLocator.getInstance().servicioAlmacenador.frasesUnicasPorTerminal(terminal).forEach[frase | 
			tablaFinal.put(frase, filtrarListaPorBusqueda(listaBusquedasRelevantes, frase).size)
		]
		
		tablaFinal
	}

	def HashMap<String, ArrayList<BigDecimal>> reportarCantidadDeResultadosPorBusquedaYPorTerminal() { // ISO Format
	// TODO: valicación de Fechas
		val reporteDeCantidadDeResultadosPorBusquedaYPorTerminal = new HashMap<String, ArrayList<BigDecimal>>
		ServiceLocator.getInstance().servicioAlmacenador.registros.
			forEach [ cadaBusqueda |
				agregarAlReporteDeCantidadDeResultadosPorBusquedaYPorTerminal(cadaBusqueda,
					reporteDeCantidadDeResultadosPorBusquedaYPorTerminal)
			]
		reporteDeCantidadDeResultadosPorBusquedaYPorTerminal
	}

	def HashMap<String, BigDecimal> reportarTotalesPorUsuario() {
		val reporteTotalDeCantidadDeResultadosPorUsuario = new HashMap<String, BigDecimal>
		val unReporteDeCantidadDeResultadosPorBusquedaYPorTerminal = reportarCantidadDeResultadosPorBusquedaYPorTerminal()
		unReporteDeCantidadDeResultadosPorBusquedaYPorTerminal.forEach [ nombreTerminal, arrayCantidadResultados|
			reporteTotalDeCantidadDeResultadosPorUsuario.put(nombreTerminal,
				new BigDecimal(arrayCantidadResultados.size))
		]
		reporteTotalDeCantidadDeResultadosPorUsuario
	}

	def private void agregarAlReporteCantidadDeBusquedasPorFecha(BusquedaRealizada unaBusqueda,
		HashMap<String, BigDecimal> reporteCantidadPorFecha) {

		val String fechaEnFormatoString = formateadorDeFechasddMMYY.print(unaBusqueda.fechaDeLaBusqueda)

		if (reporteCantidadPorFecha.containsKey(fechaEnFormatoString)) {
			val increase = (reporteCantidadPorFecha.get(fechaEnFormatoString).intValue + 1)
			reporteCantidadPorFecha.put(fechaEnFormatoString, new BigDecimal(increase))
		} else {
			reporteCantidadPorFecha.put(fechaEnFormatoString, new BigDecimal(1))
		}
	}

	def private agregarAlReporteDeCantidadDeResultadosPorBusquedaYPorTerminal(BusquedaRealizada cadaBusqueda,
		HashMap<String, ArrayList<BigDecimal>> reporteDeCantidadDeResultadosPorBusquedaYPorTerminal) {

		if (reporteDeCantidadDeResultadosPorBusquedaYPorTerminal.containsKey(cadaBusqueda.FDTerminal.nombre)) {

			reporteDeCantidadDeResultadosPorBusquedaYPorTerminal.get(cadaBusqueda.FDTerminal.nombre).add(
				cadaBusqueda.cantidadDeElementosEncontrados)
		} else {
			val nuevaListaDeCantidadDeResultados = new ArrayList<BigDecimal>
			nuevaListaDeCantidadDeResultados.add(cadaBusqueda.cantidadDeElementosEncontrados)
			reporteDeCantidadDeResultadosPorBusquedaYPorTerminal.put(cadaBusqueda.FDTerminal.nombre,
				nuevaListaDeCantidadDeResultados)
		}
	}
	
	def filtrarListaPorTerminal(ArrayList<BusquedaRealizada> lista, Usuario terminal) {
		IterableToArray.toArray(lista.filter[busqueda | busqueda.FDTerminal.equals(terminal)])
	}
	
	def filtrarListaPorBusqueda(ArrayList<BusquedaRealizada> lista, String fraseBuscada) {
		IterableToArray.toArray(lista.filter[busqueda | busqueda.fraseBuscada.equals(fraseBuscada)])
	}
}
