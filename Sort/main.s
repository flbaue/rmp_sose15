;********************************************
; useful definitions
;********************************************

TRUE		EQU 	1
FALSE		EQU		0
DATASIZE	EQU		4	; Byte=1, Halbwort=2, Wort=4 

;********************************************
; Data section, aligned on 16-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 4

DataList		DCD       	35, -1, 13, -4096, 511, 101, -3, -5, 0, 65
DataListEnd		DCD			0

	GLOBAL	DataList    
	GLOBAL	DataListEnd  
	

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA MyCode, CODE, readonly, align =2
	GLOBAL main

	
main	PROC

	
						
	mov		R0,#TRUE
	ldr		R4,=DataListEnd

WHILE_1		cmp	R0,#TRUE
			bne ENDWHILE_1
			
DO_1		mov R0,#FALSE
			LDR R3,=DataList
			
WHILE_2		cmp R3,R4
			beq ENDWHILE_2
			
DO_2		ldr R1,[R3]
			ldr R2,[R3,#4]
			
IF_1		cmp R1,R2
			ble ENDIF_1
			
THEN_1		str R1,[R3,#4]
			str R2,[R3]
			mov R0,#TRUE
						
ENDIF_1		add R3,#4
			b WHILE_2
ENDWHILE_2	
			b WHILE_1
ENDWHILE_1


forever	b		forever			; nowhere to retun if main ends		
	ENDP
	
	ALIGN 4
	END