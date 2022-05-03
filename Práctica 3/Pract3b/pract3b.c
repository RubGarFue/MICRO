/*********************************************************************
 * pract3b.c
 *
 * Sistemas Basados en Microprocesador
 * 2020-2021
 * Practica 3
 * Funciones relacionadas con cadenas
 *
 *********************************************************************/

#include <stdio.h>
#include <stdlib.h>

#define MAXSTR 30
#define NUMCUENTA 10

/***** Declaracion de funciones *****/

/*------------------------------- Ejercicio 1 ---------------------------------*/
/*******************************************************************************
* Nombre: encuentraSubcadena
*
* funcionalidad: devuelve el índice a partir del cual se encuentra contenida la
*				subcadena "substr" en la cadena "str".
* Parámetros de entrada:
*				- char* str : puntero en el cual se encuentra la cadena
*				- char* substr : puntero en el cual se encuentra la subcadena
* Valores retorno:
*				- int: -1 si la subcadena no se encuentra dentro de la cadena; entero
*				representando el índice a partir del cual se encuentra la subcadena.
******************************************************************************/
int encuentraSubcadena(char* str, char* substr);


/*********************************************************************************
* Nombre: calculaSegundoDC
*
* funcionalidad: Devuelve como valor de retorno el segundo dígito de control de
*				una cuenta bancaria correspondiente al número de cuenta de 10 dígitos
*				dado como cadena de caracteres ASCII.
* Parámetros de entrada:
* 			- char* numCuenta : puntero en el cual se encuentra el número de cuenta
* Valores retorno:
*				- unsigned int : segundo dígito de control de una cuenta bancaria

*******************************************************************************/
unsigned int calculaSegundoDC(char* numCuenta);


//////////////////////////////////////////////////////////////////////////
///// -------------------------- MAIN ------------------------------ /////
//////////////////////////////////////////////////////////////////////////
int main(void) {
	// Declaracion de variables
	unsigned char opcion = 'c';
	char str[MAXSTR], substr[MAXSTR], numCuenta[MAXSTR];

	int reta;
	unsigned int retb;

	//Pinta instrucciones para usuario
	printf("Instrucciones generales:\n");
	printf(" - El numero maximo de caractres de la cadena es 30\n");
	printf(" - El numero caractres del numero de cuenta es 10\n\n");


	//Solicita una opcion al usuario
	printf("Elija la opcion que desea probar: \n");
	printf("a - encontrar una subcadena \n");
	printf("b - calcular el segundo digito de control \n");
	scanf("%c", &opcion);

	//Comprueba es una opcion valida del menu
	if (opcion == 'a' || opcion == 'b') {
		printf("-Opcion Elegida --> %c -\n", opcion);
	}
	else {
		printf("-Opcion %c: incorrecta fuera de [a,b]\n Bye\n", opcion);
		return -1;
	}

	//Dependiendo de la opcion elegida ejecuta una funcion ensamblador u otra
	switch(opcion) {

		//opcion encontrar una subcadena
		case 'a':
				printf("Introduzca separado por espacios la cadena y subcadena que desea encontrar\n(e.g. abcdefghijklmn defghijk): \n");
				scanf("%s %s", str, substr);
				if (strlen(str) > MAXSTR) {
					printf("Error: Tamano de cadena mayor que el maximo permitido\n");
					break;
				}
				if (strlen(substr) > MAXSTR) {
					printf("Error: Tamano de subcadena mayor que el maximo permitido\n");
					break;
				}
				reta = encuentraSubcadena(str, substr); //LLAMA A FUNCION EN ENSAMBLADOR
				if (reta == -1) {
					printf("La subcadena no se encuentra dentro de la cadena\n", substr, str);
				}
				else {
					printf("La subcadena se encuentra a partir del indice %d\n", reta);
				}
				break;

		//opcion calcular el segundo digito de control
		case 'b':
				printf("Introduzca separado por espacios la posicion x e y del cuadrado a pintar seguido del tamano y color\n(e.g. 0438853602): \n");
				scanf("%s", numCuenta);
				if (strlen(numCuenta) != NUMCUENTA) {
					printf("Error: Tamano de cuenta distinto del especificado\n");
					break;
				}
				retb = calculaSegundoDC(numCuenta);  //LLAMA A FUNCION EN ENSAMBLADOR
				printf("El segundo digito de control de la cuenta es %u\n", retb);
				break;

		default: break;

	} //fin de switch(opcion)

	return 0;
}
