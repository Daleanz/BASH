#!/bin/bash

# Declaracion de las funciones.

# Funcion que verifica si existe el archivo o no.
Presentacion(){
  echo "*************************************** Datos del Grupo *************************************************************************"
  echo "Integrante 1: Jeison Salas Colma --> Rut: 15.306.099-1"
  echo "Integrante 2: Roberto Barros Gutiérrez --> Rut: 20.759.294-3"
  echo "Integrante 3: David Moya Aravena --> Rut: 21.017.382-k

  echo " "
  echo "Trabajo de BASH - Sistemas Operativos"
  echo "Profesor: Felipe Tirado"
  echo "---------------------------------------------------------------------------------------------------------------------------------"
}
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
  echo "-------------------------------------------------------------------------------------------------------------------------------"
  archivo=$1 # Archivo que recibe por parametro la funcion.

  while IFS= read -r linea
  do
    echo "$linea"
  done < "$archivo"

  echo "-------------------------------------------------------------------------------------------------------------------------------"
  echo " "
}

# Funcion que se encarga de hacer una copia del archivo original para poder modificarlo despues.
# Copia y crea el archivo en el Directorio /home/user/Escritorio/
GenerarCopiaDelArchivo(){
  archivo=$1
  archivoCopia="CopiaArchivo.txt"
  archivoCopia1="CopiaArchivo1.txt"
  archivoFinal="TextoFinal.txt"

  nombreArchivo=$(basename "$archivo")
  echo "Nombre del archivo es $nombreArchivo"

  cp "$archivo" "$archivoCopia"
  # Se llama a la funcion VerificarSiExisteArchivo, para comprobar que se ha creado el archivo copia.
  VerificarSiExisteArchivo "$archivoCopia"
  
  # cat MiTexto.txt | tr -d 'áéíóúÁÉÍÓÚa' > CopiaArchivo.txt
  cat $nombreArchivo | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g;
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
  MostrarContenidoArchivo $archivo

  PalabrasFrecuentes=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w+' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}'))
  Frecuencia=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w+' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $1}'))
 
  echo "Las palabras con mas frecuencia del archivo $archivo son: "
  echo " "

  for ((i=0; i<${#PalabrasFrecuentes[@]}; i++))
  do
    echo "La $((i + 1)) palabra [${PalabrasFrecuentes[i]}] se repite: ${Frecuencia[i]} veces."
  done

  echo " "
}

ObtenerFrecuenciasLetras(){
  archivo=$1

  LetrasFrecuentes=($(cat "$archivo" | tr -s '[:space:]' | grep -o . | sort | uniq -c | sort -nr | head -n 6 | awk '{print $2}'))
  Frecuencia=($(cat "$archivo" | tr -s '[:space:]' | grep -o . | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1}'))

  echo "Las letras con mas frecuencia del archivo $archivo son: "
  echo " "

  for ((i=0; i<${#LetrasFrecuentes[@]}; i++))
  do
    echo "La $((i + 1)) letra [${LetrasFrecuentes[i]}] se repite: ${Frecuencia[i]} veces."
  done
}

# Llamada de las funciones.
Presentacion
#--------------------------------------------
nombreDelArchivo="MiTexto.txt"
VerificarSiExisteArchivo "$nombreDelArchivo"
contador=$?

if [ "$contador" -eq 1 ]; then
  echo "Contenido del archivo original: $nombreDelArchivo"
  MostrarContenidoArchivo "$nombreDelArchivo"
  GenerarCopiaDelArchivo "$nombreDelArchivo"
  ObtenerFrecuenciasPalabras TextoFinal.txt
  ObtenerFrecuenciasLetras TextoFinal.txt
else
  echo "El archivo no se encontro."
fi

echo " "
echo "Cerrando programa..."
