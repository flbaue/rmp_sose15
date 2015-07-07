;********************************************

	IMPORT Delay

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 2
	
ADC3_DR    		equ		0x4001224C

PERIPH_BASE     equ		0x40000000
AHB1PERIPH_BASE equ		(PERIPH_BASE + 0x00020000)
GPIOE_BASE      equ		(AHB1PERIPH_BASE + 0x1000)
GPIOG_BASE      equ		(AHB1PERIPH_BASE + 0x1800)
GPIO_G_SET		equ		GPIOG_BASE + 0x18
GPIO_G_CLR		equ		GPIOG_BASE + 0x1A

;          RN: Direktive, um Registern ‘Namen’ zu geben
adc_wert   RN   7	; Wert!!!
adc_dr	   RN	8	; Adresse!!	
gpio_set   RN   9
gpio_clr   RN   10
;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA MyCode, CODE, readonly, align = 2

;--------------------------------------------
; main subroutine
;--------------------------------------------
	GLOBAL mainASM
	
	
mainASM	PROC
        
; I/O-Adressen in Registern speichern
		ldr     adc_dr, 	=ADC3_DR        ; Adresse des ADC
		ldr     gpio_clr, 	=GPIO_G_CLR		; I/O löschen
		ldr     gpio_set, 	=GPIO_G_SET		; I/O setzen


messschleife
		


; auszugebendes, binäres Bitmuster ermitteln 

		
FOR_2 	
		mov     R1, #0
		mov 	R2, #15
		mov 	R3, #0
		
UNTIL_2
		cmp 	R1, R2
		beq		ENDFOR_2
DO_2	
		ldr     adc_wert, [adc_dr]					; Messwert lesen

		add     R3, adc_wert		 				; ADC-Wert (12 bit) lesen ...

STEP_2	
		add R1, #1
		b UNTIL_2

ENDFOR_2

		mov 	R3, R3, LSR #4
		mov     R4, R3, LSR #8						; und auf 4 Bit reduzieren
		
FOR_01
		mov 	R1, #0	; for-counter
		mov		R2, R4	; for-ende
		mov		R6, #0	;leds
UNTIL_01
		cmp R1, R2
		beq ENDDO_01
DO_01
		mov R6, R6, LSL #1
		add R6, #1
		add R1, #1
		b UNTIL_01
ENDDO_01
		
; LED Ausgabe				
		mov     R5, #0xffff
		strh    R5, [gpio_clr]	; LEDs löschen
		strh    R6, [gpio_set]	; Ausgabe Bitmuster
	
	
		mov     R0, #0x20
		bl      Delay
		
		b       messschleife



forever	b		forever			; nowhere to retun if main ends		
	ENDP
	
	ALIGN 4
	END
	
		