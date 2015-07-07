    AREA MyCode, CODE, readonly, align = 2
    
    GLOBAL getNum_asm
;--------------------------------------------
;Inputregister : r0 (Stringadresse)
;Outputregister : r0 (Zahlenwert)
;Verwendete Register retten und restaurieren.
;--------------------------------------------

getNum_asm  PROC

    push {R1-R5, LR}

    mov R2, #0; char index
    mov R4, #0; wert

DO  ldrb R1, [R0, R2] ;lade nächsten char

IF  cmp R1, #0x30 ;prüfe ob char zwischen '0' und '9' liegt
    blo END_IF
    cmp R1, #0x39
    bhi END_IF

THEN 
    ;formel: (X = x * 10 + (current_char – 0x30)
    mov R5, #10
    mul R4, R5 ; multipiliere Wert mit 10
    sub R5, R1, #0x30 ; ermittle Wert des aktuellen chars
    add R4, R5  ; addiere Wert des aktuellen chars auf 
    
END_IF
   
    add R2, #1 ;char index erhöhen
WHILE
    cmp R1, #0 ; solange bis char \0 ist
    bne DO
    
    mov R0, R4 ; ermittelten Wert in R0 speichern und zurückgeben
    
    pop {R1-R5, LR}


    bx  lr

;--------------------------------------------

    ENDP
    ALIGN 4
;GANZ WICHTIG !!!
    END
        