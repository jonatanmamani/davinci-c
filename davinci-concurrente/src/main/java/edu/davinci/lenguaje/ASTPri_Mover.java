/*******************************************************************************
 * Copyright (c) 2011, 2013  - Daniel, Aguil Mallea.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Public License v3.0
 * which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/gpl.html
 * 
 * Contributors:
 *     Daniel, Aguil Mallea - initial API and implementation
 ******************************************************************************/
package edu.davinci.lenguaje;

import edu.davinci.ciudad.Robot;

@SuppressWarnings("all")
public class ASTPri_Mover extends ASTPrimitiva {

	/**
	 * 
	 * @param id
	 */
	public ASTPri_Mover(int id) {
		super(id);
	}

	/**
	 * 
	 * @param p
	 * @param id
	 */
	public ASTPri_Mover(Parser p, int id) {
		super(p, id);
	}

	/**
	 * 
	 */
	public void interpret() {
		Debug.println("<<Pri_Mover>>");

		// Obtenemos el robot adecuado
		Robot robot = super.getRobot();

		// avanzamos
		robot.mover();
	}
}
