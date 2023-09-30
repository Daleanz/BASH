# !/bin/bash


esPar(){
	numero=$1

	if [[ $((numero % 2)) -eq 0 ]]
		then
			echo "El numero es Par"
		else
			echo "El numero es Impar"
	fi
}

echo "Ingrese un nunmero:"
read v1

esPar v1
