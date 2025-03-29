; =============================================
; kernel.asm - 系统内核主程序
; =============================================

[bits 16]
[org 0x0500]    ; 内核加载到0x0500处

main:
    ; 初始化系统
    call init_system
    
    ; 显示欢迎信息
    mov si, welcome_msg
    call print_string
    
main_loop:
    ; 显示命令提示符
    mov si, prompt
    call print_string
    
    ; 读取用户输入
    call read_command
    
    ; 解析并执行命令
    call parse_command
    
    jmp main_loop   ; 循环等待下个命令

; --------------------------
; 系统初始化
; --------------------------
init_system:
    ; 初始化FAT12文件系统
    call init_fat12
    
    ; 设置中断向量等
    ; (这里可以添加更多初始化代码)
    ret

; --------------------------
; 包含其他模块
; --------------------------
%include "time.asm"     ; 时间功能
%include "fat12.asm"    ; 文件系统
%include "keyboard.asm" ; 键盘输入
%include "commands.asm" ; 命令处理
%include "utils.asm"    ; 实用函数
%include "constants.asm" ; 常量定义

; --------------------------
; 数据区
; --------------------------
welcome_msg db "MicroDOS v0.1 - 8086 Assembly OS", 0x0D, 0x0A
            db "Type 'HELP' for command list", 0x0D, 0x0A, 0
prompt db "> ", 0
command_buffer times 64 db 0 ; 命令输入缓冲区