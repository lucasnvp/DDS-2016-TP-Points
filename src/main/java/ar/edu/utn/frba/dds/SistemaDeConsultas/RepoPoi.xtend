package ar.edu.utn.frba.dds.SistemaDeConsultas

import ar.edu.utn.frba.dds.SistemaDeConsultas.Adapters.AdapterBuscador
import ar.edu.utn.frba.dds.SistemaDeConsultas.Exception.BusinessException
import java.util.ArrayList
import java.util.Collection
import java.util.function.Predicate
import java.util.List
import ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda.InterfazDeObserversDeBusqueda
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import java.math.BigDecimal
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import org.joda.time.DateTime
import org.hibernate.Criteria
import org.hibernate.criterion.Restrictions
import org.hibernate.HibernateException
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepoPoi extends RepoBase<Poi> {

	static RepoPoi instance
	Collection<AdapterBuscador> adapters = new ArrayList()
	Collection<Poi> listaRetorno
	List<InterfazDeObserversDeBusqueda> observersBusqueda = new ArrayList<InterfazDeObserversDeBusqueda>()
	PoiFactory poiFactory = new PoiFactory
	Usuario usuarioActivo

	static def RepoPoi getInstance() {
		if (instance == null) {
			instance = new RepoPoi
			instance.crearPoisIniciales()
		}
		return instance
	}
	
	def searchById(long id) {
		val session = openSession
		try {
			session.createCriteria(Poi)
				//.setFetchMode("candidatos", FetchMode.JOIN)
				.add(Restrictions.eq("id", id))
				.uniqueResult as Poi
		} catch (HibernateException e) {
			throw new BusinessException(e.message)
		} finally {
			session.close
		}
	}

	override getEntityType() {
		typeof(Poi)
	}

	def validateDelete(Poi poi) {
		if (! isMember(poi)) 
			throw new BusinessException("El poi no se encuentra")
	}

	/*override update(Poi poi) { //TODO : corregir?
		if (! isMember(poi)) {
			throw new BusinessException("El poi no esta creado")
		} else {
			var id = poi.id
			objects.remove(poi)
			objects.add(poi)
			poi.id = id
		}
	} */

	def isMember(Poi poi) {
		allInstances.contains(poi)
	}

	def getCriterioPorNombre(String texto) {
		allInstances.filter[Poi poi|poi.nombre.equals(texto)].last
	}

	def getCriterioPorDireccion(String direccion) {
		[Poi poi|poi.direccion.toLowerCase.contains(direccion.toLowerCase)] as Predicate<Poi>
	}

	def getCriterioPorTexto(String texto) {
		[Poi poi|poi.nombre.equals(texto)]
	}

	// Busqueda interna
	def buscarLocal(String texto) {
		allInstances.filter[poi|poi.contiene(texto)].toList
	}

	// Busqueda global
	def search(String texto, Usuario terminalQueBusco) {
		val  comienzoBusqueda = DateTime.now()
		if (!RepoPerfilesUsuario.getInstance().existeUsuario(terminalQueBusco)) {
			throw new BusinessException("Intento buscar un usuario inexistente.")
		}
		
		listaRetorno = new ArrayList<Poi>()
		listaRetorno.addAll(buscarLocal(texto))
		adapters.forEach[adapter | listaRetorno.addAll(adapter.buscar(texto))]
		val  finBusqueda = DateTime.now()
		val duracionBusquedaEnSegundos =  (finBusqueda.getMillisOfDay - comienzoBusqueda.getMillisOfDay)
		
		val infoBusqueda = new BusquedaRealizada(texto, terminalQueBusco, new Double(duracionBusquedaEnSegundos), new BigDecimal(listaRetorno.size))
		observersBusqueda.forEach[observer | observer.observarBusqueda(infoBusqueda)]
		
		return listaRetorno
	}
	
	//Agrego adapters al repo
	def agregarAdapter(AdapterBuscador unAdapter){
		adapters.add(unAdapter)
	}
	
	def removerAdapter(AdapterBuscador unAdapter) {
		adapters.remove(unAdapter)
	}
	
	def cantidadAdapters(){
		adapters.size
	}
	
	def cantidadObservers() {
		observersBusqueda.size
	}
	
	def vaciarObservers() {
		observersBusqueda = new ArrayList<InterfazDeObserversDeBusqueda>()
	}
	
	def addObserverBusqueda(InterfazDeObserversDeBusqueda unObserver) {
		observersBusqueda.add(unObserver)
	}
	
	def removeObserverBusqueda(InterfazDeObserversDeBusqueda unObserver) {
		observersBusqueda.remove(unObserver)
	}
	
	def crearPoisIniciales() {
		var Poi starbucksLibertador
		var Poi burguerKing
		var Poi starbucksMaipu
		var Poi carrousel
		var Poi colectivoLinea71
		var Poi bancoSantander
		var Poi poiCGPComuna1
		var Poi poiCGPComuna2
		var Poi poiCGPComuna3
		var Poi poiCGPComuna4
		var Poi poiCGPComuna5
			
		starbucksLibertador =	poiFactory.parametrosBasicos("Starbucks", "Calle 1", -34.483346, -58.489661).
								parametrosLocalComercial(500.0, "Cafeteria").
								addWordsKey("Cafe").
								disponibilidadTodosLosDiasDe8a23().
								crearLocalComercial
		
		burguerKing = 	poiFactory.parametrosBasicos("Burger King", "Calle 2", -34.480581, -58.492341).
						parametrosLocalComercial(500.0, "Comidas Rapidas").
						addWordsKey("hamburguesa").addWordsKey("churrascos").
						disponibilidad(7, 8, 0, 23, 0).
						crearLocalComercial
		
		starbucksMaipu =	poiFactory.parametrosBasicos("Starbucks", "Calle 3", -34.528961, -58.481043).
							parametrosLocalComercial(500.0, "Cafeteria").
							disponibilidadTodosLosDiasDe8a23().
						 	crearLocalComercial
		
		carrousel =	poiFactory.parametrosBasicos("Carrousel", "Calle 4", -34.453317, -58.541989).
					parametrosLocalComercial(1000.0, "Plaza").
					disponibilidad(6, 10, 30, 13, 0).
					disponibilidad(6, 17, 0, 20, 30).
					crearLocalComercial
		
		//Paradas de colectivo
		colectivoLinea71 = 	poiFactory.parametrosBasicos("Parada 1", "Calle 5", -34.515246, -58.488491).
							parametrosParadaDeColectivo("71").
							crearParadaDeColecnivo
		
		//Bancos
		bancoSantander =	poiFactory.parametrosBasicos("Banco Santander", "Calle 6", -34.528961, -58.481043).
							parametrosBanco("Villa Luro", "Fabio Perez").
							crearBanco
		
		//CGPs
		poiCGPComuna1 = poiFactory.parametrosBasicos("CGPComuna1", "Calle 7", -34.599867, -58.386839).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP
		poiCGPComuna2 =	poiFactory.parametrosBasicos("CGPComuna2", "Calle 8", -34.596603, -58.398811).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		poiCGPComuna3 =	poiFactory.parametrosBasicos("CGPComuna3", "Calle 9", -34.603146, -58.396947).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		poiCGPComuna4 =	poiFactory.parametrosBasicos("CGPComuna4", "Calle 10", -34.650396, -58.424952).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		poiCGPComuna5 = poiFactory.parametrosBasicos("CGPComuna5", "Calle 11", -34.623073, -58.412468).
						addServicio("Rentas", 5, 10, 0, 18, 0).
						crearCGP 
		try {
			val listita = this.allInstances
			if (listita.isEmpty) {			
		//		RepoPoi.instance.agregarAdapter(new BancoAdapter())
		//	 	RepoPoi.instance.agregarAdapter(new CGPAdapter())
				//Ingreso las paradas de colectivo al repo
				RepoPoi.instance.create(colectivoLinea71)
				//Ingreso los locales comerciales al repo
				RepoPoi.instance.create(starbucksLibertador)
				RepoPoi.instance.create(burguerKing)
				RepoPoi.instance.create(starbucksMaipu)
				RepoPoi.instance.create(carrousel)
				//Ingreso los bancos y  CGP para pruebas en Angular
				RepoPoi.instance.create(bancoSantander)
		//		RepoPoi.instance.create(poiCGPComuna1)
		//		RepoPoi.instance.create(poiCGPComuna2)
		//		RepoPoi.instance.create(poiCGPComuna3)	
		//		RepoPoi.instance.create(poiCGPComuna4)
		//		RepoPoi.instance.create(poiCGPComuna5)
			}
		} catch (BusinessException e) {
			
		}
	}
	
	override addQueryByExample(Criteria criteria, Poi poi) {
		if (poi.nombre != null) {
			criteria.add(Restrictions.eq("nombre", poi.nombre))
		}
	}

}
