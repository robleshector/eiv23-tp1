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
    mov r3,#0   //cargamos cero de A
    mov r2,#0   //cargamos cero de A

    mov r4,#0   //cargamos cero de i

    0:  // etiqueta
        cmp r4, R0  // banderas <- r4 -r0     (compara r4 y r0).  
        bge 1f  // si r4 mayor igual que r0, salta a la etiqueta 1
        
    ldr r5,[r1,r4,lsl#2] //cargamos r5 con r1+r4*(2 a la n) = r4*4        
    asr r6, r5,#31  // entension con signo a 64 bits de (ext de r5 y se guarda en r6)

    adds r2,r5   // r2 <- r2+r5  afecta la bandera 
    adc r3,r6  // r3 <- r3+r6  suma con acarreo

    add r4,#1   //r4 + 1

    B 0b  //salto a la etiqueta 0

    1:   //etiqueta 
        mov r1,r3
        mov r0,r2

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
    mov r2,#0

    cmp r0,#1
    bls 0f

    ldr r4,[r1,r2,lsl#2]

    mov r3,#1

    1:
        cmp r3,r0
        bge 0f
    ldr r5,[r1,r3,lsl#2]
    cmp r4,r5
    bge 2f

mov r4,r5
mov r2,r3

    2:
        add r3,#1
        B 1b
0:
    mov r0,r2
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
  sub r5,r0,#1
  mov r4,r1 
 
0:
    cmp r5,#0
    ble 1f

    add r0,r5,#1
    mov r1, r4 
    
    BL posicion_maximo

    ldr r1,[r4,r5,lsl#2]

    ldr r6,[r4,r0,lsl#2]

    str r6,[r4,r5,lsl#2]

    str r1,[r4,r0,lsl#2]
    sub r5,#1

    B 0b                

1:
    // Retorno
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
