# Cyber-DOS  
**A Retro-Modern Operating System Evolution**  
*From 16-bit Real Mode to Protected Mode GUI Ecosystem*

![Cyber-DOS Architecture Diagram](https://via.placeholder.com/800x400.png?text=Bootloader+->+Kernel+->+GUI+Shell)  
*Current Version: 4.0 "Phantom Console"*

## 📖 Overview
Cyber-DOS chronicles the evolution of operating system development through four distinct technological eras. This pedagogical OS demonstrates:
- Bootstrapping from raw metal (Phase 1.0)
- Language abstraction layers (Phase 2.0)
- Architectural paradigm shifts (Phase 3.0)
- User-space ecosystem development (Phase 4.0)

## 🚀 Key Milestones
### Phase 1.0 "Iron Core" (16-bit Real Mode)
```nasm
mov ax, 0x13        ; BIOS video mode
int 0x10            ; Pure ASM dominance
```
- Bare-metal 16-bit real mode implementation
- Custom FAT12 bootloader with memory map
- Hardware-level interrupt handling
- Sector-based disk I/O utilities

### Phase 2.0 "Dual Spectrum" (Hybrid ASM/C)
```c
#pragma codeseg _KERNEL  
void syscall_handler(struct Registers *ctx) {
    __asm__ volatile("cli");  // Seamless integration
    handle_interrupt(ctx->ax); 
}
```
- Mixed assembly/C kernel foundation
- Protected mode transition bridge
- ELF-like binary format "CYBEXE"
- Basic process scheduler framework

### Phase 3.0 "Aurora-32" (32-bit Protected Mode)
- Full 32-bit protected mode transition
- Paging memory management (4MB init)
- Device abstraction layer (DAL v1)
- Multitasking with priority levels
- System call interface (INT 0x80)

### Phase 4.0 "Phantom Console" (GUI Era)
![GUI Demo](https://via.placeholder.com/400x300.png?text=VESA+2.0+GUI+with+Widget+Toolkit)
- VESA 2.0 graphics subsystem
- Window compositor "CyberWM"
- Built-in development tools:
  - `cybasm` (ASM IDE with macro debugger)
  - `memvis` (Real-time memory mapper)
  - `fshell` (File system forensic tool)
- Network stack prototype (ARP/IPv4)

## 🔧 Building Cyber-DOS
**Requirements:**
- NASM 2.15+
- GCC Cross-Compiler (i686-elf target)
- QEMU 6.0+ or physical 32-bit x86 hardware

```bash
# Bootstrap the toolchain
make toolchain

# Build full disk image (ISO):
make cyberdos.iso

# Launch in emulator:
make run
```

## 🤝 Contributing
We welcome contributions through:
- **Vintage Computing** (Real-mode optimization)
- **Modern Retrofit** (GUI widget development)
- **Archaeology** (Legacy hardware support)
- **Documentation** (Dev manuals & tutorials)

See our [CONTRIBUTING.md](docs/CONTRIBUTING.md) for technical guidelines.

## 📜 License
GPLv3 with *Historical Exception Clause* - derivative works must preserve original architectural documentation.

---

Let me know if you need adjustments to specific technical details or want to emphasize particular design philosophies! Would you like to add hardware compatibility lists or expand the "Getting Started" section with troubleshooting tips?

> **Warning**  
> Not responsible for spontaneous combustion of legacy hardware.  
> BIOS exorcism recommended before deployment.
