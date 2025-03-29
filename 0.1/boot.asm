; =============================================
; boot.asm - 系统引导程序
; 功能：加载内核到内存并跳转执行
; =============================================

[bits 16]           ; 16位模式
[org 0x7C00]        ; BIOS将引导扇区加载到0x7C00

start:
    ; 初始化段寄存器
    xor ax, ax      ; AX = 0
    mov ds, ax      ; DS = 0 (数据段)
    mov es, ax      ; ES = 0 (附加段)
    mov ss, ax      ; SS = 0 (堆栈段)
    mov sp, 0x7C00  ; 堆栈指针指向引导扇区下方

    ; 设置80x25文本显示模式
    mov ax, 0x0003
    int 0x10

    ; 显示加载信息
    mov si, loading_msg
    call print_string

    ; 从磁盘加载内核(假设内核在2-11扇区)
    mov ah, 0x02    ; BIOS读扇区功能
    mov al, 10      ; 读取10个扇区
    mov ch, 0       ; 柱面0
    mov cl, 2       ; 从第2扇区开始(1是引导扇区)
    mov dh, 0       ; 磁头0
    mov bx, 0x0500  ; ES:BX = 0x0000:0x0500 (加载地址)
    int 0x13        ; 调用BIOS磁盘服务
    jc disk_error   ; 如果出错(进位标志=1)

    ; 成功加载后跳转到内核
    jmp 0x0000:0x0500

; --------------------------
; 磁盘错误处理
; --------------------------
disk_error:
    mov si, error_msg
    call print_string
    jmp $           ; 无限循环

; --------------------------
; 打印字符串函数
; 输入：SI=字符串地址(以0结尾)
; --------------------------
print_string:
    lodsb           ; 加载[SI]到AL，SI++
    or al, al       ; AL=0?
    jz .done        ; 是则结束
    mov ah, 0x0E    ; BIOS显示字符功能
    int 0x10        ; 调用BIOS视频服务
    jmp print_string
.done:
    ret

; --------------------------
; 数据区
; --------------------------
loading_msg db "Loading MicroDOS...", 0x0D, 0x0A, 0
error_msg db "Disk Error! Press any key to reboot", 0x0D, 0x0A, 0

; 填充引导扇区剩余空间(510字节)
times 510-($-$$) db 0
; 最后2字节必须是0xAA55(引导签名)
dw 0xAA55