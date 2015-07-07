;**************************************************************


		IMPORT	TFT_puts
		IMPORT  TFT_cls
		IMPORT  TFT_gotoxy
		IMPORT  Delay

;********************************************
; Data section, aligned on 4-byte boundary
;********************************************
	
	AREA MyData, DATA, align = 2
	
ADC3_DR         equ	     0x4001224C

PERIPH_BASE     equ      0x40000000
AHB1PERIPH_BASE equ      (PERIPH_BASE + 0x00020000)
	
;blaue LEDs: output
GPIOG_BASE      equ      (AHB1PERIPH_BASE + 0x1800)
GPIO_G_SET		equ      GPIOG_BASE + 0x18
GPIO_G_CLR		equ      GPIOG_BASE + 0x1A
GPIO_G_PIN		equ      GPIOG_BASE + 0x10

;rote LEDs / Taster: input
GPIOE_BASE      equ      (AHB1PERIPH_BASE + 0x1000)
GPIO_E_PIN      equ      GPIOE_BASE + 0x10

Start_Text  	DCB     "Zum Starten  - die S7 Taste druecken\0"
Achtung_Text	DCB		"Achtung !!!\0"
Stop_Text    	DCB     "Stopped\0"



;********************************************
; Code section, aligned on 4-byte boundary
;********************************************

	AREA MyCode, CODE, readonly, align = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
			GLOBAL mainASM
			
	
;---------------------------------------------------
;--- Testet ob die S0 Taste gedrueckt wurde
;--- in:  void
;--- out: R0 = 0  S0 Taste wurde nicht gedrueckt
;--- out: R0 = 1  S0 Taste wurde gedrueckt
;!!!! für Aufgabe 3 nach S7 ändern!!!!
;---------------------------------------------------
testIfPushButtonPressed

            push {R2-R4,LR}			;gerade Anzahl von Registern!	           
			
			mov R0, #0x00			;default Wert
			ldr R3, =GPIO_E_PIN		;Tasten lesen
			ldr R4, [R3]
		 	and R4, #0x80			;S0 maskieren --> S7!
		    cmp	R4, #0					;S0 testen    --> S7!
			moveq R0, #1
			
							;Achtung: invertierte Logik:
									;Taster gedrückt -> Pin ist 0
									;achten Sie mal auf die zum Taster gehörende LED
			
			pop {R2-R4,LR}           
			bx   LR
	
	
;---------------------------------------------------
;--- Laesst die Anzahl LEDs leuchten, die in R0 steht  
;--- in:  R0 = Anzahl LEDs
;--- out: void
;---------------------------------------------------	
outputLEDBar
            push {R1-R5, LR}			;gerade Anzahl von Registern!	
		  
			ldr  R3, =GPIO_G_CLR	;alle LEDs loeschen
			mov  R4, #0xffff
			strh R4, [R3]
			
;LED Muster erzeugen
FOR_01
		mov 	R1, #0	; for-counter
		mov		R2, R0	; for-ende
		mov		R4, #0	;leds
UNTIL_01
		cmp R1, R2
		beq ENDDO_01
DO_01
		mov R4, R4, LSL #1
		add R4, #1
		add R1, #1
		b UNTIL_01
ENDDO_01
			
		    ldr  R3, =GPIO_G_SET	;LEDs anzeigen
		    strh R4, [R3]
			
		    pop  {R1-R5, LR}
			bx   LR
		
;---------------------------------------------------
;--- Ermittelt ob alle LEDs leuchten
;--- in:  void
;--- out: R0 = 0 Sie leuchten nicht alle
;--- out: R0 = 1 Sie leuchten alle
;---------------------------------------------------			
LEDBarEndReached
			push {R1-R5, LR}		  ;gerade Anzahl von Registern!	
			
			mov R0, #0x01         ;default Wert
			ldr R3, =GPIO_G_PIN   ;LEDs lesen
			ldr R4, [R3]
			ldr R5, =0xffff
		 	and R4, R5            ;LEDs maskieren 
		    cmp R4, R5				  ;LEDs testen
			movne R0, #0
			
			pop {R1-R5, LR}
			bx   LR
			
;---------------------------------------------------
;--- Delay, ohne dass sich Register aendern
;--- in:  R0 = Millisekunden
;--- out: void
;---------------------------------------------------			
SafeDelay
			push {R0-R4, LR}		  ;gerade Anzahl von Registern!

            bl    Delay

			pop  {R0-R4,LR}
			bx    LR

;---------------------------------------------------
;--- TFT_cls, ohne dass sich Register aendern
;--- in:  void
;--- out: void
;---------------------------------------------------			
SafeTFT_cls
			push {R0-R4, LR}		  ;gerade Anzahl von Registern!

            bl    TFT_cls

			pop  {R0-R4, LR}
			bx    LR

;---------------------------------------------------
;--- TFT_gotoxy, ohne dass sich Register aendern
;--- in:  R0 = x-Koordinate
;--- in:  R1 = y-Koordinate
;--- out: void
;---------------------------------------------------			
SafeTFT_gotoxy
			push {R0-R4, LR}		  ;gerade Anzahl von Registern!

            bl    TFT_gotoxy

			pop  {R0-R4, LR}
			bx    LR

;---------------------------------------------------
;--- TFT_puts, ohne dass sich Register aendern
;--- in:  R0 = Stringadresse
;--- out: void
;---------------------------------------------------			
SafeTFT_puts
			push {R0-R4, LR}		  ;gerade Anzahl von Registern!

            bl    TFT_puts

			pop  {R0-R4, LR}
			bx    LR

;---------------------------------------------------
;--- Gibt Text auf dem Bildschirm aus
;--- in:  R0 = Adresse des Textes
;--- in:  R1 = x Koordinate (1..40)
;--- in:  R2 = y Koordinate (1..16) 
;--- out: void
;---------------------------------------------------	
SafeTFT
            push {R0-R4, LR}		  			;gerade Anzahl von Registern!
			
			mov R4, R0						;Adresse des Strings sichern	
            bl  SafeTFT_cls					;TFT loeschen
			mov R0, R1						;Cursor positionieren
			mov R1, R2
			bl  SafeTFT_gotoxy
			mov R0, R4						;Text anzeigen
			bl	SafeTFT_puts
			
			pop  {R0-R4, LR}
			bx    LR
			
			
;-------------------------------------------------------------------------------------------------	
mainASM		PROC
;Dies ist die Hauptaufgabe; nur 3 Codeschnipsel für die Anwendung der Bibliothek
			
			mov r0, #0
			bl outputLEDBar

MAIN_LOOP								
			ldr R0, =Start_Text				;Starttext anzeigen
			mov R1, #2
			mov R2, #7
			bl	SafeTFT
			

IS_PRESSED_LOOP
			bl testIfPushButtonPressed
			cmp R0, #1
			bne IS_PRESSED_LOOP
			
			
			ldr R0, =Achtung_Text				;Achtung anzeigen
			mov R1, #2
			mov R2, #7
			bl	SafeTFT
			
			;LEDS löschen
			mov r0, #0
			bl outputLEDBar
			
			
			mov R0, #3000					;3s warten
			bl  SafeDelay
			
			
			mov R1, #0 ;Balkenlänge (Anzahl leuchtender LEDs)
GAME_LOOP
			cmp R1, #16
			beq END_GAME_LOOP
			
			;taste abfragen
			bl testIfPushButtonPressed
IF_01		cmp R0, #1			
			bne ELSE_01
THAN_01
			mov R1, #16
			b ENDIF_01
ELSE_01
			mov  R0, #20					;20ms warten
			bl   SafeDelay
			add R1, #1
			mov r0, R1
			bl outputLEDBar
ENDIF_01
			b GAME_LOOP
					    	
END_GAME_LOOP

			ldr R0, =Stop_Text				;Achtung anzeigen
			mov R1, #2
			mov R2, #7
			bl	SafeTFT
			
			mov R0, #3000					;3s warten
			bl  SafeDelay
			
			b MAIN_LOOP

		
forever		b		forever			; nowhere to retun if main ends		



			ENDP
	
			ALIGN 4
			END
	
		