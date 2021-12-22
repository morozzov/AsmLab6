section .bss
cur_word resd 1
dict resd 18
buff resw 1

section .data
text db "testA", "testB", "testC", "testB", "testC", "TESTT", "TESTT", "TESTT", "TESTT"
dict_pos db 0
newl db 0x0A
space db 0x20 

section .text
global _start

_start:
    
    call word_count

    mov [dict_pos], BYTE 0

print_cycle:
    mov dl, [dict_pos]

    mov eax, 4
    mov ebx, 1
    mov ecx, dict[edx * 4 + 4]
    mov edx, 5
    int 0x80
      
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    mov dl, [dict_pos]

    mov ecx, dict[edx * 4]
    add ecx, 48
    mov [buff], ecx    

    mov eax, 4
    mov ebx, 1
    mov ecx, buff
    mov edx, 1
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newl
    mov edx, 1
    int 0x80
       
 
    mov dl, [dict_pos]
    add dl, 2
    mov [dict_pos], dl

    cmp edx, 18
    jne print_cycle
    

    mov eax, 1
    mov ebx, 0
    int 0x80


word_count:
    mov edx, 0
text_cycle:
    lea eax, text[edx*4 + edx]
    mov [cur_word], eax

    mov ebx, 0
    mov eax, 0

    inc edx
    cmp edx, 9
    jg end
    jle word_cycle

word_cycle:
    mov esi, [cur_word]
    lea edi, text[ebx*4 + ebx]
    mov ecx, 5
    cld
    repz cmpsb
    je found

    inc ebx
    cmp ebx, 9
    je word_out
    jne word_cycle

found:
    inc eax
    inc ebx
    cmp ebx, 9
    je word_out
    jne word_cycle

word_out:
    mov bl, [dict_pos]
    mov dict[ebx * 4], eax
    inc ebx
    mov eax, [cur_word]
    mov [dict + ebx * 4], eax
    inc ebx
    mov [dict_pos], bl
    jmp text_cycle 
    

end:
    mov eax, dict
    ret
