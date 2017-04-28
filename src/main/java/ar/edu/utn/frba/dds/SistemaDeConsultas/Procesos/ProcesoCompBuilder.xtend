package ar.edu.utn.frba.dds.SistemaDeConsultas.Procesos

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ProcesoCompBuilder {
	
	List<Proceso> listaParcialProcesos = new ArrayList<Proceso>
	
	def ProcesoCompBuilder actualizador() {
		listaParcialProcesos.add(new ActualizadorDeLocalesComerciales)
		return this
	}
	
	def ProcesoCompBuilder baja(BajaDePois bajaDePois) {
		listaParcialProcesos.add(bajaDePois)
		return this
	}
	
	def ProcesoCompuesto build() {
		val ProcComp = new ProcesoCompuesto
		listaParcialProcesos.forEach[ proceso | ProcComp.agregarProceso(proceso) ]
		return ProcComp
	}
	
}