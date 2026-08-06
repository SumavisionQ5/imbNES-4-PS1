;-----------------------------------------------
; Mapper 189
;-----------------------------------------------
mapper189init
        sb      zero,map189prgbank
        jal     map189_apply_prg
        nop

        ; CHR 初始化
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
        ; MMC3 写处理
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

        ; 外部 PRG 写处理 ($4020-$7FFF)
        la      t8,map189prgwrite
        sw      t8,write40map
        sw      t8,write50map
        sw      t8,write51map
        sw      t8,write52map
        sw      t8,write60map
        sw      t8,write70map

        ; 无 SRAM
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
        move    s0,a1
        move    s1,t8

        andi    t8,a1,$FF
        srl     t9,a1,$4
        or      t8,t8,t9
        sb      t8,map189prgbank

        jal     map189_apply_prg
        nop

        move    a1,s0
        move    t8,s1
        lw      ra,saveFP
        jr      ra
        nop