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
    POS_X DW ?
    POS_Y DW ?
    COLOR DB ?

		PUBLIC _pintaPixel
    PUBLIC _pintaCuadrado

	_MAIN ENDP

	_pintaPixel proc far
    push bp
    mov bp, sp
    ; RECUPERAMOS LOS DATOS DE LA PILA
    mov dx, [bp+10] ; int y
    mov cx, [bp+8]  ; int x
    mov bx, [bp+6]  ; unsigned char color
    ; GUARDAMOS LOS ARGUMENTOS EN VARIABLES
    mov COLOR, BL
    mov POS_X, CX
    mov POS_Y, DX

    ; COMPROBACION DE ERRORES
    sub cx, 640
    ja ERRORP ; SI POS_X ES MAYOR QUE 640 DEVOLVEMOS ERROR
    sub dx, 480
    ja ERRORP ; SI POS_Y ES MAYOR QUE 480 DEVOLVEMOS ERROR

    ; FUNCION PRINCIPAL
    ; usamos interrupción 10h para entrar en modo video
    MOV AH,0Fh ; Peticion de obtencion de modo de video
    INT 10h ; Llamada al BIOS
    MOV MODO_VIDEO,AL ; SALVO EL MODO VIDEO Y LO ALMACENO EN AL

    mov ah, 00h ; configuramos entrada a modo video
    mov al, 12h ; 640x480 16 color graphics (VGA)
    int 10h

    ; configuramos color fondo verde 0010b
    mov ah, 0bh
    mov bh, 00h
    mov bl, 02h; 0 color negro 2 ; color verde
    int 10h

    ;Int10H pintar pixel --> AH=0Ch 	AL = Color, BH = NumPag, CX = x, DX = y
    mov ah, 0Ch
   ; lee de la pila el valor apropiado para el color
    mov al, COLOR ; COPIAMOS EL COLOR GUARDADO EN AL
    mov bh, 00h ; numero pagina (dejar siempre a cero)
    mov cx, POS_X ; posicion X donde pintar
    mov dx, POS_Y ; posicion Y donde pintar
    int 10h

    ;Int15H espera activa en microsegundos: 1 millon us = 1 segundo
    MOV     CX, 2Dh ; CX:DX forman el tiempo de espera: 1 second = F:4240H --> 3 seconds 2D:C6C0 h
    MOV     DX, 0C6C0h
    MOV     AH, 86H ;int 15h con AH=86h para espera de microsegundos en cx:dx
    INT     15H

    mov ah, 00h ; restaurar configuracion entrada a modo video
    mov al, MODO_VIDEO ;
    int 10h

    ; DEVOLVEMOS 0 SI TODO HA SIDO CORRECTO
    mov ax, 0
    pop bp
		ret
  ERRORP: ; DEVOLVEMOS -1 SI HAY ALGUN ERROR
    mov ax, -1
    pop bp
    ret
	_pintaPixel endp


  _pintaCuadrado proc far
    push bp
    mov bp, sp
    ; RECUPERAMOS LOS DATOS DE LA PILA
    mov dx, [bp+12] ; int y
    mov cx, [bp+10] ; int x
    mov ax, [bp+8]  ; int tam
    mov bx, [bp+6]  ; unsigned char color
    ; GUARDAMOS LOS ARGUMENTOS EN VARIABLES
    mov COLOR, BL
    mov POS_X, CX
    mov POS_Y, DX
    mov TAM, AX

    ; COMPROBACION DE ERRORES
    sub cx, 640
    ja ERRORC ; SI POS_X ES MAYOR QUE 640 DEVOLVEMOS ERROR
    sub dx, 480
    ja ERRORC ; SI POS_Y ES MAYOR QUE 480 DEVOLVEMOS ERROR

    ; FUNCION PRINCIPAL
    ; usamos interrupción 10h para entrar en modo video
    MOV AH,0Fh ; Peticion de obtencion de modo de video
    INT 10h ; Llamada al BIOS
    MOV MODO_VIDEO,AL ; SALVO EL MODO VIDEO Y LO ALMACENO EN AL

    mov ah, 00h ; configuramos entrada a modo video
    mov al, 12h ; 640x480 16 color graphics (VGA)
    int 10h

    ; configuramos color fondo verde 0010b
    mov ah, 0bh
    mov bh, 00h
    mov bl, 02h; 0 color negro 2 ; color verde
    int 10h

    ;Int10H pintar pixel --> AH=0Ch 	AL = Color, BH = NumPag, CX = x, DX = y
    mov ah, 0Ch
    ; lee de la pila el valor apropiado para el color
    mov al, COLOR ; COPIAMOS EL COLOR GUARDADO EN AL
    mov bh, 00h ; numero pagina (dejar siempre a cero)

    mov BX, 0 ; BX REFERENCIA LA ALTURA DEL CUADRADO
    mov SI, 0 ; SI REFERENICA LA ANCHURA DEL CUADRADO
  BUCLE:
    mov cx, POS_X ; posicion X donde pintar
    ADD cx, SI ; SUMAMOS A POS_X EL PIXEL DE ANCHURA QUE CORRESPONDE PINTAR
    mov dx, POS_Y ; posicion Y donde pintar
    ADD dx, bx ; SUMAMOS A POS_Y EL PIXEL DE ALTURA QUE CORRESPONDE PINTAR
    int 10h

    INC SI ; SUMAMOS 1 A SI
    CMP SI, TAM ; COMPRARAMOS SI CON EL TAMAÑO DEL CUADRADO
    jne BUCLE ; SI NO SON IGUALES PINTAMOS EL SIGUIENTE PIXEL DE ANCHURA
    INC BX ; SUMAMOS 1 A BX
    MOV SI, 0 ; MOVEMOS SI A 0 (PASAMOS AL SIGUIENTE PIXEL DE ALTURA Y PINTAMOS DE IZQUIERDA A DERECHA)
    CMP BX, TAM ; COMPARAMOS BX CON EL TAMAÑO DEL CUADRADO
    jne BUCLE ; SI NO SON IGUALES PINTAMOS EL SIGUIENTE PIXEL DE ALTURA

    ;Int15H espera activa en microsegundos: 1 millon us = 1 segundo
    MOV     CX, 2Dh ; CX:DX forman el tiempo de espera: 1 second = F:4240H --> 3 seconds 2D:C6C0 h
    MOV     DX, 0C6C0h
    MOV     AH, 86H ;int 15h con AH=86h para espera de microsegundos en cx:dx
    INT     15H

    mov ah, 00h ; restaurar configuracion entrada a modo video
    mov al, MODO_VIDEO ;
    int 10h

    ; DEVOLVEMOS 0 SI TODO HA SIDO CORRECTO
    mov ax, 0
    pop bp
    ret
  ERRORC: ; DEVOLVEMOS -1 SI HAY ALGUN ERROR
    mov ax, -1
    pop bp
    ret
	_pintaCuadrado endp


_TEXT ENDS
END
