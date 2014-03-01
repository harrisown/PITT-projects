Harrison Bryant
hsb18@pitt.edu

Snake Game

Variables
	$t7 always held the size of the snake, this was used as an offset when finding the tail to erase after each iteration.
	
	$s4 and $s5 registers held the X and Y values for the head of the snake. It was applicable to have a global variable for such a thing just to facilitate cross-method functions.
	
	$v1 was used as a "Frog Eaten" counter. Essentially, when this value hit 32, the game would be over because there would be no more frogs on the screen. Within my initiation of frogs on the screen, if there so happens to be duplicate frogs placed, this variable is increased by one in order to offset the value and end the game correctly.
	
	$t8 was used as the compass of the game. Depending on its value (0,1,2,3), that is the direction that the snake was going. This was useful for the different movement patterns and turns. 

General Algorithm
	The general algorithm for my project was quite simple. At first, I initialized the frogs using a random number generator. I generated 32 X's and 32 Y's, paired them up, and used the _setLED function to paste the frogs to the screen.
	
	Next, I initialized my snake with the default values given in the assignment, and substituted null values with -1's in the data section for placeholders. I used the setLED function again to paste the snake, and hence begins my game.
	
	A polling loop was initiated by setting the current direction to right and initiating the compass value of $t8
	
	The polling loop starts each movement iteration, always checking for a keypress. If no keypress occurs, the snake moves one place based on the current direction. 
		Each directional movement method is where most of the program happens. Each method takes in the X value of the tail and head, and first offsets that value by the length to get the head of the snake. From there, you peek at the next value. If the value is out of bounds, an appropriate offset is applied. Additionally, a few other checks are made. By using the _getLED function, I was able to check for frogs, or hitting itself. 
		
		HITFROG: If LED value for the next space is green, then simply run over it and increase the "Frogs Eaten" variable by 1. Also, don't erase the value of the tail if such occurs, which accounts for increasing the snake's size by 1. 
		
		HIT SELF: If LED value for next space is yellow, then break out of the game and prompt a loss and the corrosponding endgame values.
		
	With each move, the snake in memory is updated to reflect the positional changes on the LED screen, additionally, the game pauses for 200MS at the end of every movement so that the game is tame and playable. 
	
	To account for the movement restrictions, I applied some "skip" style methods based upon the current direction of movement ($t8), which would ignore parallel presses if moving left or right, and vertical presses if already  moving up or down. 
	
	
	If I am forgetting anything, or you have any questions with my implementation, please let me know and I would be glad to explain what I did to you. 