package dk.sdu.mdsd.ui.hover

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import javax.inject.Inject
import dk.sdu.mdsd.generator.MathinterpreterGenerator
import org.eclipse.emf.ecore.EObject
import dk.sdu.mdsd.mathinterpreter.Exp
import org.eclipse.emf.ecore.util.Diagnostician

class MathInterpreterHoverProvider extends DefaultEObjectHoverProvider {
	@Inject extension MathinterpreterGenerator

	override getHoverInfoAsHtml(EObject o) {
		if (o instanceof Exp && o.programHasNoError) {
		val exp = o as Exp
		return '''
		<p>
		value : <b>«exp.computeExp»</b>
		</p>
		'''
			} else
				return super.getHoverInfoAsHtml(o)
	}
	
	
	def programHasNoError(EObject o) {
		Diagnostician.INSTANCE.validate(o.rootContainer).
		children.empty
	}
	
}