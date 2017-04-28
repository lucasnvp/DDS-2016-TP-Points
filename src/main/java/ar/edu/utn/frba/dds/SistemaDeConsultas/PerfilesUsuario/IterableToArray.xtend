package ar.edu.utn.frba.dds.SistemaDeConsultas.PerfilesUsuario

import java.util.ArrayList

class IterableToArray {
	def static <E> ArrayList<E> toArray(Iterable<E> iterable) {
		val ArrayList<E> list = new ArrayList<E>();
		if(iterable != null) {
		  for(E e: iterable) {
		    list.add(e);
		  }
		}
		return list;
  }
}