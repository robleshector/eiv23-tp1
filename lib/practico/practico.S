/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros R0 a R12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros R0 a R3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros R0 a R3 y el
 * registro R12 pueden cambiar su valor (y en particular, R0 contiene 
 * normalmente el valor devuelto), los registros R4 a R11 preservan
 * su valor.
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * Sumar dos enteros de 32 bit
 *  suma(2,3) => 5
 * Entrada
 *  a->R0, b->R1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  R0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}
    // Insertar código a continuación
    ADD R0, R1 
    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->R0    : Cantidad de números en registro R0, entero de 32 bit
 *  b->R1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  R1:R0 : Sumatoria, entero de 64 bit con signo 
 */
defun sumatoria
    push {r4-r11,lr}
    // Insertar código a continuación
    
    // Retorno, antes R1:R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun sumatoria

/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->R0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  R0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */
defun posicion_maximo
    push {r4-r11,lr}
    // Insertar código a continuación
    ADD
    add
    add
    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7};
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->R0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    // Insertar código a continuación
    SUB R5,R0,#1 // R5 = k = n-1 (Variable local)
MOV R4,R1 // R4 = R1 = b (Variable local)
0:
CMP R5,#0 // Comparo k con 0
BLE 1f // Si k<=0, salto a la etiqueta 1
ADD R0,R5,#1 // R0 = k+1, cargo el valor necesario antes del salto
MOV R1,R4 // R1 = b, cargo el valor necesario antes del salto
BL posicion_maximo //Llamo a posicion_maximo (Ahora R0 = j)
/*Como R1 no almacena ningun resultado, puede usarse para almacenar
variables temporales*/
LDR R1,[R4,R5,LSL #2] // Cargo en R1 (x) el valor en la posicion "R4+R5*4" (b[k])
LDR R6,[R4,R0,LSL #2] // Cargo en R6 el valor en la posición "R4+R0*4" (b[j])
STR R6,[R4,R5,LSL #2] // Guardo b[j] en la posición "R4+R5*4" (b[k])
STR R1,[R4,R0,LSL #2] // Guardo R1 (x) en la posición "R4+R0*4" (b[j])
SUB R5,#1 // k = k-1
B 0b // Salto a la etiqueta 0
1:
    // Retorno
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
