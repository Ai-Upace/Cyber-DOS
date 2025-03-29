; =============================================
; keyboard.asm - 键盘输入处理
; =============================================

; --------------------------
; 读取用户命令
; 结果存储在command_buffer
; --------------------------
read_command:
    mov di, command_buffer
    mov cx, 64      ; 最大长度64字符
    
.get_key:
    ; 等待按键
    mov ah, 0x00
    int 0x16
    
    ; 检查回车键(结束输入)
    cmp al, 0x0D
    je .done
    
    ; 检查退格键
    cmp al, 0x08
    je .backspace
    
    ; 检查是否超过缓冲区
    cmp cx, 1
    jbe .get_key    ; 如果只剩1字节空间(给结束符)
    
    ; 存储字符
    stosb
    dec cx
    
    ; 回显字符
    mov ah, 0x0E
    int 0x10
    
    jmp .get_key
    
.backspace:
    ; 检查是否在行首
    cmp di, command_buffer
    jbe .get_key    ; 如果在行首则忽略
    
    ; 移动指针
    dec di
    inc cx
    
    ; 显示退格效果
    mov ah, 0x0E
    mov al, 0x08    ; 退格
    int 0x10
    mov al, ' '     ; 空格
    int 0x10
    mov al, 0x08    ; 退格
    int 0x10
    
    jmp .get_key
    
.done:
    ; 添加字符串结束符
    mov byte [di], 0
    
    ; 换行
    mov ah, 0x0E
    mov al, 0x0D    ; 回车
    int 0x10
    mov al, 0x0A    ; 换行
    int 0x10
    
    ret