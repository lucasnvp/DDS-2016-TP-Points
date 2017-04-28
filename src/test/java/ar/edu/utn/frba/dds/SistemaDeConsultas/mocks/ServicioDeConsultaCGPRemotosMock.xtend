package ar.edu.utn.frba.dds.SistemaDeConsultas.mocks

import java.util.ArrayList
import ar.edu.utn.frba.dds.SistemaDeConsultas.CGP
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios.ServicioDeConsultaCGPRemotos

class ServicioDeConsultaCGPRemotosMock extends ServicioDeConsultaCGPRemotos {

	@Accessors
	ArrayList<CGP> listaCGPsDTO = new ArrayList()
	CGP cgp1
	CGP cgp2

	new() {
		
		inicializar()

	}
	
	override void inicializar(){
		
		cgp1 = new CGP("CGP Comuna #1", "Juan Perez", "Balvanera, San Cristobal, Recoleta", "5555555",
		"Junin 521", -35.9, -58.4)

		cgp1.agregarServicio("Atención ciudadana",1,9,00, 18, 00)
		cgp1.agregarServicio("Rentas", 1, 9, 00, 18, 00)

		cgp2 = new CGP("CGP Comuna #2", "Pedro Perez", "Almagro, Palermo", "5555555", "Av. Corrientes 521",
			-35.9, -58.4)
		cgp2.agregarServicio("Arba", 1, 9, 00, 18, 00)
		cgp2.agregarServicio("AFIP", 3, 9, 00, 18, 00)

		listaCGPsDTO.add(cgp1)
		listaCGPsDTO.add(cgp2)
		
	}
	
	override consultarCentrosDTO(String texto){
		
		var List<CGP> listaARetornar
		
		listaARetornar = listaCGPsDTO.filter[CGP cgp|cgp.barriosQueIncluye.contains(texto)].toList
		
	}
	
	override CGP getFirst(){
		
		listaCGPsDTO.head
		
	}

}

