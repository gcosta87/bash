#!/bin/bash

#  crearPerfil.sh
#   
#  Copyright 2013 Gonzalo G. Costa <gonzalogcostaARROBAyahooPUNTOcomPUNTOar>
#   
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
   
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#   
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.   

datos=`zenity --forms --title="Inicio de Sesión" --text="Complete los campos para iniciar session\n en el Servicio de <i>Autogestion</i> de <b>Personal</b>." --separator=":" --add-list="Codigo de Area" --list-values="221|11" --column-values=" "  --add-entry="Nº de Celular" --add-password="Contraseña" --add-entry="Identificador/Nombre del celu"`
if [ -n "$datos" ] && [ "$datos" != " " ]
then
	#Debo guardar la data en el archivo
	codDeArea=`echo $datos | cut -f1 -d":"`
	celular=`echo $datos | cut -f2 -d":"`
	
	identificador=`echo $datos | cut -f4 -d":"`
	
	if [ -z "$identificador" ]
	then
		#Si el dentifciador no ha sido definido, le agrego uno por defecto
		datos="$datosMi Celular"
	fi
	
	echo "$datos" > .$codDeArea$celular.perfil
	
else
	zenity --title="Crear Perfil de Usuario" --info --text="Has decidido no completar los campos."
fi
