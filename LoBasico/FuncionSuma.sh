# !/bin/bash

# Función que suma dos numeros.
sumaDeNumeros(){
	numero1=$1
	numero2=$2

	suma=$((numero1 + numero2))

	echo "El resultado de la suma es: $suma"
}

echo "Ingresa el primer numero:"
read v1

echo "Ingresa el segundo numero:"
read v2

sumaDeNumeros v1 v2
