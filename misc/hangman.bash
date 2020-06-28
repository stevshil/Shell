#!/bin/bash
# Hangman
clear

# Welcome screen
tput cup 10 23 ; echo -- "    Welcome to Hangman"
tput cup 11 23 ; echo -- "Written by Steve shilling"
tput cup 14 23 ; echo -- "   Date: 11th Jan 2001"
SCORE=0

sleep 3
while :		# Start game loop until no more
do

clear

# Set up vars
WORDS="./words.txt"
THEWORDS=$(wc -l < $WORDS)
guessed=12
found=1
unset again
unset guesses
#set -A displayed

# The hang
base="|_____"
base2="|<_____"
side="|"
top="|--------"
top2="|/-------"
rope="|       |"
head="|       O"
body="|       |"
body1="|      -|"
body2="|      -|-"
leg1="|       /"
leg2="|       /\\"


# Each letter guessed will be stored in an array.
# a = element 1 z = element 26
# Compare elements for empty, if not then user has already guessed
a=1; b=2; c=3; d=4; e=5; f=6; g=7; h=8; i=9; j=10; k=11; l=12; m=13; n=14
o=15; p=16; q=17; r=18; s=19; t=20; u=21; v=22; w=23; x=24; y=25; z=26

# get word from dictionary
((rand=$RANDOM%$THEWORDS))
typeset -l theword
theword=$(sed "1,${rand}d" $WORDS | head -1)

# Print underscores for word
prx=1
while (( prx <= ${#theword} ))
do
	tput cup 10 $prx ; echo -n "_"
	(( prx=prx+1 ))
done
# Tokenise the word
#integer count=1
count=1

for letter in $(echo $theword | sed 's/./& /g')
do
	thestr[$count]=$letter
	(( count=count+1 ))
done

# Start program guess
while (( guessed != 0 && found != 0 ))
do
	tput cup 20 0 ; echo "                                                                                "
	tput cup 20 0 ; echo -n "Your guess: "
	read
	if (( ${#REPLY} > 1 ))
	then
		continue
	fi

	if [[ $REPLY != +([a-z]) ]]
	then
		continue
	fi

	userguess=$(eval echo \$${REPLY})

	# Check to see if letter has already been used
	if [[ -z $REPLY ]]
	then
		continue
	fi
	if [[ -n ${guesses[$userguess]} ]]
	then
		tput cup 21 0; echo -- "Already guessed this letter"
		sleep 2 ; tput cup 21 0 ; echo "                           "
	else
		# Add letter to user guess
		guesses[$userguess]=$REPLY

		# If matched echo the letter that has been matched on screen
		chcount=0
		good=0
		for checker in $(echo ${thestr[@]})
		do
			(( chcount=chcount+1 ))
			if [[ "$checker" == "$REPLY" ]]
			then
				displayed[$chcount]=$REPLY
				good=1
			fi
		done

		# Remove one from the guess
		if (( $good == 0 ))
		then
			# Print the hang 12 guesses
			case $guessed in
				12) tput cup 8 0 ; echo -- "$base";;
				11) tput cup 8 0 ; echo -- "$base2";;
				10)  tput cup 7 0 ; echo -- "$side"
				    tput cup 6 0 ; echo -- "$side"
				    tput cup 5 0 ; echo -- "$side"
				    tput cup 4 0 ; echo -- "$side"
				    tput cup 3 0 ; echo -- "$side"
				    tput cup 2 0 ; echo -- "$side"
					;;
				9)  tput cup 1 0 ; echo -- "$top";;
				8)  tput cup 1 0 ; echo -- "$top2";;
				7)  tput cup 2 0 ; echo -- "$rope";;
				6)  tput cup 3 0 ; echo -- "$head";;
				5)  tput cup 4 0 ; echo -- "$body";;
				4)  tput cup 4 0 ; echo -- "$body1";;
				3)  tput cup 4 0 ; echo -- "$body2";;
				2)  tput cup 5 0 ; echo -- "$leg1";;
				1)  tput cup 5 0 ; echo -- "$leg2";;
			esac

			(( guessed=guessed-1 ))
		fi

		# check to see if displayed is same length as word
		if (( ${#displayed[@]} == ${#theword} ))
		then
			found=0
		fi
	fi

	# Show guesses and guesses left
	tput cup 15 0 ; echo -- "Guesses left: $guessed "
	tput cup 18 0 ; echo -- "${guesses[@]}"
	tput cup 16 0 ; echo -- "$SCORE"

	# Display word to user
	prv=0
	while (( prv <= ${#theword} ))
	do
		tput cup 10 $prv
		if [[ -n ${displayed[$prv]} ]]
		then
			echo -n "${displayed[$prv]}"
		else
			if (( $prv != 0 ))
			then
				echo -n "_"
			fi
		fi
		(( prv=prv+1 ))
	done

done

tput cup 23 0
if (( $guessed == 0 ))
then
	echo -- "The word was $theword"
else
	(( SCORE=SCORE+$guessed ))
	echo -- "Congratulations, you guessed $theword correctly"
fi

# Ask user for another go
typeset -l again=j
while [[ $again != y && $again != n ]]
do 
	echo -n "Play again (y/n): "
	read again
done

if [[ $again == n ]]
then
	break
fi

done	# End game loop

clear
echo -- "You've finally stopped hanging around!"
echo -- "TTFN"
