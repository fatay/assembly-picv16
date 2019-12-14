;LM35 sıcaklık sensörü kullanılarak bir klima kontrol algoritması kodlayınız.
;Ortam sıcaklığını LCD displayde gösteriniz. 2 adet buton ile referans sıcaklığı arttırıp azaltınız. 
;İşlemcinin hangi portlarını kullanacağınızı kendiniz belirleyiniz. 
;Sistemin çalışmasını PROTEUS ortamında test edeceksiniz. 
;Klimanın motorunun temsilen bir adet I/O pinine bağlı ledi yakıp söndürünüz. 
;Eğer ortam sıcaklığı referans sıcaklıktan daha büyükse ledi yakınız. Aksi durumda söndürünüz. 
;Hem ortam hem de hedef sıcaklık LCD de görüntülenmelidir.


	LIST P=16F877A
	#INCLUDE <P16F877A.INC>
	DEGER EQU 0X20
	DEGER2 EQU 0X21
	TEMP EQU 0X22
	BIRLER EQU 0X23
	ONLAR EQU 0X24
	YUZLER EQU 0X25
	OKUNAN_DEGER EQU 0X26
	REFERANS    EQU 0X27

	ORG 0X00
	GOTO MAIN
MAIN
	BANKSEL TRISB
	CLRF TRISB	
	BANKSEL ADCON0
	MOVLW B'11000001'
	MOVWF ADCON0
	BANKSEL ADCON1
	MOVLW B'10001110'
	MOVWF ADCON1
	BANKSEL TRISA
	MOVLW 0XFF
	MOVWF TRISA
	MOVLW	B'00000011'
	MOVWF	TRISD
	BANKSEL PORTB
	CLRF PORTB
	CLRF PORTA
	CLRF	PORTD
	CLRF OKUNAN_DEGER
	BANKSEL  REFERANS
	MOVLW    D'25'
	MOVWF    REFERANS
TEMIZLE
	MOVLW 0X02
	CALL KOMUT_YAZ
	MOVLW 0X0F
	CALL KOMUT_YAZ
	MOVLW 0X80
	CALL KOMUT_YAZ
DONUSTUR
	BANKSEL ADCON0
	BSF ADCON0,GO
	CALL GECIKME
KONTROL
	BTFSC ADCON0,GO
	GOTO KONTROL
	BANKSEL ADRESL
	RRF ADRESL
	MOVF ADRESL,W
	BANKSEL OKUNAN_DEGER
	MOVWF OKUNAN_DEGER
	GOTO	KIYASLA
	E2
	GOTO	LOOP
KIYASLA
	BANKSEL	REFERANS
	SUBWF	REFERANS,W
	BANKSEL	PORTA
	BTFSS	STATUS,C
	GOTO	DUR
	GOTO	CALIS
DUR
	BANKSEL	PORTA
	BCF	PORTD,2
	GOTO	E2
CALIS	
	BANKSEL	PORTA
	BSF	PORTD,2
	GOTO	E2
ARTTIR
	BANKSEL	REFERANS
	INCF	REFERANS,F
	GOTO	LOOP
AZALT
	BANKSEL	REFERANS
	DECF	REFERANS,F
	GOTO	LOOP
LOOP
	CALL OKU
	MOVLW 0X02
	CALL KOMUT_YAZ
	
	
	MOVLW A'S'
	CALL VERI_YAZ
	MOVLW A'I'
	CALL VERI_YAZ
	MOVLW A'C'
	CALL VERI_YAZ
	MOVLW A'A'
	CALL VERI_YAZ
	MOVLW A'K'
	CALL VERI_YAZ
	MOVLW A'L'
	CALL VERI_YAZ
	MOVLW A'I'
	CALL VERI_YAZ
	MOVLW A'K'
	CALL VERI_YAZ
	MOVLW A':'
	CALL VERI_YAZ
	MOVF YUZLER,W
	CALL VERI_YAZ
	MOVF ONLAR,W
	CALL VERI_YAZ
	MOVF BIRLER,W
	CALL VERI_YAZ
	MOVLW A' '
	CALL VERI_YAZ
	MOVLW 0XDF
	CALL VERI_YAZ
	MOVLW A'C'
	CALL VERI_YAZ
	CALL GECIKME2
	
	MOVF	REFERANS,W
	MOVWF	OKUNAN_DEGER
	CALL OKU
	MOVLW 0X02
	CALL KOMUT_YAZ
	MOVLW 0X0C
	CALL KOMUT_YAZ
	MOVLW 0X28
	CALL KOMUT_YAZ
	MOVLW 0XC0
	CALL KOMUT_YAZ
	MOVLW A'R'
	CALL VERI_YAZ
	MOVLW A'E'
	CALL VERI_YAZ
	MOVLW A'F'
	CALL VERI_YAZ
	MOVLW A'E'
	CALL VERI_YAZ
	MOVLW A'R'
	CALL VERI_YAZ
	MOVLW A'A'
	CALL VERI_YAZ
	MOVLW A'N'
	CALL VERI_YAZ
	MOVLW A'S'
	CALL VERI_YAZ
	MOVLW A':'
	CALL VERI_YAZ
	MOVF YUZLER,W
	CALL VERI_YAZ
	MOVF ONLAR,W
	CALL VERI_YAZ
	MOVF BIRLER,W
	CALL VERI_YAZ
	MOVLW A' '
	CALL VERI_YAZ
	MOVLW 0XDF
	CALL VERI_YAZ
	MOVLW A'C'
	CALL VERI_YAZ
	CALL GECIKME2
	
	
	BTFSC    PORTD,0
	GOTO	ARTTIR
	BTFSC    PORTD,1
	GOTO	AZALT
	
	GOTO DONUSTUR

OKU
	CLRF YUZLER
	CLRF ONLAR
	CLRF BIRLER
	CLRF PORTB
	MOVF OKUNAN_DEGER,W	
YUZLER_ARTIR
	MOVLW D'100'
	SUBWF OKUNAN_DEGER,0
	BTFSS STATUS,C
	GOTO ONLAR_ARTIR
	MOVWF OKUNAN_DEGER
	INCF YUZLER,1
	GOTO YUZLER_ARTIR
ONLAR_ARTIR
	MOVLW D'10'
	SUBWF OKUNAN_DEGER,0
	BTFSS STATUS,C
	GOTO BIRLER_ARTIR
	MOVWF OKUNAN_DEGER
	INCF ONLAR,1
	GOTO ONLAR_ARTIR
BIRLER_ARTIR
	MOVF OKUNAN_DEGER,0
	MOVWF BIRLER
	
	MOVLW 0X30
	IORWF YUZLER,F
	IORWF ONLAR,F
	IORWF BIRLER,F
RETURN


KOMUT_YAZ
	MOVWF TEMP
	SWAPF TEMP,W
	CALL KOMUT_GONDER
	MOVF TEMP,W
	CALL KOMUT_GONDER
	RETURN

KOMUT_GONDER
	ANDWF 0X0F
	MOVWF PORTB
	BCF PORTB,4
	BSF PORTB,5
	CALL GECIKME
	BCF PORTB,5
	RETURN

VERI_YAZ
	MOVWF TEMP
	SWAPF TEMP,W
	CALL VERI_GONDER
	MOVF TEMP,W
	CALL VERI_GONDER
	RETURN

VERI_GONDER
	ANDWF 0X0F
	MOVWF PORTB
	BSF PORTB,4
	BSF PORTB,5
	CALL GECIKME
	BCF PORTB,5
	RETURN
	

GECIKME2
	MOVLW 0XFF
	MOVWF DEGER
	GOTO DON
GECIKME
	MOVLW 0X04
	MOVWF DEGER
DON
	MOVLW 0X8F
	MOVWF DEGER2
DON2
	DECFSZ DEGER2,1
	GOTO DON2
	DECFSZ DEGER,1
	GOTO DON
	RETURN
END


