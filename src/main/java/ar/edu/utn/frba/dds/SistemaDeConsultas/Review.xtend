package ar.edu.utn.frba.dds.SistemaDeConsultas

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column

@Accessors
@Entity
class Review {
	
	@Id
	@GeneratedValue
	private long id
	
	@Column
	int calificacion
	
	@Column(length=150)
	String comentario
	
	@Column(length=50)
	String calificador
	
	new() {
		
	}
	
	new(int calif, String comment, String user) {
		calificacion = calif
		comentario = comment
		calificador = user
	}
	
}