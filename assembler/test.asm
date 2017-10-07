lw r0, 5
lw r1, 7
cmp r0,r1
lw r3,7
brfl r3,1,1
lw r0,0
jpc 1
add r0,r1
lw r4,1
sw r0,0(r4)