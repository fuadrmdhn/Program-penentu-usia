name "penentu_usia"

org 100h

jmp start

msg1 db 0Dh,0Ah, " Ini Adalah Program Penentu Usia $"
msg2 db 0Dh,0Ah, " Masukkan Tahun Lahir Anda    : $" 
msg3 db 0Dh,0Ah, " Masukkan Bulan Lahir Anda    : $"
msg4 db 0Dh,0Ah, " Masukkan Tanggal Lahir anda  : $"
msg5 db 0Dh,0Ah, " Jadi Umur Anda Adalah $"
msg6 db  " Tahun $"
msg7 db  " Bulan $"
msg8 db  " Hari $"
buffer db 7,?, 5 dup (0), 0, 0    ;

tahun db ?
bulan db ?
tanggal db ?


start:
mov di,4 

mov dx, offset msg1
mov ah, 9
int  21h

 
pesan1:   
mov dx, offset msg2;masukkan tahun lahir anda
call  cetak
jmp input

pesan2:
mov dx, offset msg3;masukkan bulan lahir anda
call  cetak
jmp input

pesan3:
mov dx, offset msg4;masukkan tanggal lahir anda
call  cetak
jmp input

input:
mov dx, offset buffer
mov ah, 0ah
int  21h

mov bx, 0
mov bl, buffer[1]
mov buffer[bx+2], 0


lea    si, buffer + 2 
call     tobin 

push cx  

;instruksi utk menghitung 
;nilai umur detil sampe hari

cek:        
dec di      
cmp di,2    
ja tahune   

cmp di,1    
ja bulane

cmp di,0    
ja tanggale
jmp rampung



tahune:         
call  getdate    
pop ax          
sub cx,ax       
mov cs:tahun,cl 
jmp pesan2      


bulane:         
call  getdate
pop ax
mov dl,dh       
mov dh,00h      
sub dx,ax       
cmp dx,0        
js cmb          
mov cs:bulan,dl 
jmp pesan3     

cmb:            
add bulan,0ch    
dec tahun       
jmp pesan3      

tanggale:       
call  getdate
pop ax          
mov dh,00       
sub dx,ax       
cmp dx,0        
js cmt         
mov cs:tanggal,dl
jmp rampung     

cmt:            
add dl,1eh      
mov cs:tanggal,dl
cmp bulan,0
jne rampung
mov bulan,0bh
dec tahun
jmp rampung


rampung: 
mov dx, offset msg5 
mov ah, 9
int  21h

mov ch,00h       
mov cl,tahun
call  henshin
mov dx,offset msg6
call  cetak

mov cl,bulan
call  henshin
mov dx,offset msg7
call  cetak

mov cl,tanggal 
call  henshin
mov dx,offset msg8
call  cetak

jmp end

;prosedur untuk memasukkan     
;tanggal hari ini ke ax dan dx 

getdate proc near             
    mov ah,2ah
    int  21h
    ret
getdate endp 

;prosedur untuk mencetak 
;nilai pada dx            

proc cetak
    mov ah, 9
    int  21h
ret
cetak endp 


tobin   proc    near
        push    dx
        push    ax
        push    si
   
   
jmp process
       
     
make_minus      db      ? 
ten             dw      10


process:              
        mov     cx, 0
        mov     cs:make_minus, 0

next_digit:
    mov     al, [si]
    inc    si     
        cmp     al, 0
        jne     not_end
        jmp     stop_input       
not_end:
        cmp     al, '-'
        jne     ok_digit
    jmp     next_digit
   
ok_digit:
        push    ax
        mov     ax, cx
        mul     cs:ten          
        mov     cx, ax
        pop     ax
        sub     al, 30h
        mov     ah, 0
        mov     dx, cx      
        add     cx, ax
        jmp     next_digit

stop_input:
        cmp     cs:make_minus, 0
        je      not_minus
        neg     cx
       
not_minus:
        pop     si
        pop     ax
        pop     dx
        ret
tobin        endp

;prosedur ini digunakan   
;untuk ngeprint  hex pada cx
;jadi dec               
proc henshin  
    
    mov di,2
    mov [1001],0h
    mov [1000],0h
    lanjut:
    cmp cx,0
    je stop
    
    mov ax,cx
    mov bl,10
    div bl
    mov [di+0999],ah
    add [di+0999],30h
    
    xor ah,ah
    mov cx,ax
    dec di
    jmp lanjut
    
    
    
    stop:
    
    mov ah,2h
    mov di,1
    printo:
    mov dl,[di+0999]
    int  21h
    inc di
    cmp di,2
    jbe printo
    
    ret
henshin endp   


end:
mov ah, 0 ;int  untuk nunggu input
int  16h