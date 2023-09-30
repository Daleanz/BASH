: '
Programa que pide el ingreso de dos numeros por teclado, compara si son o no iguales y muestra uno de estos 2 mensajes siguientes.

1) Los numeros son iguales.
2) Los numeros son diferentes.
'
echo "Ingresa el primer numero:"
read numero1

echo "Ingresa el segundo numero:"
read numero2

if [[ $numero1 -eq $numero2 ]]
  then 
      echo "Los numeros son iguales"
  else
      echo "Los numeros son diferentes"
fi

