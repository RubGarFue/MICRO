;*********************************************************************
;* Sistemas Basados en Microprocesador
;* 2020-2021
;* Practica 3bs
;*
;*
;* author: Rubén García de la Fuente
;*********************************************************************/

; DEFINICION DEL SEGMENTO DE CODIGO COMO PUBLICO
_TEXT SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS:_TEXT

	; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
	_MAIN PROC
      ;COMIENZO DEL PROGRAMA
      STRING DW ?, ?
      SUBSTRING DW ?, ?
      NUMCUENTA DW ?, ?
      DATASEGMENT DW ?
      INDICE DW ?
      CUENTADEC DW 10 dup (?)
      SEGUNDODC DW 0

		  PUBLIC _encuentraSubcadena
      PUBLIC _calculaSegundoDC

	_MAIN ENDP

  _encuentraSubcadena proc far
      push bp
      mov bp, sp
      ; RECUPERAMOS LOS DATOS DE LA PILA
      mov dx, [bp+12] ; char* substr (SEG)
      mov cx, [bp+10] ; char* substr (OFFSET)
      mov bx, [bp+8]  ; char* str (SEG)
      mov ax, [bp+6]  ; char* str (OFFSET)
      ; GUARDAMOS LOS ARGUMENTOS EN VARIABLES
      mov STRING[0], ax
      mov STRING[2], bx
      mov SUBSTRING[0], cx
      mov SUBSTRING[2], dx

      ; FUNCION PRINCIPAL
      mov bx, DS ; GUARDAMOS DS EN DATASEGMENT
      mov DATASEGMENT, bx

      mov si, 0 ; DI REFERENCIA AL INDICE DE LA CADENA
      mov di, 0 ; SI REFERENCIA AL INDICE DE LA SUBCADENA
    BUCLE1: ; COPIA EL CARACTER DESEADO DE SUBSTRING EN DL
      mov ax, SUBSTRING[2] ; COPIAMOS EL SEG DE SUBSTRING EN BX
      mov DS, ax  ; ESTABLECEMOS DS AL SEGMENTO DE SUBSTRING
      mov bx, SUBSTRING[0] ; COPIAMOS EL OFFSET DE SUBSTRING EN BX
      mov dl, BYTE PTR [bx][di] ; COPIAMOS EL CARACTER DESEADO DE SUBSTRING EN DL

      cmp dl, 0 ; MIRAMOS SI DL ES IGUAL A 0 (FIN DE CADENA)
      je FIN1 ; SI ES ASI FINALIZAMOS CORRECTAMENTE, SI NO PASAMOS A STRING

    BUCLE2: ; COPIA EL CARACTER DESEADO DE STRING EN DH
      mov ax, STRING[2] ; COPIAMOS EL SEG DE STRING EN BX
      mov DS, ax  ; ESTABLECEMOS DS AL SEGMENTO DE STRING
      mov bx, STRING[0] ; COPIAMOS EL OFFSET DE STRING EN BX
      mov dh, BYTE PTR [bx][si] ; COPIAMOS EL CARACTER DESEADO DE STRING EN DL

      cmp dh, 0 ; MIRAMOS SI DH ES IGUAL A 0 (FIN DE CADENA)
      je ERROR ; SI ES ASI NO HEMOS ENCONTRADO LA SUBCADENA Y DEVOLVEMOS ERROR

      cmp dl, dh ; COMPARAMOS DL CON DH
      jne NEXTSI ; SI NO SON IGUALES MIRAMOS EL SIGUIENTE CARACTER DE STRING
      je NEXTDI ; SI SON IGUALES MIRAMOS EL SIGUIENTE CARACTER DE AMBAS CADENAS

    NEXTSI: ; APUNTA AL SIGUIENTE CARACTER DE STRING
      inc si ; INCREMENTAMOS SI EN 1
      mov di, 0 ; SI SE EJECUTA ESTO ES PORQUE SEGUMOS BUSCANDO LA SUBCADENA (EMPEZAMOS MIRANDO POR EL 0)
      jmp BUCLE2 ; VOLVEMOS AL BUCLE 2

    NEXTDI: ; APUNTA AL SIGUIENTE CARACTER DE STRING Y SUBSTRING
      inc si ; INCREMENTAMOS SI EN 1
      inc di ; INCREMENTAMOS DI EN 1
      jmp BUCLE1 ; VOLVEMOS AL BUCLE1

    FIN1: ; RETORNAMOS CORRECTAMENTE
      mov bx, DATASEGMENT
      mov DS, bx ; REESTABLECEMOS EL SEGMENTO ORIGINAL DE DS
      sub si, di ; EL INDIICE ES LA DIFERENCIA DE SI Y DI
      mov ax, si ; RETORNAMOS EL INDICE PEDIDO
      pop bp
      ret
    ERROR: ; DEVOLVEMOS -1 SI NO SE HA ENCONTRADO LA SUBCADENA
      mov bx, DATASEGMENT
      mov DS, bx ; REESTABLECEMOS EL SEGMENTO ORIGINAL DE DS
      mov ax, -1 ; RETORNAMOS -1
      pop bp
      ret
  _encuentraSubcadena endp

  _calculaSegundoDC proc far
      push bp
      mov bp, sp
      ; RECUPERAMOS LOS DATOS DE LA PILA
      mov dx, [bp+8]  ; char* numCuenta (SEG)
      mov cx, [bp+6]  ; char* numCuenta (OFFSET)
      ; GUARDAMOS LOS ARGUMENTOS EN VARIABLES
      mov NUMCUENTA[0], cx
      mov NUMCUENTA[2], dx

      ; FUNCION PRINCIPAL
      mov bx, DS ; GUARDAMOS DS EN DATASEGMENT
      mov DATASEGMENT, bx

      mov ax, NUMCUENTA[2] ; COPIAMOS EL SEG DE NUMCUENTA EN BX
      mov DS, ax ; ESTABLECEMOS DS AL SEGMENTO DE NUMCUENTA
      mov bx, NUMCUENTA[0] ; COPIAMOS EL OFFSET DE NUMCUENTA EN BX
      mov dh, 0 ; PONEMOS DH A 0
      mov si, 0 ; SI REFERENCIA AL INDICE DE LA CADENA NUMCUENTA
      mov di, 0 ; DI REFERENCIA AL DATO NUMCUENTA EN DECIMAL (CUENTADEC)
    BUCLE3:
      mov dl, [bx][si] ; COPIAMOS EL CARACTER CORRESPONDINETE EN DL
      sub dl, 30h ; RESTAMOS 30H A DL (PASAMOS EL NUMEOR A DECIMAL)
      mov CUENTADEC[di], dx ; PASAMOS EL NUMERO AL INDICE CORRESPONDINETE DE CUENTADEC
      inc si ; INCREMENTAMOS SI EN 1 (TAMANO BYTE)
      add di, 2 ; INCREMENTAMOS DI EN 2 (TAMANO WORD)
      cmp si, 10 ; COMPARAMOS SI A 10 (NUMERO DE CARACTERES)
      jne BUCLE3 ; SI NO SON IGUALES COPIAMOS EL SIGUIENTE CARACTER

      ; MULTIPLICAMOS CADA NUMERO POR EL QUE SE ESPECIFICA PARA REALIZAR LA CUENTA
      ; MULTIPLICAMOS EL PRIMER NUMERO POR 1
      mov al, BYTE PTR CUENTADEC[0]
      mov dl, 1
      mul dl
      mov CUENTADEC[0], ax

      ; MULTIPLICAMOS EL SEGUNDO NUMERO POR 2
      mov al, BYTE PTR CUENTADEC[2]
      mov dl, 2
      mul dl
      mov CUENTADEC[2], ax

      ; MULTIPLICAMOS EL TERCER NUMERO POR 4
      mov al, BYTE PTR CUENTADEC[4]
      mov dl, 4
      mul dl
      mov CUENTADEC[4], ax

      ; MULTIPLICAMOS EL CUARTO NUMERO POR 8
      mov al, BYTE PTR CUENTADEC[6]
      mov dl, 8
      mul dl
      mov CUENTADEC[6], ax

      ; MULTIPLICAMOS EL QUINTO NUMERO POR 5
      mov al, BYTE PTR CUENTADEC[8]
      mov dl, 5
      mul dl
      mov CUENTADEC[8], ax

      ; MULTIPLICAMOS EL SEXTO NUMERO POR 10
      mov al, BYTE PTR CUENTADEC[10]
      mov dl, 10
      mul dl
      mov CUENTADEC[10], ax

      ; MULTIPLICAMOS EL SEPTIMO NUMERO POR 9
      mov al, BYTE PTR CUENTADEC[12]
      mov dl, 9
      mul dl
      mov CUENTADEC[12], ax

      ; MULTIPLICAMOS EL OCTAVO NUMERO POR 7
      mov al, BYTE PTR CUENTADEC[14]
      mov dl, 7
      mul dl
      mov CUENTADEC[14], ax

      ; MULTIPLICAMOS EL NOVENO NUMERO POR 3
      mov al, BYTE PTR CUENTADEC[16]
      mov dl, 3
      mul dl
      mov CUENTADEC[16], ax

      ; MULTIPLICAMOS EL DECIMO NUMERO POR 6
      mov al, BYTE PTR CUENTADEC[18]
      mov dl, 6
      mul dl
      mov CUENTADEC[18], ax

      mov si, 0 ; SI REFERENCIA AL INDICE DEL NUMERO DE CUENTA EN DECIMAL (CUANTADEC)
    BUCLE4: ; REALIZAMOS LA SUMA DE TODOS LOS NUMEROS
      mov bx, CUENTADEC[si]
      add SEGUNDODC, bx ; SUMAMOS A SEGUNDODC EL NUMERO DE CUENTADEC CORRESPONDIENTE
      add si, 2 ; INCREMENTAMOS SI EN 2
      cmp si, 20 ; MIRAMOS SI HEMOS SUMADO TODOS LOS NUMEROS
      jne BUCLE4 ; SI NO PASAMOS AL SIGUIENTE NUMERO

      ; MOVEMOS DX A 0 Y REALIZAMOS EL MODULO 11 DE LA SUMA (EN DX ESTARA EL MODULO/RESTO)
      mov dx, 0
      mov ax, SEGUNDODC
      mov bx, 11
      div bx

      sub bx, dx ; RESTAMOS 11 MENOS EL MODULO 11 DE LA SUMA
      mov SEGUNDODC, bx ; COPIAMOS EL RESULTADO EN SEGUNDODC

      cmp SEGUNDODC, 10 ; MIRAMOS SI SEGUNDODC ES IGUAL A 10
      jne FIN2 ; SI NO LO ES RETORNAMOS CORRECTAMENTE
      mov SEGUNDODC, 1 ; SI LO ES CONTROLAMOS LA EXCEPCION Y ESTABLECEMOS SEGUNDODC A 1

    FIN2: ; RETORNAMOS CORRECTAMENTE
      mov bx, DATASEGMENT
      mov DS, bx ; REESTABLECEMOS EL SEGMENTO ORIGINAL DE DS
      mov ax, SEGUNDODC ; RETORNAMOS SEGUNDODC
      pop bp
      ret
  _calculaSegundoDC endp


_TEXT ENDS
END
