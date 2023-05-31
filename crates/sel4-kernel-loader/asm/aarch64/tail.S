#include "macros.h"
#include "registers.h"
#include "mm.h"

BEGIN_FUNC(switch_translation_tables_el2)

    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    bl      clean_and_invalideate_dcache

    disable_mmu sctlr_el2, x8

    bl      invalidate_icache

    adrp    x8, kernel_boot_level_0_table
    msr     ttbr0_el2, x8
    isb

    tlbi    alle2is
    dsb     ish
    isb

    enable_mmu  sctlr_el2, x8

    ic      ialluis
    dsb     ish
    isb

    tlbi    alle2is
    dsb     ish
    isb

    ldp     x29, x30, [sp], #16

    ret

END_FUNC(switch_translation_tables_el2)