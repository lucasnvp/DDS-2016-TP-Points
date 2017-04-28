package ar.edu.utn.frba.dds.SistemaDeConsultasGUI

import ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Login.SistemaDeConsultaLoginModelo
import ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Login.SistemaDeConsultaLoginWindow
import org.uqbar.arena.Application
import ar.edu.utn.frba.dds.SistemaDeConsultasGUI.Busqueda.BusquedaBootstrap

class SistemaDeConsultaApplication extends Application{
	
	new(BusquedaBootstrap bootstrap){
		super(bootstrap)
	}	
	
	static def void main(String[] args) {
		new SistemaDeConsultaApplication(new BusquedaBootstrap).start()
		 
//		new SistemaDeConsultaLoginWindow().startApplication
//		ApplicationContext.instance.configureSingleton(typeof(Poi), new RepoPoi)
//		(new BusquedaBootstrap).run 
//		new BusquedaWindow().startApplication

	}
	
	override protected createMainWindow() {
		return new SistemaDeConsultaLoginWindow(this, new SistemaDeConsultaLoginModelo())
	}
	
//	override protected Window<?> createMainWindow() {
//		return new BusquedaWindow(this)
//	}
}