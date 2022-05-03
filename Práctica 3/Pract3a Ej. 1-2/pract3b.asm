;*********************************************************************
;*
;*
;* Sistemas Basados en Microprocesador
;* 2020-2021
;* Practica 3a
;*
;*
;* author:
;*
;* notas: ejemplo vacío
;*********************************************************************/

; DEFINICION DEL SEGMENTO DE CODIGO COMO PUBLICO
_TEXT SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS:_TEXT

	; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
	_MAIN PROC
		;COMIENZO DEL PROGRAMA
    MODO_VIDEO DB 0
    TAM DW ?
    COLOR DB ?
    DIR_POS_X Dw ?, ?
    DIR_POS_Y Dw ?, ?
    DIR_COLOR Dw ?, ?
    TIEMPO_ESPERA Dw ?, ?

    PUBLIC _pintaListaPixeles

	_MAIN ENDP

  _pintaListaPixeles proc far
    push bp
    mov bp, sp
    ; RECUPERAMOS LOS DATOS DE LA PILA
    mov dx, [bp+12] ; long int tiempoEspera (bytes altos)
    mov cx, [bp+10] ; long int tiempoEspera (bytes bajos)
    mov bx, [bp+8]  ; unsigned char bgcolor
    mov ax, [bp+6]  ; unsigned int numPixeles
    ; GUARDAMOS LOS ARGUMENTOS EN VARIABLES
    mov COLOR, BL
    mov TAM, AX
    mov TIEMPO_ESPERA[0], CX
    mov TIEMPO_ESPERA[2], DX
    ; SEGUIMOS RECUPERANDO LOS DATOS DE LA PILA
    mov dx, [bp+20] ; int* pixelList_y (SEG)
    mov cx, [bp+18] ; int* pixelList_y (OFFSET)
    mov bx, [bp+16] ; int* pixelList_x (SEG)
    mov ax, [bp+14] ; int* pixelList_x (OFFSET)
    ; GUARDAMOS LOS ARGUMENTOS EN VARIABLES
    mov DIR_POS_X[0], ax
    mov DIR_POS_X[2], bx
    mov DIR_POS_Y[0], cx
    mov DIR_POS_Y[2], dx
    ; SEGUIMOS RECUPERANDO LOS DATOS DE LA PILA
    mov dx, [bp+24] ; unsigned char* pixelList_color (SEG)
    mov cx, [bp+22] ; unsigned char* pixelList_color (OFFSET)
    ; GUARDAMOS LOS ARGUMENTOS EN VARIABLES
    mov DIR_COLOR[0], cx
    mov DIR_COLOR[2], dx

    ; FUNCION PRINCIPAL
    MOV AH,0Fh ; Peticion de obtencion de modo de video
    INT 10h ; Llamada al BIOS
    MOV MODO_VIDEO,AL ; SALVO EL MODO VIDEO Y LO ALMACENO EN AL

    mov ah, 00h ; configuramos entrada a modo video
    mov al, 12h ; 640x480 16 color graphics (VGA)
    int 10h

    ; configuramos color fondo verde 0010b
    mov ah, 0bh
    mov bh, 00h
    mov bl, COLOR ; ESTABLECEMOS EL FONDO A TRAVES DE LA VARIABLE COLOR
    int 10h

    mov DI, DS  ; GUARDAMOS DS EN EL REGISTRO DI
    mov SI, 0 ; SI REFERENCIA EL NUMERO DE PIXELES QUE SE DESEA PINTAR
  BUCLEP:
    ;Int10H pintar pixel --> AH=0Ch 	AL = Color, BH = NumPag, CX = x, DX = y
    mov ah, 0Ch
    ; lee de la pila el valor apropiado para el color
    mov bx, DIR_COLOR[2] ; COPIAMOS EL SEG DE DIR_COLOR EN BX
    mov DS, bx  ; ESTABLECEMOS DS AL SEGMENTO DE DIR_COLOR
    mov bx, DIR_COLOR[0] ; COPAIMOS EL OFFSET DE DIR_COLOR EN BX
    mov al, [BX][SI] ; color blanco 1111b

    mov bx, DIR_POS_X[2] ; COPIAMOS EL SEG DE DIR_POS_X EN BX
    mov DS, bx  ; ESTABLECEMOS DS AL SEGMENTO DE DIR_POS_X
    mov bx, DIR_POS_X[0] ; COPIAMOS EL OFFSET DE DIR_POS_X EN BX
    mov cx, [BX][SI] ; posicion X donde pintar
    mov bx, DIR_POS_Y[2] ; COPIAMOS EL SEG DE DIR_POS_Y EN BX
    mov DS, bx  ; ESTABLECEMOS DS AL SEGMENTO DE DIR_POS_Y
    mov bx, DIR_POS_Y[0] ; COPIAMOS EL OFFSET DE DIR_POS_Y EN BX
    mov dx, [BX][SI] ; posicion Y donde pintar

    mov bh, 00h
    int 10h

    INC SI  ; SUMAMOS 1 A SI
    CMP SI, TAM ; COMPARAMOS SI CON EL NUMERO DE PIXELES A PINTAR
    jne BUCLEP  ; SI NO SON IGUALES PINTAMOS EL SIGUIENTE PIXEL

    mov DS, DI  ; REESTABLECEMOS EL SEGMENTO ORIGINAL DE DS

    ;Int15H espera activa en microsegundos: 1 millon us = 1 segundo
    MOV     CX, TIEMPO_ESPERA[2] ; COPIAMOS TIEMPO_ESPERA EN CX (bytes altos)
    MOV     DX, TIEMPO_ESPERA[0] ; COPIAMOS TIEMPO_ESEPRA EN DX (bytes bajos)
    MOV     AH, 86H ;int 15h con AH=86h para espera de microsegundos en cx:dx
    INT     15H

    mov ah, 00h ; restaurar configuracion entrada a modo video
    mov al, MODO_VIDEO ;
    int 10h

    ; RETORNAMOS CORRECTAMENTE
    pop bp
    ret
  _pintaListaPixeles endp

_TEXT ENDS
END
