# GROUP E CAAL SEC 02
# SMART APP ROOM
# NURUL HANIS 1913364
# AIN SHAHEADA 1920162

	.data


device:			.space 10  
motion: 		.byte 1


welcome:		.asciiz	"____________________________ \n Hello, User! \n Welcome to Smart Room app! \n____________________________ \n" 
deviceask:		.asciiz	" Select a device by entering a number.  \n\t 1. 5Gwifi \n\t 2. Ain's Iphone \n ENTER THE NUMBER : "



#Light section
motiondetect:		.asciiz ". There is motion detected! \n \tThe light is switch on. "

# temperature/AC section
getTempMsg: .asciiz "Enter the current temperature (Celcius): "
niceTempMsg: .asciiz "\nNice temperature! Have a great day.<3"
hotTempMsg: .asciiz "Room temperature is hot!\n!!!MORE THAN 32 DEGREE CELCIUS!!!\n\t<<---AC ||ON|| --->>\n\tEnter your desired temperature:"

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
	la	$a0, getTempMsg
	jal	PrintString

togetTemp1:	
	#Get the current temperature from the user.
	#syscall read integer
	li	$v0,5
	syscall
	addi	$s1,$v0,0  #s1 has the user input
	
	#alerting the temperature input, hot or nice temperature to switch on AC.
	bgt	$s1,31,getDesiredTemp #(input is >=32)
	la	$a0,hotTempMsg
	jal	PrintString
	j	togetTemp1
	
getDesiredTemp:
   	blt	$s1,32,inputNiceTemp #(input is <32)
	la	$a0,hotTempMsg
	jal	PrintString
	j	togetTemp1

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
	li	$v0,1							#to print integer
	addi	$a0,$s1,0
	syscall
	jal	PrintString						#to print string
	bge	$s1,1,detectmotion

detectmotion:								#motion is detected
	la	$a0,motiondetect
	j	End



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
