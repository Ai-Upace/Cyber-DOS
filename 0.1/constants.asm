; ========================
; constants.asm
; ========================
[bits 16]

; 公共字符串
%define NEWLINE 0x0D, 0x0A, 0

; 错误消息
%define DISK_ERROR_MSG "Disk Error!", NEWLINE
%define TIME_ERROR_MSG "Time Error!", NEWLINE

; 系统消息
%define WELCOME_MSG "MicroDOS v0.1", NEWLINE
%define PROMPT_STR "> ", 0