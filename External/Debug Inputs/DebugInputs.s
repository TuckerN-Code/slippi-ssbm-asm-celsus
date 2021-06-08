################################################################################
# Constants
################################################################################
.set INJ_InitDebugInputs, 0x8016e774

.set CIRCULAR_BUFFER_COUNT, 10

.set DIB_IS_READY, 0 # u8
.set DIB_POLL_INDEX, DIB_IS_READY + 1 # u8
.set DIB_ENGINE_INDEX, DIB_POLL_INDEX + 1 # u8
.set DIB_CIRCULAR_BUFFER, DIB_ENGINE_INDEX + 1 # u32 * CIRCULAR_BUFFER_COUNT
.set DIB_SIZE, DIB_CIRCULAR_BUFFER + (4 * CIRCULAR_BUFFER_COUNT)

################################################################################
# Macros
################################################################################
.macro incrementByte reg, reg_address, offset, limit
lbz \reg, \offset(\reg_address)
addi \reg, \reg, 1
cmpwi \reg, \limit
blt 0f
li \reg, 0
0:
stb \reg, \offset(\reg_address)
.endm

.macro calcDiffTicksToUs reg_dib, ref_idx
branchl r12, 0x8034c408 # OSGetTick
lbz r4, \ref_idx(\reg_dib)
mulli r4, r4, 4
addi r4, r4, DIB_CIRCULAR_BUFFER
lwzx r4, \reg_dib, r4
sub r3, r3, r4 # This works even if ticks overflow
mulli r3, r3, 12
li r4, 486
divwu r3, r3, r4
.endm