#Harrison Bryant
#hsb18@pitt.edu
.data
Word0: .asciiz "computer"
Word1: .asciiz "hello"
Word2: .asciiz "marshall"
Word3: .asciiz "ted"
Word4: .asciiz "louis"
Word5: .asciiz "drew"
Word6: .asciiz "ryan"
Word7: .asciiz "nick"
Word8: .asciiz "swagger"
Word9: .asciiz "musfik"
Space: .asciiz " "
Newline: .asciiz "\n"
YourWordIs: .asciiz "Your Word is "
Welcome: .asciiz "Welcome to Word Soup! \n I am thinking of a word. "
TheWordIs: .asciiz	"The word is: "
ScorePrompt: .asciiz ". Your round score is : "
GuessPrompt: .asciiz "Guess a letter\n"
Lost: .asciiz "I'm sorry, but you've lost the round. "
Yes: .asciiz "YES! "
No: .asciiz "NO! "
Forfeit: .asciiz "Your Forfeited the round, you gain 0 points "
PlayAgain: .asciiz "Would you like to play again?\n"
Won: .asciiz "You won the round! Your final Guess was when the word was:\n "
TheWordWas: .asciiz "Your Word Was:\n"
RoundScorePrompt: .asciiz "Your round score is "
Period: .asciiz ". "
GameTallyPrompt: .asciiz "Your game tally is "
FinalTally: .asciiz "Your final game tally is: "
Goodbye: .asciiz "Goodbye!"
GuessedWord: .space 16
.align 2
CurrentWord: .space 4
.align 2
Wordlist: .word Word0, Word1, Word2, Word3, Word4, Word5, Word6, Word7, Word8,Word9

.text

TOP:
addi	$t9, $zero, 0# t9 is the global variable for number of times ? Powerup was used
addi	$s6, $zero, 0 #clear out any word data from previous games
addi	$t7,$t7,0 #times played
li	$t2, 0
li	$t3, 1
#initialization
jal	initrandgen
#loop body
loop_start:
li	$a0, 9
jal getrand
addi	$a0, $v0, 1
addi	$t2, $t2, 1
beq	$t2, $t3, EXIT
j loop_start

EXIT: #Branching condition based upon how many times the user has played the game
bne	$t7, 0, Main
li	$a0, 0 #Computer is the word


Main:
move	$t0, $a0 
sll	$t3, $t0, 2 #offset the random digit to corrospond to the table
la	$t2, Wordlist
add	$t2, $t2, $t3
lw	$a0, 0($t2)#setting a0 to the correct offset word from the array
lw	$a2, 0($t2)


move	$s6, $a0#s6 is the address of the word which is getting changed up
jal asterisks
addi	$s0, $zero, 0 #Counter for number of times guessing a letter
jal GameStart1



asterisks:

move	$v0, $s6
move	$v1, $t2 #v1 is now the address of v0
sw	$ra, 0($sp)
subi	$sp, $sp, 4

jal findnumchars #v0 has string
move	$v0, $a0 #v0 now has the number of characters in the string
move	$s7, $v0 #s7 is permenant register for the # characters of the string

jal placeunderscores
jal placeasterisks


addi	$sp, $sp, 4
lw	$ra, ($sp)
jr	$ra




findnumchars:
move	$t0, $v0
li 	$t2, 0x00 #null
li 	$t4, 0 #length of the string

findnumcharsLoop:
lb	$t1, 0($t0)
sb	$t1, CurrentWord($t4)
beq	$t1, $t2, FoundNull

addi	$t4, $t4, 1
addi	$t0, $t0, 1
j findnumcharsLoop

FoundNull:
addi	$a0, $t4, 0
jr $ra




placeunderscores:
move	$t2, $s6
addi	$t0, $zero, 0
addi	$t1, $s7, 0

placeunderscoresloop:
la	$t3, 0x5F
sb	$t3, 0($t2)

addi	$t2, $t2, 1
addi	$t0, $t0, 1
beq	$t0, $t1, ExitPUL
j placeunderscoresloop

ExitPUL:
jr $ra 



placeasterisks:
sw	$ra, 0($sp)
subi	$sp, $sp, 4


srl 	$t0, $s7, 1 #t0 is now N/2 , the number of asterisks to apply to the string
li	$t2, 0
addi	$t3, $t0, 0

asterisksloop_start:
addi	$a0, $s7, 0
jal getrand
addi	$a0, $v0, 0 #a0 has the first random number
li	$s1, 0x2A #ASCII *
add	$s4, $s6, $a0
sb	$s1, 0($s4)

li	$v0, 4
la	$a0, Newline
syscall

addi	$t2, $t2, 1
beq	$t2, $t3, AsterisksArePlaced 
j asterisksloop_start


AsterisksArePlaced:
addi	$sp, $sp, 4
lw	$ra, 0($sp)
jr $ra



GameStart1:
addi	$s5, $zero, 0
addi	$s0, $zero, 0
move	$s2, $s7 #Place the number of characters of the string into a new value s2 to be mutable
la	$a0, Welcome
li	$v0, 4
syscall
GameStart:
beq	$s5, $s7, ExitGameWon
beq	$s2, 0, ExitGameLost
addi	$s1, $s1, 1
sw	$ra, 0($sp)
addi	$sp, $sp, 4
la	$a0, YourWordIs
li	$v0, 4
syscall
jal printword
la	$a0, ScorePrompt
syscall
move	$a0, $s2
li	$v0, 1
syscall
la	$a0, Newline
li	$v0, 4
syscall
la	$a0, GuessPrompt
syscall
li	$v0, 12 # read a character from the user
syscall
move	$t0, $v0 # t0 is the character read in
la	$a0, Newline
li	$v0, 4
syscall



li	$t1, 0x2E #period
bne	$t0, $t1, TryQuestion
la	$a0, Forfeit
li	$v0, 4
syscall
addi	$t7, $t7, 1
j TOP


TryQuestion:
beq	$t9, 3, GameLoop
la	$t6, CurrentWord
li	$t4, 0x5F #underscore
li	$t1, 0x3F #Question Mark
bne	$t0, $t1, TryExclamation
move	$t2, $s6
FindUtoReplace:
lb	$t5, 0($t2)
bne	$t5, $t4, NotUnderscore
beq	$t5, 0x00 GameStart
lb	$t3, 0($t6)
sb	$t3, 0($t2)
addi	$t9, $t9, 1
addi	$s5, $s5, 1
subi	$s2, $s2, 1
j GameStart
NotUnderscore:
addi	$t2, $t2, 1
addi	$t6, $t6, 1
j FindUtoReplace


TryExclamation:
bne	$t0, 0x21, GameLoop
la	$a0, GuessedWord
addi	$a1, $s7, 1
li	$v0, 8
syscall
move	$s3, $s7
addi	$s3, $zero, 0
la	$a1, CurrentWord
CheckWinLoop: #a0 is guessedword
bne	$s3, $s7, KeepChecking
add	$s2, $s2, $s2
j ExitGameWon
KeepChecking:
lb	$t0, 0($a0)
lb	$t1, 0($a1)
bne	$t0, $t1, GuessFail
addi	$a0, $a0, 1
addi	$a1, $a1, 1
addi	$s3, $s3, 1
j CheckWinLoop
GuessFail:
li	$s1, -2
mult	$s2, $s1
mflo 	$s2
j ExitGameLost


GameLoop: #t0 is the guess
addi	$s3, $zero, 0
addi	$t2, $zero, 0
addi	$t3, $s7, 0
la	$t1,CurrentWord  
CheckChar:
lb	$t4, 0($t1) #t4 is the Nth letter of the word to be guessed
bne	$t0, $t4, NextChar
addi	$s5, $s5, 1 #CorrectLetter Found
la	$a0, Yes
li	$v0, 4
syscall
add	$s3, $s3, 1 # if the string contains the guessed letter, make s3 something other than 0
add 	$s6, $s6, $t2
li	$s1, 0x2A
lb	$t5, ($s6)
beq	$t5, $s1, AsteriskNextChar
sb	$t4, ($s6)
sub	$s6, $s6, $t2

NextChar:
addi	$t2, $t2, 1
beq	$t2, $t3, WordChecked
addi	$t1, $t1, 1
j CheckChar

AsteriskNextChar:
sub $s6, $s6, $t2
addi	$t2, $t2, 1
beq	$t2, $t3, WordChecked
addi	$t1, $t1, 1
j CheckChar

WordChecked:
subi	$s0, $s0, 1
bne	$s3, 0, GameStart
la	$a0, No
li	$v0, 4
syscall
addi	$s2, $s2, -1
j GameStart















printword:
subi	$sp, $sp, 16
sw	$t1, 0($sp)
sw	$t2, 4($sp)
sw	$t3, 8($sp)
sw	$s6, 12($sp)
addi	$t2, $zero, 0
printLoop:
beq	$t2, $s7 ExitPrintLoop
lb	$t1, 0($s6)
move	$a0, $t1
li	$v0, 11
syscall
la	$a0, Space
li	$v0, 4
syscall 
add	$s6, $s6, 1
addi	$t2, $t2, 1
j printLoop
ExitPrintLoop:
lw	$s6, 12($sp)
lw	$t3, 8($sp)
lw	$t2, 4($sp)
lw	$t1, 0($sp)
addi	$sp, $sp, 16
jr $ra


ExitGameWon:
add	$t8, $t8, $s2
addi	$t7, $t7 1
la	$a0, Won
li	$v0, 4
syscall
move	$a0, $s6
syscall
la	$a0, Newline
syscall
la	$a0, TheWordWas
syscall
la	$a0, CurrentWord
syscall
la	$a0, Newline
syscall
la	$a0, RoundScorePrompt
syscall
move	$a0, $s2
li	$v0, 1
syscall
la	$a0, Period
li	$v0, 4
syscall
la	$a0, GameTallyPrompt
syscall
move	$a0, $t8
li	$v0, 1
syscall
la	$a0, Newline
li	$v0, 4
syscall
jal	fixWord
la	$a0, PlayAgain
li	$v0, 4
syscall
li	$v0, 12
syscall
move	$a0, $v0
li	$a1, 0x79
beq	$a0, $a1, TOP
la	$a0, Newline
li	$v0, 4
syscall
la	$a0, FinalTally
li	$v0, 4
syscall
move	$a0, $t8
li	$v0, 1
syscall
la	$a0, Space
li	$v0, 4
syscall
la	$a0, Goodbye
li	$v0, 4
syscall
li	$v0, 10
syscall

ExitGameLost:
add	$t8, $t8, $s2
la	$a0, Newline
li	$v0, 4
syscall
la	$a0, TheWordWas
li	$v0, 4
syscall
la	$a0, CurrentWord
syscall
la	$a0, Newline
syscall
addi	$t7, $t7, 1
li	$v0, 4
la	$a0, Lost
syscall
la	$a0, RoundScorePrompt
syscall
move	$a0, $s2
li	$v0, 1
syscall
la	$a0, Period
li	$v0, 4
syscall
la	$a0, GameTallyPrompt
syscall
move	$a0, $t8
li	$v0, 1
syscall
li	$v0, 4
la	$a0, Newline
syscall
jal	fixWord
la	$a0, PlayAgain
li	$v0, 4
syscall
li	$v0, 12
syscall
move	$a0, $v0
li	$a1, 0x79
beq	$a0, $a1, TOP
la	$a0, Newline
li	$v0, 4
syscall
la	$a0, FinalTally
li	$v0, 4
syscall
move	$a0, $t8
li	$v0, 1
syscall
la	$a0, Space
li	$v0, 4
syscall
la	$a0, Goodbye
li	$v0, 4
syscall
li	$v0, 10
syscall





fixWord:
la	$t0, CurrentWord
addi	$t3, $zero, 0
fixloop:
beq	$t3,$s7, Exitfixloop
lb	$t1, 0($t0)
sb	$t1, ($s6)
addi	$t0, $t0, 1
addi	$s6, $s6, 1
addi	$t3, $t3, 1
j fixloop
Exitfixloop:
sub	$s6, $s6, $t3
jr $ra



initrandgen:
	#prologue
	subi 	$sp, $sp, 4
	sw	$ra, 0($sp)
#systemtime: $a0 is lower 32 bits for seed
li $v0, 30
syscall

move	$a1, $a0 # a1 is lower 32 bits so it isn't overwritten SEED established
#id
li	$a0, 1
#seed loaded via line 39
li	$v0, 40	#a0 is ID and a1 is seed
syscall

#epilogue
lw	$ra, 0($sp)
addi	$sp, $sp, 4


jr $ra

#a0 is upper bound
getrand:
	#prologue
	subi	$sp, $sp, 4
	sw	$ra, 0($sp)

	#id
	move	$a1, $a0 #upper bound
	li	$a0, 1   # same ID as randomgen
	li	$v0, 42
	syscall #now a0 has random number in the range
	
	move	$v0, $a0
lw	$ra, 0($sp)
addi	$sp, $sp, 4
jr $ra