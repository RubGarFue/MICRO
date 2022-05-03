; Autor: Rubén García de la Fuente
; Grupo 2301
; Práctica 2, ejercicio a

; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
    ; DEFINICION DE LOS VECTORES
    vector1 db 1,2,2,4
    vector2 db 4,2,5,1
    vector3 db 3,2,4,1
    errorNumDif DB "FUERA DEL CONJUNTO: 1,2,3,4", 13, 10, '$'
    salidaCorrecta DB "CORRECTO", 13, 10, '$'

DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
    DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
    RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
    ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA
    ; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
    INICIO PROC
        ; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
        MOV AX, DATOS
        MOV DS, AX
        MOV AX, PILA
        MOV SS, AX
        MOV AX, EXTRA
        MOV ES, AX
        MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
        ; FIN DE LAS INICIALIZACIONES
        ; COMIENZO DEL PROGRAMA
        CALL COMPROBACION
        ; FIN DEL PROGRAMA
        MOV AX, 4C00H
        INT 21H

    INICIO ENDP
    ;ESPACIO PARA SUBRUTINAS
    COMPROBACION PROC NEAR
        MOV SI, 0
    BUCLE1:
        MOV AL, 1
        MOV BL, 0
    BUCLE2:
        CMP AL, vector1[SI][BX]
        JNE NEXTA
        JE NEXTB
    NEXTA:
        INC AL
        CMP AL, 5
        JNE BUCLE2
        JE ERROR
    NEXTB:
        MOV AL, 1
        INC BL
        CMP BL, 4
        JNE BUCLE2
        JE CORRECTO
    CORRECTO:
        MOV AH, 9
        MOV DX, OFFSET salidaCorrecta
        INT 21H
        JMP FIN
    ERROR:
        MOV AH, 9
        MOV DX, OFFSET errorNumDif
        INT 21H
        JMP FIN
    FIN:
        ADD SI, 4
        CMP SI, 4*3
        JNE BUCLE1
        RET
    COMPROBACION ENDP
    ; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
