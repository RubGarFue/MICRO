;_______________________________________________________________
; ASIGNATURA: Sistemas basados en Microprocesadores
; CURSO: 3º Doble grado Ingeniería Informática y Matemáticas
; GRUPO: 2301
; NOMBRE: Rubén García de la Fuente
;_______________________________________________________________
;**************************************************************************
; SBM 2020. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
  MARCADOR  DB  0 ; Variable marcador de un byte de tamano
  BEBE      DB  11001010B,11111110B ; Para que no de error, pasamos CAFE a binario y lo guardamos en dos bytes en la variable BEBE
  TABLA200  DB  200 DUP (0) ; Inicializamos una tabla de 200 bytes a 0
  ERRORTOTAL1 DB  "Este programa se cuelga siempre."  ; Guardamos la cadena de texto indicada
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
  MOV CL, ERRORTOTAL1[2]  ; Guardamos el 3 caracter del string ERRORTOTAL1 en el registro CL
  MOV TABLA200[63H], CL ; Guardamos CL en la posición 64H de TABLA200
  MOV CX, WORD PTR BEBE ; Guardamos la variable BEBE en CX indicando que queremos 1 palabra (2 bytes)
  MOV WORD PTR TABLA200[23H], CX  ; Guardamos CX en la posicion 23H de TABLA200 indicando que queremos 1 palabra (2 bytes)
  MOV CL, BEBE  ; Guardamos la variable BEBE en el registro CL cogiendo el byte más significativo
  MOV MARCADOR, CL  ; Guardamos CL en la variable MARCADOR
  ; FIN DEL PROGRAMA
  MOV AX, 4C00H
  INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
