package ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda

import ar.edu.utn.frba.dds.SistemaDeConsultas.BusquedaRealizada
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario.Usuario
import java.util.Set
import java.util.HashSet

@Accessors
class AlmacenadorDeRegistros implements InterfazDeObserversDeBusqueda {
	
	public ArrayList<BusquedaRealizada> registros = new ArrayList<BusquedaRealizada>

	override void observarBusqueda(BusquedaRealizada laBusqueda) {

		if (laBusqueda.FDTerminal.debeRegistrar) {
			registros.add(laBusqueda)
		}

	}
	
	def frasesUnicasPorTerminal(Usuario terminal) {
		val Set<String> listaFrases = new HashSet()
		
		registros.filter[reg | reg.FDTerminal.equals(terminal)].forEach[reg | listaFrases.add(reg.fraseBuscada)]
		
		listaFrases
	}
	
	def vaciarRegistros() {
		registros = new ArrayList<BusquedaRealizada>
	}
}