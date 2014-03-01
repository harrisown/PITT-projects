#Harrison Bryant, Lab 8, Modification of Move_LED_2

.data
.align 2
frogsy:	.space 128
.align 2
frogsx:	.space 128
snakex: .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,7,6,5,4,3,2,1,0
snakey: .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,31,31,31,31,31,31,31,31
init_color: .word 1
newLine:	.asciiz "\n"
WonGamePrompt: .asciiz "You won the game!"
LoseGamePrompt: .asciiz "I'm sorry, but you lost the game"
YourScoreWas:	.asciiz "Your Score Was "
Time:	.asciiz "Your time in milliseconds was: "
.text
addi	$t7, $zero, 8 #snake size
addi	$s4, $zero, 0 #head of snake X
addi	$s5, $zero, 0 #head of snake Y
li	$v1, 0 #frog eaten counter

GetX:
li	$v0, 30
syscall
move $k1, $a0
la	$t9, frogsx
li	$t2, 0		# running counter
li	$t3, 32	# final count

# initialize the random number generator
jal	randinit

LOOP_BODY:
li	$a0, 64	# upper bound of the range
jal	getrandomnumber	
# v0 has the random number

# print the number with the space
move	$a0, $v0




sw	$a0, ($t9)
addi	$t9, $t9, 4

addi	$t2, $t2, 1
beq	$t2, $t3, GetY

j	LOOP_BODY		
		
GetY:
la	$t9, frogsy
li	$t2, 0		# running counter
li	$t3, 32	# final count


# initialize the random number generator
jal	randinit

LOOP_BODY2:

li	$a0, 64		# upper bound of the range
jal	getrandomnumber	
# v0 has the random number

# print the number with the space
move	$a0, $v0

sw	$a0, 0($t9)
addi	$t9, $t9, 4

addi	$t2, $t2, 1
beq	$t2, $t3, INITDisplayFrogs

j	LOOP_BODY2		


INITDisplayFrogs:
li	$t4, 0 #counter for frogs displayed
la	$t5, frogsx
la	$t6, frogsy
DisplayFrogs:
beq	$t4, 32, DisplaySnakeMethod
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 3
jal _getLED
bne	$v0, 3, SkipDecrement
addi	$v1, $v1, 1
SkipDecrement:
jal setLED
addi	$t5, $t5, 4
addi	$t6, $t6, 4
addi	$t4, $t4, 1
j DisplayFrogs

DisplaySnakeMethod:
jal	DisplaySnake

BeginPolling:
addi	$t8, $t8, 0 #current direction  (0 is right, 1 is down, 2 is left, 3 is up)


_poll:
	
	la	$t0,0xffff0000	# status register address	
	lw	$t0,0($t0)	# read status register
	andi	$t0,$t0,1		# check for key press
	bne	$t0,$0,_keypress
	
AnimateSnake: 
beq	$t8, 0, moveRIGHT
beq	$t8, 2, moveLEFT
beq	$t8, 1, moveDOWN
beq	$t8, 3, moveUP

moveRIGHT: #t5 is address of X value of tail, #t6 is address of Y value of the tail
addi	$t0, $zero, -1
addi	$t1, $zero, 4
mult	$t7, $t1
mflo	$t1
subi	$t1, $t1, 4 #t1 is offset 
sub	$t5, $t5, $t1
sub	$t6, $t6, $t1
#t5 is X head, #t6 is Y head
lw	$s1, 0($t5)
lw	$s2, 0($t6)
addi	$s1, $s1, 1
beq	$s1, 64, HITRIGHT
j notHITRIGHT
HITRIGHT:
li	$s1, 0
notHITRIGHT:
move	$a0, $s1
move	$a1, $s2
jal _getLED
beq $v0, 2, LoseGame
bne $v0, 3, NoFrogRight
jal deleteFrog
li	$v0, 99
NoFrogRight:
move	$s4, $s1
move	$s5, $s2
li	$a2, 2 
jal setLED 
sw	$s1, -4($t5)
sw	$s2, -4($t6)
add	$t5, $t5, $t1
add	$t6, $t6, $t1
beq	$v0, 99, SkipDeleteRight
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 0 
jal setLED
sw	$t0, 0($t5)
sw	$t0, 0($t6)
subi	$t5, $t5, 4
subi	$t6, $t6, 4
li	$a0, 200
li	$v0, 32
syscall
j _poll
SkipDeleteRight:
li	$a0, 200
li	$v0, 32
syscall
j _poll

moveDOWN:
addi	$t0, $zero, -1
addi	$t1, $zero, 4
mult	$t7, $t1
mflo	$t1
subi	$t1, $t1, 4 #t1 is offset 
sub	$t5, $t5, $t1
sub	$t6, $t6, $t1
#t5 is X head, #t6 is Y head
lw	$s1, 0($t5)
lw	$s2, 0($t6)
addi	$s2, $s2, 1
bgt	$s2, 63, HITBOTTOM
j notHITBOTTOM
HITBOTTOM:
li	$s2, 0
notHITBOTTOM:
move	$a0, $s1
move	$a1, $s2
jal _getLED
beq $v0, 2, LoseGame
bne $v0, 3, NoFrogDown
jal deleteFrog
li	$v0, 99
NoFrogDown:
move	$s4, $s1
move	$s5, $s2
li	$a2, 2 
jal setLED 
sw	$s1, -4($t5)
sw	$s2, -4($t6)
add	$t5, $t5, $t1
add	$t6, $t6, $t1
beq	$v0, 99, SkipDeleteDown
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 0 
jal setLED
sw	$t0, 0($t5)
sw	$t0, 0($t6)
subi	$t5, $t5, 4
subi	$t6, $t6, 4
li	$a0, 200
li	$v0, 32
syscall
j _poll
SkipDeleteDown:
li	$a0, 200
li	$v0, 32
syscall
j _poll



moveLEFT:
addi	$t0, $zero, -1
addi	$t1, $zero, 4
mult	$t7, $t1
mflo	$t1
subi	$t1, $t1, 4 #t1 is offset 
sub	$t5, $t5, $t1
sub	$t6, $t6, $t1
#t5 is X head, #t6 is Y head
lw	$s1, 0($t5)
lw	$s2, 0($t6)
subi	$s1, $s1, 1
blt	$s1, 0, HITLEFT
j notHITLEFT
HITLEFT:
li	$s1, 63
notHITLEFT:
move	$a0, $s1
move	$a1, $s2
jal _getLED
beq $v0, 2, LoseGame
bne $v0, 3, NoFrogLeft
jal deleteFrog
li	$v0, 99
NoFrogLeft:
move	$s4, $s1
move	$s5, $s2
li	$a2, 2 
jal setLED 
sw	$s1, -4($t5)
sw	$s2, -4($t6)
add	$t5, $t5, $t1
add	$t6, $t6, $t1
beq	$v0, 99, SkipDeleteLeft
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 0 
jal setLED
sw	$t0, 0($t5)
sw	$t0, 0($t6)
subi	$t5, $t5, 4
subi	$t6, $t6, 4
li	$a0, 200
li	$v0, 32
syscall
j _poll
SkipDeleteLeft:
li	$a0, 200
li	$v0, 32
syscall
j _poll




moveUP:
addi	$t0, $zero, -1
addi	$t1, $zero, 4
mult	$t7, $t1
mflo	$t1
subi	$t1, $t1, 4 #t1 is offset 
sub	$t5, $t5, $t1
sub	$t6, $t6, $t1
#t5 is X head, #t6 is Y head
lw	$s1, 0($t5)
lw	$s2, 0($t6)
subi	$s2, $s2, 1
blt	$s2, 0, HITTOP
j notHITTOP
HITTOP:
li	$s2, 64
notHITTOP:
move	$a0, $s1
move	$a1, $s2
jal _getLED
beq $v0, 2, LoseGame
bne $v0, 3, NoFrogUP
jal deleteFrog
li	$v0, 99
NoFrogUP:
move	$s4, $s1
move	$s5, $s2
li	$a2, 2 
jal setLED 
sw	$s1, -4($t5)
sw	$s2, -4($t6)
add	$t5, $t5, $t1
add	$t6, $t6, $t1
beq	$v0, 99, SkipDeleteUP
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 0 
jal setLED
sw	$t0, 0($t5)
sw	$t0, 0($t6)
subi	$t5, $t5, 4
subi	$t6, $t6, 4
li	$a0, 200
li	$v0, 32
syscall
j _poll
SkipDeleteUP:
li	$a0, 200
li	$v0, 32
syscall
j _poll

_keypress:
	# handle a keypress to change snake direction
	la	$t0,0xffff0004	# keypress register
	lw	$t0,0($t0)	# read keypress register

	# clear current star
	li	$a2, 0
	jal 	setLED

	# center key
	subi	$t1, $t0, 66				# center key?
	beq	$t1, $0, center_pressed		# 

	# left key
	beq	$t8, 0, SkipLeftorRightPress
	beq	$t8, 2, SkipLeftorRightPress
	subi	$t1, $t0, 226				# left key?
	beq	$t1, $0, left_pressed		# 
	SkipLeftorRightPress:
	
	# right key
	beq	$t8, 0, SkipLeftorRightPress2
	beq	$t8, 2, SkipLeftorRightPress2
	subi	$t1, $t0, 227				# right key?
	beq	$t1, $0, right_pressed		# 
	SkipLeftorRightPress2:
	# up key
	beq	$t8, 1, SkipUporDownPress
	beq	$t8, 3, SkipUporDownPress
	subi	$t1, $t0, 224				# up key?
	beq	$t1, $0, up_pressed			# 
	SkipUporDownPress:
	# down key
	beq	$t8, 1, SkipUporDownPress2
	beq	$t8, 3, SkipUporDownPress2
	subi	$t1, $t0, 225				# down key?
	beq	$t1, $0, down_pressed		# 
	SkipUporDownPress2:
	j	_poll

right_pressed:
	li	$t8, 0
	j	move_done

left_pressed:
	li	$t8, 2
	j	move_done

up_pressed:
	li	$t8, 3
	j move_done

down_pressed:
	li	$t8, 1
	j	move_done

center_pressed:
	j move_done
	
	
move_done:
	
j	_poll

_exit:
	li	$v0, 10
	syscall

setLED:
	subi	$sp, $sp, 20
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$ra, 16($sp)

	jal	_setLED

	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20
	
	jr	$ra


	# void _setLED(int x, int y, int color)
	#   sets the LED at (x,y) to color
	#   color: 0=off, 1=red, 2=orange, 3=green
	#
	# arguments: $a0 is x, $a1 is y, $a2 is color
	# trashes:   $t0-$t3
	# returns:   none
	#
	# void _setLED(int x, int y, int color)
	# 03/11/2012: this version is for the 64x64 LED
	#   sets the LED at (x,y) to color
	#   color: 0=off, 1=red, 2=orange, 3=green
	#
	# warning:   x, y and color are assumed to be legal values (0-63,0-63,0-3)
	# arguments: $a0 is x, $a1 is y, $a2 is color 
	# trashes:   $t0-$t3
	# returns:   none
	#
_setLED:
	beq $a1, -1, Erase
	beq $a0, -1, Erase
	# byte offset into display = y * 16 bytes + (x / 4)
	sll	$t0,$a1,4      # y * 16 bytes
	srl	$t1,$a0,2      # x / 4
	add	$t0,$t0,$t1    # byte offset into display
	li	$t2,0xffff0008	# base address of LED display
	add	$t0,$t2,$t0    # address of byte with the LED
	# now, compute led position in the byte and the mask for it
	andi	$t1,$a0,0x3    # remainder is led position in byte
	neg	$t1,$t1        # negate position for subtraction
	addi	$t1,$t1,3      # bit positions in reverse order
	sll	$t1,$t1,1      # led is 2 bits
	# compute two masks: one to clear field, one to set new color
	li	$t2,3		
	sllv	$t2,$t2,$t1
	not	$t2,$t2        # bit mask for clearing current color
	sllv	$t1,$a2,$t1    # bit mask for setting color
	# get current LED value, set the new field, store it back to LED
	lbu	$t3,0($t0)     # read current LED value	
	and	$t3,$t3,$t2    # clear the field for the color
	or	$t3,$t3,$t1    # set color field
	sb	$t3,0($t0)     # update display
	jr	$ra
Erase:
	jr	$ra


randinit:
# get the system time
li	$v0, 30
syscall
# system time (64bits) will be in a1:a0... take the lower half (i.e., a0)
move	$s0, $a0

# set the seed and the id
move	$a1, $s0		# seed
li	$a0, 1		# id
li	$v0, 40
syscall
jr	$ra

# takes a0 - upper bound 
# returns v0 as the random number 
getrandomnumber: 
move	$s0, $a0	# upper bound

li	$a0, 1		# id
move	$a1, $s0	# upper bound
li	$v0, 42
syscall
# a0 has the random number
move	$v0, $a0

jr	$ra

RedrawAliveFrogs:
addi	$sp, $sp, 12
sw	$a0, 0($sp)
sw	$a1, 4($sp)
sw	$ra, 8($sp)
li	$t4, 0
la	$t5, frogsx
la	$t6, frogsy

AlivePlace:
beq	$t4, 5, ENDREDRAW
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 3
jal setLED

addi	$t5, $t5, 4
addi	$t6, $t6, 4
addi	$t4, $t4, 1

j AlivePlace

 ENDREDRAW:
 lw	$a0, 0($sp)
 lw	$a1, 4($sp)
 lw	$ra, 8($sp)
 subi	$sp, $sp, 12
 jr 	$ra
 
deleteFrog: 
 addi	$v1, $v1, 1
 addi	$t7, $t7, 1
 beq	$v1, 32, WonGame
 jr $ra

DisplaySnake:
INITDisplaySnake:
li	$t4, 0 #counter for snake LEDS displayed
la	$t5, snakex
la	$t6, snakey
DisplaySnakeLOOP:
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 2
jal setLED
beq	$t4, 40, _poll
addi	$t5, $t5, 4
addi	$t6, $t6, 4
addi	$t4, $t4, 1

j DisplaySnakeLOOP

MoveSnake:
li	$t4, 0

MoveLOOP:
lw	$a0, 0($t5)
lw	$a1, 0($t6)
li	$a2, 2
jal setLED
beq	$t4, 40, _poll
subi	$t5, $t5, 4
subi	$t6, $t6, 4
addi	$t4, $t4, 1
j MoveLOOP

_getLED:
	addi	$sp, $sp, 12
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	
	# byte offset into display = y * 16 bytes + (x / 4)
	sll  $t0,$a1,4      # y * 16 bytes
	srl  $t1,$a0,2      # x / 4
	add  $t0,$t0,$t1    # byte offset into display
	la   $t2,0xffff0008
	add  $t0,$t2,$t0    # address of byte with the LED
	# now, compute bit position in the byte and the mask for it
	andi $t1,$a0,0x3    # remainder is bit position in byte
	neg  $t1,$t1        # negate position for subtraction
	addi $t1,$t1,3      # bit positions in reverse order
    	sll  $t1,$t1,1      # led is 2 bits
	# load LED value, get the desired bit in the loaded byte
	lbu  $t2,0($t0)
	srlv $t2,$t2,$t1    # shift LED value to lsb position
	andi $v0,$t2,0x3    # mask off any remaining upper bits
	lw	$t2, 8($sp)
	lw	$t1, 4($sp)
	lw	$t0, 0($sp)
	subi	$sp, $sp, 12
	jr   $ra

LoseGame:
la	$a0, LoseGamePrompt
li	$v0, 4
syscall
la	$a0, newLine
syscall
la	$a0, YourScoreWas
syscall
addi	$t7, $t7, -8
move	$a0, $t7
li	$v0, 1
syscall
la	$a0, newLine
li	$v0, 4
syscall
la	$a0, Time
syscall
li	$v0, 30
syscall
sub	$a0, $a0, $k1
li	$v0, 1
syscall
li	$v0, 10
syscall

WonGame:
la	$a0, WonGamePrompt
li	$v0, 4
syscall
la	$a0, newLine
syscall
la	$a0, YourScoreWas
syscall 
subi	$t7, $t7, 8
move	$a0, $t7
li	$v0, 1
syscall
la	$a0, newLine
li	$v0, 4
syscall
la	$a0, Time
syscall
li	$v0, 30
syscall
sub	$a0, $a0, $k1
li	$v0, 1
syscall
li	$v0, 10
syscall
