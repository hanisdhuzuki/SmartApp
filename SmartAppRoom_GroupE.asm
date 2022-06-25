# GROUP E CAAL SEC 02
# SMART ROOM APP
# NURUL HANIS 1913364
# AIN SHAHEADA 1920162

.data

#data for detection
device:			.space 10  
motion: 		.byte 1, 0

#selection screen
welcome:		.asciiz	"____________________________ \n Hello, User! \n Welcome to Smart Room app! \n____________________________ \n" 
deviceask:		.asciiz	" \n\nSelect a device by entering a number.  \n\n\t 1. Air Conditioner \n\t 2. Light Bulb \n\t 3. Fire Alarm \n\n ENTER A NUMBER (1/2/3) : "
connection:		.asciiz "\n\nWifi connection? (Y/N): "
wrongMsg:		.asciiz "\n\n\t\<<----!!!!!!		INVALID		!!!!!!---->\n\t\<<----!!!!!!	ENTER THE INPUT AGAIN	!!!!!!---->"

#Light section
motiondetect:		.asciiz ". There is motion detected! \nThe light is ||ON||. "
nomotiondetect:		.asciiz ". There is no motion detected! \nThe light is ||OFF||. "

# temperature/AC section
getTempMsg1: 		.asciiz "Enter the current temperature (Celcius): "
niceTempMsg: 		.asciiz "\nNice temperature! Have a great day.<3"
getTempMsg2: 		.asciiz "\tRoom temperature is hot!\n\t!!!MORE THAN (or and equal to) 32 DEGREE CELCIUS!!!\n\t<<---AC ||ON|| --->>\n\tEnter your desired temperature (<32 degree Celcius):"

#smoke
getSmoke:		.asciiz "Smoke? (Y/N): "
gasvalue: 		.byte 250

alertON:		.asciiz "\n\t------------------------------------------\n\t\t\t WARNING!!!! \n\t\t GAS VALUE IS HIGH!!!!! \n\n \t\t<<--- BUZZER ||ON|| --->>\n\t\t<<--- LED ||ON|| ---> \n\t ------------------------------------------\n"
alertOFF:		.asciiz "\n\t------------------------------------------\n\ \n\t\t GAS VALUE IS NORMAL \n\n \t\t<<--- BUZZER ||OFF|| --->>\n\t\t<<--- LED ||OFF|| ---> \n\t ------------------------------------------\n"
askalarm:		.asciiz "\n\t------------------------------------------\n\ \n\t\t TURN OFF ALARM? \n\t\t  Enter number 1, for turn off alarm, enter number 2, to not turn off the alarm  \n\t ------------------------------------------\n"
alarmOFF:		.asciiz "\n\t-----------------------------\n\ \n\t ALARM OFF  \n\t -----------------------------\n"
noturnoffalarm: 	.asciiz "\n\t-----------------------------\n\ \n\t ALARM ON  \n\t -----------------------------\n"


.text

#-------------------------------------------------------------
# selection screen
#-------------------------------------------------------------

# Print out  welcome message 
	la 	$a0,welcome
	jal	PrintString

wifi:
# Print out  "Wifi connection? (Y/N)" 
	la 	$a0,connection 
	jal	PrintString

	li	$v0,12
	syscall #read char
	
	addi	$t1,$v0,0
	beq	$t1,'Y',selectDevice #if user enters Y, then go to Selection
	beq	$t1,'y',selectDevice #if user enters y, then go to Selection
	beq	$t1,'N',wifi #if user enters N, then go to selectDevice
 	beq	$t1,'n',wifi #if user enters n, then go to selectDevice
 	la	$a0,wrongMsg
	jal	PrintString
	j	selectDevice	

#device selection by the user
selectDevice:
	la 	$a0,deviceask 
	jal	PrintString

selectedDevice:
	#Get input from User,to enter a number from 1 to 3
	#syscall read integer
	li 	$v0, 5
	syscall
	addi	$s1,$v0,0  #s1 has the user input

	move	$t4, $v0# move user input into t4
	addi 	$t5, $zero, 1
	addi	$t6, $zero, 2
	addi	$t7, $zero, 3		# add each of these to use for comparison below
	beq	$t4, $t5, TemperatureDetector
	beq	$t4, $t6, light
	beq	$t4, $t7, firealarm
	
#-------------------------------------------------------------
# temperature/AC section
#-------------------------------------------------------------
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

#-------------------------------------------------------------
# Light/motion detection section
#-------------------------------------------------------------
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
	la	$a0,motiondetect
	j	End

#-------------------------------------------------------------
# Fire alarm/Smoke detector section
#-------------------------------------------------------------
firealarm:

#Input for gas value
	li	$t1,0
smokein:
	lb	$s1,gasvalue($t1)
	#to print the integer smoke value
	li	$v0,1							
	addi	$a0,$s1,0
	syscall
	li	$v0,4	
				
	bge	$s1,300,highgasvalue 	#If gas value higher or equal 300 
 	blt 	$s1,300,lowgasvalue	#If gas value lower than 300
		
#Print action message when gas value is high
highgasvalue:							
	la	$a0,alertON
	j	askturnoffalarm
		
#Ask user if they want to turn off the alarm 
askturnoffalarm:	
	la	$a0,askalarm
	
yesoffalarm:	
	#syscall read integer
	li	$v0,5
	syscall
	addi	$s1,$v0,0 
	
	#if  user enter 1, message will display
	ble	$s1,2,turnoffalarm 
	
turnoffalarm:	
	la	$a0,alarmOFF
	
nooffalarm:
	beq	$s1,2,noturnoffalarm
	j	End
	
#Print action message when gas value is low	
lowgasvalue:							
	la	$a0,alertOFF
	j	End

#--------------------------------------------

#FUNCTIONS		
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
