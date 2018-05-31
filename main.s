
SCB_AIRCR       EQU     0xE000E000
NVIC_BASE       EQU     0xE000E100
NVIC_ISER1		EQU		(NVIC_BASE + 0X0000);ʹŜ
NVIC_ISER2		EQU		(NVIC_BASE + 0X0004)
NVIC_ICER1		EQU		(NVIC_BASE + 0X0080);ԽŜ
NVIC_ICER2		EQU		(NVIC_BASE + 0X0084)
NVIC_ISPR1		EQU		(NVIC_BASE + 0X0100);pendingλ׃λ
NVIC_ISPR2		EQU		(NVIC_BASE + 0X0104)
NVIC_ICPR1		EQU		(NVIC_BASE + 0X0180);pendingλȥλ
NVIC_ICPR2		EQU		(NVIC_BASE + 0X0184)
NVIC_IABR1		EQU		(NVIC_BASE + 0X0200);א׏ܮ֯״̬݄զǷ
NVIC_IABR2		EQU		(NVIC_BASE + 0X0204)
NVIC_IPR_BASE	EQU		(NVIC_BASE + 0X0300);א׏ԅЈ݄ܶզǷ
AFIO_EXTICR1  	EQU 0X40010008

EXTI_IMR				EQU 0x40010400
EXTI_EMR				EQU 0x40010404
EXTI_RTSR				EQU 0x40010408
EXTI_FTSR				EQU 0x4001040C
EXTI_PR					EQU	0X40010414
NVIC_ST_CTRL_R    EQU 0xE000E010
NVIC_ST_RELOAD_R  EQU 0xE000E014 
NVIC_ST_CURRENT_R EQU 0xE000E018	
BIT0   EQU 0X00000001
BIT2   EQU 0X00000004
BIT5   EQU 0X00000020 
BIT8   EQU 0X00000100
BIT9   EQU 0X00000200
BIT10  EQU 0X00000400
BIT11  EQU 0X00000800
LED0   EQU BIT8     ;LED3--PA.0
LED1   EQU BIT9     ;LED1--PA.1
LED2   EQU BIT10    ;LED2--PA.2
LED3   EQU BIT11
GPIOD      EQU 0X40011400  ;GPIOA ַ֘
GPIOD_CRL  EQU 0X40011400  ;֍Ƥ׃݄զǷ
GPIOD_CRH  EQU 0X40011404  ;ٟƤ׃݄զǷ
GPIOD_ODR  EQU 0X4001140C  ;ˤԶìƫӆַ֘0Ch
GPIOD_BSRR EQU 0X40011410  ;֍׃λìٟȥԽƫӆַ֘10h
GPIOD_BRR  EQU 0X40011414  ;ȥԽìƫӆַ֘14h
IOPDEN     EQU BIT5     ;GPIOAʹŜλ
IOPAEN	   EQU BIT2 ;GPIOAʹŜλ
GPIOA 	   EQU 0X40010800
GPIOA_CRL  EQU 0X40010800  ;֍Ƥ׃݄զǷ
GPIOA_IDR  EQU 0X40010808
GPIOA_ODR  EQU 0X4001140C 
RCC_APB2ENR EQU 0X40021018

STACK_TOP EQU 0X20002000 
	AREA RESET,CODE,READONLY   ;AREAһŜ֥ٱд
	DCD STACK_TOP      ; MSPԵʼֵ 
	DCD Start       ; شλв 
	ENTRY 
Start        ; ׷ԌѲߪʼ ; Եʼۯٷ݄զǷ 
	BL.W   RCC_CONFIG_72MHZ ;ָ®һŜ֥ٱд
    BL.W   SysTick_Init
	LDR    R1,=RCC_APB2ENR
	LDR    R0,[R1]     ;ׁ
	LDR    R2,=IOPDEN
	ORR    R0,R2  ;ل
    LDR    R2,=IOPAEN
	ORR    R0,R2  ;ل
	STR    R0,[R1]  ;дìʹŜGPIOA Dʱד
	
	MOV    R0,#0x8
	LDR    R1,=GPIOA_CRL  ;PA0՚֍݄զǷ
	STR    R0,[R1]
	LDR    R1,=GPIOA_ODR
	MOV	   R2,#1
	STR    R2,[R1]
	
	;LED0--PA.0 ΆάˤԶì50MHz
	;LED1--PA.1  ΆάˤԶì50MHz
	;LED2--PA.2  ΆάˤԶì50MHz
	LDR    R0,=0x3333
	LDR    R1,=GPIOD_CRH  ;PA.1\2\3߹՚֍݄զǷ
	STR    R0,[R1]
	LDR    R1,=GPIOD_ODR
    LDR    R2,=0x00000F00 ;ݫPA.1\2\3ˤԶٟ֧ƽ
	STR    R2,[R1]
	
	LDR r0, =SCB_AIRCR
	LDR r1, =0x05FA0000 ; Փλ0Ԧۮؖèٲ7ٶλҭկȀռԅЈܶé
	STR R1, [r0]
	LDR	R1,=NVIC_ISER1	
	MOV R2,#0X40
	STR	R2,[R1]
	LDR	R1,=NVIC_IPR_BASE
	MOV R2,#0X00
	STR	R2,[R1]
	LDR	R1,=AFIO_EXTICR1
	MOV	R2,#0X40
	STR	R2,[R1]

	LDR	R4,=EXTI_IMR
	MOV    R3,#0X01
	STR    R3,[R4]
	LDR	R4,=EXTI_EMR
	MOV    R3,#0X01
	STR    R3,[R4]
	LDR	R4,=EXTI_FTSR
	MOV    R3,#0X01
	STR    R3,[R4]
	LDR	R4,=EXTI_PR;ȥԽҪ־λ
	MOV    R3,#0X01
	STR    R3,[R4]

LOOP
	LDR    R0,=7200000  
	BL.W   SysTick_Wait
	LDR    R1,=GPIOD_ODR
	EOR	   R7,#0XF00
	STR    R7,[R1]
	B      LOOP    ;݌Ѹѭ۷
	
	
EXTI0_IRQHandler
	LDR	   R6,=EXTI_PR
	MOV    R3,#0X01
	STR    R3,[R6]
;	LDR    R1,=GPIOD_ODR
;	LDR	   R7,=0X100
;	STR    R7,[R1]
	B      LOOP
	BX 	   LR

;;;RCC  ʱדƤ׃ HCLK=72MHz=HSE*9
;;;PCLK2=HCLK  PCLK1=HCLK/2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RCC_CONFIG_72MHZ
 LDR    R1,=0X40021000 ;RCC_CR
 LDR    R0,[R1]
 LDR    R2,=0X00010000 ;HSEON
 ORR    R0,R2
 STR    R0,[R1]
WAIT_HSE_RDY
 LDR    R2,=0X00020000 ;HSERDY
 LDR    R0,[R1]
 ANDS   R0,R2
 CMP    R0,#0
 BEQ    WAIT_HSE_RDY
 LDR    R1,=0X40022000 ;FLASH_ACR
 MOV    R0,#0X12
 STR    R0,[R1]
 LDR    R1,=0X40021004 ;RCC_CFGRʱדƤ׃݄զǷ
 LDR    R0,[R1]
 LDR    R2,=0x001D0400 
 ORR    R0,R2
 STR    R0,[R1]
 LDR    R1,=0X40021000 ;RCC_CR  
 LDR    R0,[R1]
 LDR    R2,=0X01000000 ;PLLON
 ORR    R0,R2
 STR    R0,[R1]
WAIT_PLL_RDY
 LDR    R2,=0X02000000 ;PLLRDY
 LDR    R0,[R1]
 ANDS   R0,R2
 CMP    R0,#0
 BEQ    WAIT_PLL_RDY
 LDR    R1,=0X40021004 ;RCC_CFGR
 LDR    R0,[R1]
 MOV    R2,#0X02
 ORR    R0,R2
 STR    R0,[R1]
WAIT_HCLK_USEPLL
 LDR    R0,[R1]
 ANDS   R0,#0X08
 CMP    R0,#0X08
 BNE    WAIT_HCLK_USEPLL
 BX LR  
 
SysTick_Init
; disable SysTick during setup
    LDR R1, =NVIC_ST_CTRL_R
    MOV R0, #0            ; Clear Enable         
    STR R0, [R1] 
; set reload to maximum reload value
    LDR R1, =NVIC_ST_RELOAD_R 
    LDR R0, =0x00FFFFFF;    ; Specify RELOAD value
    STR R0, [R1]            ; reload at maximum       
; writing any value to CURRENT clears it
    LDR R1, =NVIC_ST_CURRENT_R 
    MOV R0, #0              
    STR R0, [R1]            ; clear counter
; enable SysTick with core clock
    LDR R1, =NVIC_ST_CTRL_R    
    MOV R0, #0x0005    ; Enable but no interrupts (later)
    STR R0, [R1]       ; ENABLE and CLK_SRC bits set
    BX  LR 

SysTick_Wait
    SUB  R0, R0, #1   ; delay-1
    LDR  R6, =NVIC_ST_RELOAD_R  
    STR  R0, [R6]     ; time to wait
    LDR  R6, =NVIC_ST_CURRENT_R  
    STR  R0, [R6]     ; any value written to CURRENT clears
    LDR  R6, =NVIC_ST_CTRL_R  
SysTick_Wait_loop
    LDR  R0, [R6]     ; read status
    ANDS R0, R0, #0x00010000 ; bit 16 is COUNT flag
    BEQ  SysTick_Wait_loop   ; repeat until flag set
    BX   LR 

	END