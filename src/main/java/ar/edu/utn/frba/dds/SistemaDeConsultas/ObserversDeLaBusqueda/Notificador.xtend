package ar.edu.utn.frba.dds.SistemaDeConsultas.ObserversDeLaBusqueda

import ar.edu.utn.frba.dds.SistemaDeConsultas.BusquedaRealizada
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.utn.frba.dds.SistemaDeConsultas.ServiceLocator
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServidorDeCorreosPosta

@Accessors
class Notificador implements InterfazDeObserversDeBusqueda {

	int tiempoLimiteBusqueda
	ServidorDeCorreosPosta unServidorDeCorreos = ServiceLocator.getInstance().servicioEmail

	new(int unTiempo) {
		tiempoLimiteBusqueda = unTiempo
	}
	
	def setTiempoLimite(int unTiempo) {
		tiempoLimiteBusqueda = unTiempo
	}

	override void observarBusqueda(BusquedaRealizada laBusqueda) {

		if ((laBusqueda.FDTerminal.debeNotificar) && (laBusqueda.tiempoDeConsulta >= tiempoLimiteBusqueda)) {
			ServiceLocator.getInstance().notificarAdministradoresDeTardanza(laBusqueda)
		}
	}

}
