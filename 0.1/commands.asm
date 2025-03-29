; =============================================
; commands.asm - 命令解析与执行
; =============================================

; --------------------------
; 解析并执行命令
; --------------------------
parse_command:
    mov si, command_buffer
    
    ; 跳过前导空格
.skip_spaces:
    lodsb
    cmp al, ' '
    je .skip_spaces
    cmp al, 0       ; 空命令
    je .empty
    dec si          ; 回退到第一个非空格字符
    
    ; 检查TIME命令
    mov di, time_cmd
    call strcmp
    je .do_time
    
    ; 检查DIR命令
    mov di, dir_cmd
    call strcmp
    je .do_dir
    
    ; 检查REBOOT命令
    mov di, reboot_cmd
    call strcmp
    je .do_reboot
    
    ; 检查HELP命令
    mov di, help_cmd
    call strcmp
    je .do_help
    
    ; 未知命令
    mov si, unknown_cmd_msg
    call print_string
    ret
    
.empty:
    ret             ; 空命令直接返回
    
.do_time:
    call show_time
    ret
    
.do_dir:
    call list_directory
    ret
    
.do_reboot:
    ; 通过跳转到FFFF:0000实现冷启动
    jmp 0xFFFF:0x0000
    
.do_help:
    mov si, help_msg
    call print_string
    ret

; --------------------------
; 字符串比较
; 输入：SI=字符串1, DI=字符串2(以0结尾)
; 输出：ZF=1(相等), ZF=0(不等)
; --------------------------
strcmp:
    push si
    push di
    
.compare:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal
    test al, al     ; 是否到字符串结尾
    jz .equal
    inc si
    inc di
    jmp .compare
    
.equal:
    xor ax, ax      ; 设置ZF=1
.not_equal:
    pop di
    pop si
    ret

; --------------------------
; 数据区
; --------------------------
time_cmd db "TIME", 0
dir_cmd db "DIR", 0
reboot_cmd db "REBOOT", 0
help_cmd db "HELP", 0
unknown_cmd_msg db "Unknown command", 0x0D, 0x0A, 0
help_msg db "Available commands:", 0x0D, 0x0A
         db "TIME    - Show current time", 0x0D, 0x0A
         db "DIR     - List directory", 0x0D, 0x0A
         db "REBOOT  - Reboot system", 0x0D, 0x0A
         db "HELP    - Show this help", 0x0D, 0x0A, 0