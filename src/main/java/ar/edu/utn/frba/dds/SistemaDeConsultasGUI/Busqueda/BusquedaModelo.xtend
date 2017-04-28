package ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Busqueda

import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.RepoPerfilesUsuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import ar.edu.utn.frba.dds.SistemaDeConsultas.Poi
import ar.edu.utn.frba.dds.SistemaDeConsultas.RepoPoi
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable

@Accessors
@Observable
class BusquedaModelo {
	
	Usuario usuarioActivo
	String nombreABuscar
	String direccion
	List<Poi> resultados
	Poi poiSeleccionado
	
	//Repositorios
	RepoPoi repoPoi = ApplicationContext.instance.getSingleton(typeof(Poi)) as RepoPoi
	
	new(){
		val repoUsers = ApplicationContext.instance.getSingleton(typeof(Usuario)) as RepoPerfilesUsuario 
		usuarioActivo = repoUsers.findByName("termianlAbasto")
	}
	
	def void buscarPoi() {
		var List<Poi> listaFinal
		
		listaFinal = RepoPoi.instance.search(nombreABuscar, usuarioActivo).toList
		listaFinal.addAll(RepoPoi.instance.search(direccion, usuarioActivo))

		resultados = listaFinal
	}
	
	//Buscar sin usuario - Para hacer pruebas mas rapido
	def void buscarPorNombreSinUsuario(){
		resultados = repoPoi.buscarLocal(nombreABuscar)
	}
	
	//Todos los pois
	def void todosLosPois(){
		resultados = repoPoi.allInstances	
	}
	
}



