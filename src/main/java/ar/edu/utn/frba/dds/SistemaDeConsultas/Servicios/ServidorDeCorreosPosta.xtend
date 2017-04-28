package ar.edu.utn.frba.dds.SistemaDeConsultas.Servicios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ServidorDeCorreosPosta {

	//List<Mensaje> mails = new ArrayList<Mensaje>()
	int mails = 0
	
	def void enviarMail(String asunto, String de, String para, String cuerpo) {
		//mails.add(new Mensaje(asunto, de, para, cuerpo))
		mails = mails + 1
	}
	
	def vaciarMails() {
		//mails = new ArrayList<Mensaje>()
		mails = 0
	}
}