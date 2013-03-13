// ejemploDeModulo.js
//
// Copyright 2013 AUTOR <MAIL>
// 
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
// MA 02110-1301, USA.


/*
 * Este módulo sirve de ejemplo para testear el DocumentadorJS: una pequeña utilidad hecha con Bash para armar documentación en base a un archivo con código fuente, principalmente orientado para ser usado en *.js (NodeJS).
 * 
 * 
 * 
 * Adicionalmente DocumentadorJS posee un estilo (*.css) el cual puede ser modificado para cambiarle la apariencia al Documento.
 * 
 * Prestar <strong>atención</strong> a la descripción del módulo que si la linea no termina en punto, no lo define
 * como un nuevo párrafo
 * permitiendo al usuario
 * escribir como quiera.
 */

// @nombre:			primeraFuncion
// @descripción:	Una simple funcion de ejemplo<br/>Para hacer multiples linas la descripción hace falta usar el &lt;br/&gt;. Aún esi esta más que claro que se permite HTML: <strong>Como</strong> <tt>si nada</tt> <u>ocurriera</u> <span style="color:blue">:D</span>.
// @estado:			Borrador
// @parámetro	dato: objeto
// @parámetro	texto: cadena
// @retorno	array: Devuelve un pequeño arreglo
function primeraFuncion(dato,texto){
	...
	return new Array;
}

// @nombre:			suma
// @descripción:	Otra simple funcion de ejemplo: en este caso una suma
// @estado:			Estable
// @parámetro	op1: numero
// @parámetro	op2: numero
// @retorno	numero: Devuelve el resultado de la suma de los operandos
function suma(op1,op2){		
	return op1+op2;
}

// @nombre:			conversor
// @descripción:	Convierte un Array en otro Objeto...
// @estado:			Experimental
// @parámetro	datos: arreglo, contiene la data a convertir
// @parámetro	callback(objeto dato): retorna via callback el dato convertido
function convesor(datos){		
	...
	callback(dato)
}

