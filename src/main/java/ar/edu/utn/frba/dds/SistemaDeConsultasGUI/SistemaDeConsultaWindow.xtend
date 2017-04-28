package ar.edu.utn.frba.dds.SistemaDeConsultasGUI

import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Panel

class SistemaDeConsultaWindow extends SimpleWindow<SistemaDeConsultaModelo>{
	
	/*
	 * Lucas = Revisar - sin funcionalidad
	 */
	
		new(WindowOwner parent) {
		super(parent, new SistemaDeConsultaModelo)
		title = "Sistema de Consulta PoI"
		taskDescription = "Login"
	}
	
	override protected addActions(Panel actionsPanel) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override protected createFormPanel(Panel mainPanel) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}