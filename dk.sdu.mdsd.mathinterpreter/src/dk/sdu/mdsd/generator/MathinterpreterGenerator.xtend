/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.mdsd.generator

import dk.sdu.mdsd.mathinterpreter.Div
import dk.sdu.mdsd.mathinterpreter.Exp
import dk.sdu.mdsd.mathinterpreter.MathExp
import dk.sdu.mdsd.mathinterpreter.Minus
import dk.sdu.mdsd.mathinterpreter.Model
import dk.sdu.mdsd.mathinterpreter.Mult
import dk.sdu.mdsd.mathinterpreter.Number
import dk.sdu.mdsd.mathinterpreter.Parenthesis
import dk.sdu.mdsd.mathinterpreter.Plus
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathinterpreterGenerator extends AbstractGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val math = resource.allContents.filter(Model).next
		generateMathFile(fsa, math)
	}
	
	def generateMathFile(IFileSystemAccess2 fsa, Model m) {
		fsa.generateFile("MathComputation"+".java", m.generateModel)
	}
	
	def CharSequence generateModel(Model m)'''
	// Generated by MathInterpreter, do not edit
	import java.util.*;
	
	
	public class MathComputation {
		�m.generateExternals�
		
		�m.generateCompute�
	}
	'''
	
	def CharSequence generateConstructor(Model m)'''
	public MathComputation(Externals _externals) {
		externals = _externals;
	}
	'''
	
	def CharSequence generateExternals(Model m)'''
	// BEGIN: required for external functions
	public static interface Externals {
		�FOR e: m.external�
		public �e.parameters.get(0).type� �e.name�(�FOR ep: e.parameters SEPARATOR ', '��ep.type� �ep.varName��ENDFOR�);
		�ENDFOR�
	}
	private Externals externals;
	�m.generateConstructor�
	// END: required for external functions
	'''
	
	def CharSequence generateCompute(Model m)'''
	public void compute() {
		�FOR math: m.exp.filter(MathExp)�
		System.out.println("�math.l.name� "+(�math.exp.printExp�));
		�ENDFOR�
		// BEGIN: external functions only
		�FOR e: m.external�
		System.out.println("external example "+(externals.�e.name�(�FOR exp: e.exp SEPARATOR ', '��exp.printExp��ENDFOR�)));
		�ENDFOR�
		// END: external functions only
	}
	'''
	// Purely for the hovering functionality to work
	def int computeExp(Exp e) {
		switch e {
			Number: e.value
			Plus: e.left.computeExp + e.right.computeExp
			Minus: e.left.computeExp - e.right.computeExp
			Mult: e.left.computeExp *e.right.computeExp
			Div: e.left.computeExp /e.right.computeExp
			Parenthesis: e.exp.computeExp
			default: 0
		}
	}
	
	def String printExp(Exp e) {
		switch e {
			Number: e.value.toString()
			Plus: e.left.printExp + "+" + e.right.printExp
			Minus: e.left.printExp + "-" + e.right.printExp
			Mult: e.left.printExp + "*" + e.right.printExp
			Div: e.left.printExp + "/" + e.right.printExp
			Parenthesis: '(' + e.exp.printExp + ')'
			default: ""
		}
	}
}
