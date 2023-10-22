#!/bin/bash

# Declaracion de las funciones.

# Funcion que verifica si existe el archivo o no.
VerificarSiExisteArchivo(){
  archivo=$1 # Archivo que recibre por parametro la funcion.

  if [ -f "$archivo" ]; then
    echo "$archivo ---- SI existe."
    echo " "

    booleano=1
    return $booleano
  else
    echo "$archivo ---- NO existe."
    echo " "

    booleano=0
    return $booleano
  fi
}

# Funcion que mostrara el contenido de el archivo.
MostrarContenidoArchivo(){
  archivo=$1 # Archivo que recibe por parametro la funcion.

  while IFS= read -r linea
  do
    echo "$linea"
  done < "$archivo"

  echo " "
}

# Funcion que se encarga de hacer una copia del archivo original para poder modificarlo despues.
# Copia y crea el archivo en el Directorio /home/user/Escritorio/
GenerarCopiaDelArchivo(){
  archivo=$1
  archivoCopia="CopiaArchivo.txt"
  archivoCopia1="CopiaArchivo1.txt"
  archivoFinal="TextoFinal.txt"

  cp "$archivo" "$archivoCopia"
  # Se llama a la funcion VerificarSiExisteArchivo, para comprobar que se ha creado el archivo copia.
  VerificarSiExisteArchivo "$archivoCopia"
  
  # cat MiTexto.txt | tr -d 'áéíóúÁÉÍÓÚa' > CopiaArchivo.txt
  cat MiTexto.txt | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g;
                         s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g;' > CopiaArchivo.txt

  cp "$archivoCopia" "$archivoCopia1" 

  awk '{print tolower($0)}' "$archivoCopia" > "$archivoCopia1"
  VerificarSiExisteArchivo "$archivoCopia1"
  cat CopiaArchivo1.txt | tr -d '.,:;¿?¡!+-_*"(){}[]=#$%&/' > TextoFinal.txt

  #cat CopiaArchivo1.txt | tr -d '.;:?¡!¿*+-´"#$%&/()=' > TextoFinal.txt
  rm "$archivoCopia"
  rm "$archivoCopia1"

  VerificarSiExisteArchivo "$archivoCopia"
  VerificarSiExisteArchivo "$archivoCopia1"
  VerificarSiExisteArchivo "$archivoFinal"

  echo " "
  echo "Contenido a Minusculas, sin Acentos y sin signos de Puntuacion"
  #MostrarContenidoArchivo $archivoFinal

}

ObtenerFrecuenciasPalabras(){
  archivo=$1
  echo "Desde la ultima funcion"
  MostrarContenidoArchivo $archivo

 PalabrasFrecuentes=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w+' | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2}'))
 Frecuencia=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w+' | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1}'))
 
 for ((i=0; i<${#PalabrasFrecuentes[@]}; i++))
 do
   echo "La palabra: [${PalabrasFrecuentes[i]}] se repite: ${Frecuencia[i]} veces."
 done

}

# Llamada de las funciones.
VerificarSiExisteArchivo MiTexto.txt
MostrarContenidoArchivo MiTexto.txt
GenerarCopiaDelArchivo MiTexto.txt
ObtenerFrecuenciasPalabras TextoFinal.txt
