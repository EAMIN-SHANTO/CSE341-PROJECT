.MODEL SMALL
.STACK 100H

.DATA
; Menu messages
MSG1 DB 'Welcome to Appointment System$'
MSG2 DB 0DH,0AH,'1. View Slots$'
MSG3 DB 0DH,0AH,'2. Book Slot$'
MSG4 DB 0DH,0AH,'3. View Bookings$'
MSG5 DB 0DH,0AH,'4. Exit$'
MSG6 DB 0DH,0AH,'Enter Choice: $'
MSG7 DB 0DH,0AH,'Invalid Choice!$'
NEWLINE DB 0DH,0AH,'$'

; Slot messages
SLOT_MSG DB 0DH,0AH,'Available Slots:$'
SLOT1 DB 0DH,0AH,'1. 9:00 AM - $'
SLOT2 DB 0DH,0AH,'2. 10:00 AM - $'
SLOT3 DB 0DH,0AH,'3. 11:00 AM - $'
SLOT4 DB 0DH,0AH,'4. 12:00 PM - $'

; Status messages
FREE DB 'Free$'
BOOKED DB 'Booked$'

; Booking messages
INPUT_MSG DB 0DH,0AH,'Enter slot number (1-4): $'
NAME_MSG DB 0DH,0AH,'Enter your name: $'
SUCCESS_MSG DB 0DH,0AH,'Booking Successful!$'
ERROR_MSG DB 0DH,0AH,'Invalid Slot or Already Booked!$'

; Variables
CHOICE DB ?
SLOT_NUM DB ?
SLOT_STATUS DB 4 DUP(0)  ; 0=free, 1=booked
NAME1 DB 20 DUP('$')
NAME2 DB 20 DUP('$')
NAME3 DB 20 DUP('$')
NAME4 DB 20 DUP('$')

.CODE
MAIN PROC
    ; Initialize DS
    MOV AX,@DATA
    MOV DS,AX
    
MENU:
    ; Display menu
    LEA DX,MSG1
    MOV AH,9
    INT 21H
    
    LEA DX,MSG2
    MOV AH,9
    INT 21H
    
    LEA DX,MSG3
    MOV AH,9
    INT 21H
    
    LEA DX,MSG4
    MOV AH,9
    INT 21H
    
    LEA DX,MSG5
    MOV AH,9
    INT 21H
    
    LEA DX,MSG6
    MOV AH,9
    INT 21H
    
    ; Get choice
    MOV AH,1
    INT 21H
    SUB AL,30H
    MOV CHOICE,AL
    
    ; Check choice
    CMP AL,1
    JE VIEW_SLOTS
    CMP AL,2
    JE BOOK_SLOT
    CMP AL,3
    JE VIEW_BOOKINGS
    CMP AL,4
    JE EXIT
    
    ; Invalid choice
    LEA DX,MSG7
    MOV AH,9
    INT 21H
    JMP MENU

VIEW_SLOTS:
    ; Display slots header
    LEA DX,SLOT_MSG
    MOV AH,9
    INT 21H
    
    ; Display Slot 1
    LEA DX,SLOT1
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[0]
    CMP BL,0
    JE FREE1
    LEA DX,BOOKED
    JMP NEXT1
FREE1:
    LEA DX,FREE
NEXT1:
    MOV AH,9
    INT 21H
    
    ; Display Slot 2
    LEA DX,SLOT2
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[1]
    CMP BL,0
    JE FREE2
    LEA DX,BOOKED
    JMP NEXT2
FREE2:
    LEA DX,FREE
NEXT2:
    MOV AH,9
    INT 21H
    
    ; Display Slot 3
    LEA DX,SLOT3
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[2]
    CMP BL,0
    JE FREE3
    LEA DX,BOOKED
    JMP NEXT3
FREE3:
    LEA DX,FREE
NEXT3:
    MOV AH,9
    INT 21H
    
    ; Display Slot 4
    LEA DX,SLOT4
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[3]
    CMP BL,0
    JE FREE4
    LEA DX,BOOKED
    JMP NEXT4
FREE4:
    LEA DX,FREE
NEXT4:
    MOV AH,9
    INT 21H
    
    LEA DX,NEWLINE
    MOV AH,9
    INT 21H
    JMP MENU

BOOK_SLOT:
    ; Display slots header
    LEA DX,SLOT_MSG
    MOV AH,9
    INT 21H
    
    ; Display Slot 1
    LEA DX,SLOT1
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[0]
    CMP BL,0
    JE FREE1_BOOK
    LEA DX,BOOKED
    JMP NEXT1_BOOK
FREE1_BOOK:
    LEA DX,FREE
NEXT1_BOOK:
    MOV AH,9
    INT 21H
    
    ; Display Slot 2
    LEA DX,SLOT2
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[1]
    CMP BL,0
    JE FREE2_BOOK
    LEA DX,BOOKED
    JMP NEXT2_BOOK
FREE2_BOOK:
    LEA DX,FREE
NEXT2_BOOK:
    MOV AH,9
    INT 21H
    
    ; Display Slot 3
    LEA DX,SLOT3
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[2]
    CMP BL,0
    JE FREE3_BOOK
    LEA DX,BOOKED
    JMP NEXT3_BOOK
FREE3_BOOK:
    LEA DX,FREE
NEXT3_BOOK:
    MOV AH,9
    INT 21H
    
    ; Display Slot 4
    LEA DX,SLOT4
    MOV AH,9
    INT 21H
    
    MOV BL,SLOT_STATUS[3]
    CMP BL,0
    JE FREE4_BOOK
    LEA DX,BOOKED
    JMP NEXT4_BOOK
FREE4_BOOK:
    LEA DX,FREE
NEXT4_BOOK:
    MOV AH,9
    INT 21H
    
    ; Get slot number
    LEA DX,INPUT_MSG
    MOV AH,9
    INT 21H
    
    MOV AH,1
    INT 21H
    SUB AL,31H     ; Convert 1-4 to 0-3
    MOV SLOT_NUM,AL
    
    ; Validate slot number
    CMP AL,0
    JL INVALID_INPUT
    CMP AL,3
    JG INVALID_INPUT
    
    ; Check if slot is available
    MOV BL,AL
    MOV BH,0
    CMP SLOT_STATUS[BX],0
    JNE INVALID_INPUT
    
    ; Get name
    LEA DX,NAME_MSG
    MOV AH,9
    INT 21H
    
    ; Determine which name buffer to use
    CMP BL,0
    JE USE_NAME1
    CMP BL,1
    JE USE_NAME2
    CMP BL,2
    JE USE_NAME3
    JMP USE_NAME4
    
USE_NAME1:
    LEA DI,NAME1
    JMP READ_NAME
USE_NAME2:
    LEA DI,NAME2
    JMP READ_NAME
USE_NAME3:
    LEA DI,NAME3
    JMP READ_NAME
USE_NAME4:
    LEA DI,NAME4
    
READ_NAME:
    MOV CX,19      ; Max 19 chars
READ_LOOP:
    MOV AH,1
    INT 21H
    CMP AL,0DH     ; Check for Enter
    JE DONE_READING
    MOV [DI],AL
    INC DI
    LOOP READ_LOOP
    
DONE_READING:
    MOV BYTE PTR [DI],'$'  ; String terminator
    
    ; Mark slot as booked
    MOV SLOT_STATUS[BX],1
    
    ; Show success message
    LEA DX,SUCCESS_MSG
    MOV AH,9
    INT 21H
    JMP MENU
    
INVALID_INPUT:
    LEA DX,ERROR_MSG
    MOV AH,9
    INT 21H
    JMP MENU

VIEW_BOOKINGS:
    ; Display booked slots
    LEA DX,SLOT_MSG
    MOV AH,9
    INT 21H
    
    ; Check Slot 1
    MOV AL,SLOT_STATUS[0]
    CMP AL,1
    JNE CHECK_SLOT2
    LEA DX,SLOT1
    MOV AH,9
    INT 21H
    LEA DX,NAME1
    MOV AH,9
    INT 21H
    
CHECK_SLOT2:
    MOV AL,SLOT_STATUS[1]
    CMP AL,1
    JNE CHECK_SLOT3
    LEA DX,SLOT2
    MOV AH,9
    INT 21H
    LEA DX,NAME2
    MOV AH,9
    INT 21H
    
CHECK_SLOT3:
    MOV AL,SLOT_STATUS[2]
    CMP AL,1
    JNE CHECK_SLOT4
    LEA DX,SLOT3
    MOV AH,9
    INT 21H
    LEA DX,NAME3
    MOV AH,9
    INT 21H
    
CHECK_SLOT4:
    MOV AL,SLOT_STATUS[3]
    CMP AL,1
    JNE DONE_VIEW
    LEA DX,SLOT4
    MOV AH,9
    INT 21H
    LEA DX,NAME4
    MOV AH,9
    INT 21H
    
DONE_VIEW:
    LEA DX,NEWLINE
    MOV AH,9
    INT 21H
    JMP MENU

EXIT:
    MOV AX,4C00H
    INT 21H

MAIN ENDP
    END MAIN 