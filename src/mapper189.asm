;-----------------------------------------------
; Mapper 189
;-----------------------------------------------
mapper189init
        ; --- 初始化 MMC3 寄存器，避免残留状态 ---
        sb      zero,mapReg0
        sb      zero,mapReg1
        sb      zero,mapReg2
        sb      zero,mapReg3
        sb      zero,map4latch
        sw      zero,mapHsyncFunc
        ; map4irq 是 16 位，用 sh 清零
        la      t8,map4irq
        sh      zero,0(t8)
        sb      zero,2(t8)      ; map4latch（上面的 sb 也可以，这里确保偏移正确）
        sb      zero,3(t8)      ; map4irqOn

        ; --- PRG 初始化从 bank 0 开始 ---
        sb      zero,map189prgbank
        jal     map189_apply_prg
        nop

        ; --- CHR 初始化 ---
        lbu     t8,chrCount
        nop
        beqz    t8,noChrMap189
        nop

        li      a0,$00
        li      a1,$00
        jal     bufLoadVROM
        nop
        jal     bufLoadVROM
        nop
        jal     bufLoadVROM
        nop
        jal     bufLoadVROM
        nop
        jal     bufLoadVROM
        nop
        jal     bufLoadVROM
        nop
        jal     bufLoadVROM
        nop
        jal     bufLoadVROM
        nop

noChrMap189
        ; --- MMC3 写处理 ---
        la      a0,map4write8
        sw      a0,write80map
        sw      a0,write90map
        la      a0,map4writeA
        sw      a0,writeA0map
        sw      a0,writeB0map
        la      a0,map4writeC
        sw      a0,writeC0map
        sw      a0,writeD0map
        la      a0,map4writeE
        sw      a0,writeE0map
        sw      a0,writeF0map

        ; --- 外部 PRG 写处理 ($4100-$7FFF) ---
        la      t8,map189prgwrite
        sw      t8,write40map
        sw      t8,write50map
        sw      t8,write51map
        sw      t8,write52map
        sw      t8,write60map
        sw      t8,write70map

        ; --- 无 SRAM ---
        li      t8,$01
        la      at,mapperNoSRAM
        sb      t8,0(at)

        j       mapperDone
        nop

;-----------------------------------------------
; Apply 32K PRG bank
;-----------------------------------------------
map189_apply_prg
        sw      ra,saveRA189

        lbu     t8,map189prgbank
        andi    t8,t8,$7
        sll     a1,t8,$2          ; base = bank * 4

        li      a0,$04
        jal     bankSwitch
        nop
        li      a0,$05
        jal     bankSwitch
        nop
        li      a0,$06
        jal     bankSwitch
        nop
        li      a0,$07
        jal     bankSwitch
        nop

        lw      ra,saveRA189
        jr      ra
        nop

;-----------------------------------------------
; Write handler
;-----------------------------------------------
map189prgwrite
        sw      ra,saveFP

        ; 注意：这里不再使用 s0/s1，避免破坏 NES 的 A/X/Y 寄存器
        ; 合并数据位高/低半字节，符合广义 Mapper 189 定义
        andi    t8,a1,$FF
        srl     t9,a1,$4
        or      t8,t8,t9
        sb      t8,map189prgbank

        jal     map189_apply_prg
        nop

        lw      ra,saveFP
        jr      ra
        nop