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
  archivoCopia1="TextoFinal.txt"

  cp "$archivo" "$archivoCopia"
  # Se llama a la funcion VerificarSiExisteArchivo, para comprobar que se ha creado el archivo copia.
  VerificarSiExisteArchivo "$archivoCopia"
  
  # cat MiTexto.txt | tr -d 'áéíóúÁÉÍÓÚa' > CopiaArchivo.txt
  cat MiTexto.txt | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g;
                         s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g;' > CopiaArchivo.txt

  cp "$archivoCopia" "$archivoCopia1" 

  awk '{print tolower($0)}' "$archivoCopia" > "$archivoCopia1"

  rm "$archivoCopia"

  VerificarSiExisteArchivo "$archivoCopia"
  VerificarSiExisteArchivo "$archivoCopia1"

  echo " "
  echo "Contenido a Minusculas y sin Acentos"
  MostrarContenidoArchivo $archivoCopia1
}

# Llamada de las funciones.
VerificarSiExisteArchivo MiTexto.txt
MostrarContenidoArchivo MiTexto.txt
GenerarCopiaDelArchivo MiTexto.txt
