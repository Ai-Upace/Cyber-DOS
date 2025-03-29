; fat12.asm 顶部添加
%ifndef FAT12_ASM
%define FAT12_ASM
%include "constants.asm"  ; 引入公共常量

; =============================================
; fat12.asm - FAT12文件系统实现
; =============================================

; --------------------------
; 初始化FAT12文件系统
; --------------------------
init_fat12:
    ; 加载FAT表到内存(0x7E00)
    mov ax, 0x07E0
    mov es, ax      ; ES = 0x07E0
    xor bx, bx      ; BX = 0
    
    mov ah, 0x02    ; 读扇区功能
    mov al, 9       ; 读取9个扇区(FAT表大小)
    mov ch, 0       ; 柱面0
    mov cl, 2       ; 从第2扇区开始
    mov dh, 0       ; 磁头0
    int 0x13
    jc .error
    
    ; 加载根目录到内存(0x9000)
    mov ax, 0x9000
    mov es, ax      ; ES = 0x9000
    xor bx, bx      ; BX = 0
    
    mov ah, 0x02
    mov al, 14      ; 根目录占14个扇区
    mov ch, 0
    mov cl, 19      ; 根目录起始扇区
    mov dh, 0
    int 0x13
    jc .error
    
    ret
    
.error:
    mov si, fat_error_msg
    call print_string
    ret

; --------------------------
; 列出目录内容
; --------------------------
list_directory:
    push es
    mov ax, 0x9000  ; 根目录在0x9000
    mov es, ax
    xor di, di      ; ES:DI = 0x9000:0x0000
    
    mov cx, 224     ; 最大目录条目数
    
.next_entry:
    ; 检查条目是否有效
    cmp byte [es:di], 0     ; 空条目
    je .skip
    cmp byte [es:di], 0xE5  ; 删除条目
    je .skip
    
    ; 显示文件名(8字节)
    mov si, di
    mov cx, 8
    call print_name_part
    
    ; 显示扩展名(3字节)
    mov al, '.'
    call print_char
    add si, 8
    mov cx, 3
    call print_name_part
    
    ; 换行
    mov si, newline
    call print_string
    
.skip:
    add di, 32      ; 下一个目录条目(32字节/条目)
    loop .next_entry
    
    pop es
    ret

; 打印文件名部分
print_name_part:
    mov al, [es:si]
    call print_char
    inc si
    loop print_name_part
    ret

; --------------------------
; 数据区
; --------------------------
fat_error_msg db "FAT12 init error!", 0x0D, 0x0A, 0
%endif