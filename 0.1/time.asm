; time.asm 顶部添加
%ifndef TIME_ASM
%define TIME_ASM
%include "constants.asm"  ; 引入公共常量

; =============================================
; time.asm - 系统时间功能
; =============================================

; --------------------------
; 获取并显示当前时间
; --------------------------
show_time:
    ; 获取当前时间(BCD格式)
    mov ah, 0x02    ; BIOS获取时间功能
    int 0x1A        ; 调用BIOS时间服务
    jc .error       ; 出错则跳转
    
    ; 转换小时
    mov al, ch      ; CH=小时(BCD)
    call bcd_to_ascii
    mov [time_str], ax
    
    ; 添加冒号
    mov byte [time_str+2], ':'
    
    ; 转换分钟
    mov al, cl      ; CL=分钟(BCD)
    call bcd_to_ascii
    mov [time_str+3], ax
    
    ; 添加冒号
    mov byte [time_str+5], ':'
    
    ; 转换秒钟
    mov al, dh      ; DH=秒(BCD)
    call bcd_to_ascii
    mov [time_str+6], ax
    
    ; 显示时间字符串
    mov si, time_str
    call print_string
    
    ; 换行
    mov si, newline
    call print_string
    ret
    
.error:
    mov si, time_error_msg
    call print_string
    ret

; --------------------------
; 设置系统时间
; 输入：CX=小时和分钟(BCD), DX=秒和百分秒(BCD)
; --------------------------
set_time:
    mov ah, 0x03    ; BIOS设置时间功能
    int 0x1A
    jc .error
    
    mov si, time_set_msg
    call print_string
    ret
    
.error:
    mov si, time_error_msg
    call print_string
    ret

; --------------------------
; BCD转ASCII
; 输入：AL=BCD数
; 输出：AX=ASCII字符(高位在AH,低位在AL)
; --------------------------
bcd_to_ascii:
    mov ah, al      ; 复制到AH
    and al, 0x0F    ; 取低4位
    add al, '0'     ; 转为ASCII
    
    shr ah, 4       ; 取高4位
    and ah, 0x0F
    add ah, '0'     ; 转为ASCII
    
    ret

; --------------------------
; 数据区
; --------------------------
time_str db "00:00:00", 0x0D, 0x0A, 0
time_set_msg db "Time set successfully", 0x0D, 0x0A, 0
time_error_msg db "Time error!", 0x0D, 0x0A, 0
newline db 0x0D, 0x0A, 0
%endif