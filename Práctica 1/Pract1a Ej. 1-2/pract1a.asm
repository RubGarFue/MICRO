;**************************************************************************
; SBM 2020. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
  ;-- rellenar con los datos solicitados

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
  MOV AX, 9BH ; Carga 9Bh directamente en AX, comprobado con el turbodebugger
  MOV BL, 10110010B ; Transformamos B2h de hexa a binario, comprobamos que carga B2 en BL
  MOV CX, 3412H ; Carga 3412h directamente en CX, comprobado con el turbodebugger
  MOV AX, 01001001B
  MOV DS, AX  ; Primero cargamos 01001001B en el registro AX y, a continuación, cargamos AX en DS
  MOV DX, CX  ; Carga directamente CX en DX, comprobado con el turbodebugger
  MOV AX, 5523H
  MOV DS, AX
  MOV BH, DS:[5H]
  MOV BL, DS:[6H] ; Cargamos la direccion virtual 5523h en DS y, a continuación, con el offset cargamos 55235h en BH y 55236h en BL
  MOV AX, 7000H
  MOV DS, AX
  MOV CH, DS:[8H] ; Cargamos la direccion virtual 7000h en DS y, a continuación, con el offset cargamos 70008h en CH
  MOV SI, 8H
  MOV AX, [SI]  ; Cargamos la direccion conocida 70008h en AX (comprobado con el turbodebugger)
  MOV BP, 0H
  MOV BX, [BP]+10 ; Cargamos la direccion conocida 70010h en BX (comprobado con el turbodebugger)
  ; FIN DEL PROGRAMA
  MOV AX, 4C00H
  INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
