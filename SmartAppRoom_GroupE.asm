# GROUP E CAAL SEC 02
# SMART APP ROOM
# NURUL HANIS 1913364
# AIN SHAHEADA 1920162

.data


device:			.space 10  
motion: 		.byte 1, 0


welcome:		.asciiz	"____________________________ \n Hello, User! \n Welcome to Smart Room app! \n____________________________ \n" 
deviceask:		.asciiz	" Select a device by entering a number.  \n\t 1. Air Conditioner \n\t 2. Lamp \n\t 3. Fire Alarm \n ENTER THE NUMBER : "



#Light section
motiondetect:		.asciiz ". There is motion detected! \nThe light is ||ON||. "
nomotiondetect:		.asciiz ". There is no motion detected! \nThe light is ||OFF||. "

# temperature/AC section
getTempMsg1: .asciiz "Enter the current temperature (Celcius): "
niceTempMsg: .asciiz "\nNice temperature! Have a great day.<3"
getTempMsg2: .asciiz "\tRoom temperature is hot!\n\t!!!MORE THAN (or and equal to) 32 DEGREE CELCIUS!!!\n\t<<---AC ||ON|| --->>\n\tEnter your desired temperature (<32 degree Celcius):"

#smoke

.text

#--------------------------------------------
# selection screen
#--------------------------------------------


# Print out  welcome message 
la $a0,welcome
jal	PrintString

# Print out  welcome message 
la $a0,deviceask 
jal	PrintString

#Input from User, Enter device to connect to wifi
li $v0, 5
syscall


#--------------------------------------------
# temperature/AC section
#--------------------------------------------

TemperatureDetector:
	# Print out "Enter the current temperature (Celcius): "
	la	$a0, getTempMsg1
	jal	PrintString

inputTemp1:	
	#Get the current temperature from the user.
	#syscall read integer
	li	$v0,5
	syscall
	addi	$s1,$v0,0  #s1 has the user input

	#alerting the temperature input; hot or nice temperature to switch on AC.
	
	#if  temperature <32,
	#Print out a message string with the message "Nice temperature! Have a great day.<3"
	ble	$s1,31,inputNiceTemp #(input is <32)
	
	#if  temperature >=32,
hotTemp:
	bge	$s1,32,getDesiredTemp #(input is >=32)
	la	$a0,getTempMsg2
	jal	PrintString
	j	inputTemp1
	
getDesiredTemp:
   	blt	$s1,32,inputNiceTemp #(input is <32)
   	la	$a0,getTempMsg2
	jal	PrintString
	j	inputTemp2

inputTemp2:
	#Get the desired temperature from the user.
	#syscall read integer
	li	$v0,5
	syscall
	addi	$s2,$v0,0  #s2 has the new user input
	
inputNiceTemp:
	#Print out a message string with the message "Nice temperature! Have a great day.<3"
	la	$a0,niceTempMsg
	jal	PrintString



#--------------------------------------------
# Light section
#--------------------------------------------
light:

#Input for motion
li	$t1,0
motionin:
	lb	$s1,motion($t1)
	#to print the integer motion , 1. is motion detected, 0. is no motion detected
	li	$v0,1							
	addi	$a0,$s1,0
	syscall
	li	$v0,4					
	bge	$s1,1,detectmotion
	bge	$s1,0,detectnomotion

	
#Print action message when motion is detected, light will be switch on.	
detectmotion:								
	la	$a0,motiondetect
	j	End
	
#Print action message when no motion is detected, light will be switch off.
detectnomotion:								
	la	$a0,nomotiondetect
	j	End


#--------------------------------------------
# Smoke detector section
#--------------------------------------------





#--------------------------------------------
	
	
#end the program
End:
	li $v0, 10
	syscall

#procedure print String
PrintString:
	li	$v0,4
	syscall
	jr	$ra
	
#procedure print char
PrintChar:
	li	$v0,11
	syscall
	jr	$ra

#procedure print integer
PrintInt:
	li	$v0,1
	syscall
	jr	$ra
