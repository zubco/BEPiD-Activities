//:Screenplay - Project SanJose

print("Ask name")

// Insert name using the method below
setUserName("Example")
	//inside setUserName
		displayGreeting()
		// print possible commands and keep on view


//Begin story

//: There is a secret hidden inside this computer and it is you task to find it.
//: This secret can change the world as we see it...
//: It is your task to find it.
//: Would you like to accept this challenge?

talk("Accept/yes/no/decline")

//: You must find the right computer, find a way to connect to it and reach the secret.
//: Check your machine for any clues. To do so, use the listFiles() method.

listFiles()

// print a list of files
local_network.txt
FamilyPic.png //find an old pic online
ProjectS.A_Diary.txt 
myPasswords.txt

//: Use the method openFile("fileName") to open a file

local_network.txt contains:
MainServer [ACESS RESTRICTED]- IP Adress: 139.23.51.0
SecuritySystem - IP Adress: 139.315.125.1
LoganStation [PASSWD]- 
MaryStation [PASSWD]- 
BillStation [PASSWD]-

//: Figure out who has acess to the main server, try checking your files again
		//prints file again
		//Open Diary
		//prints a log that states that Logan Pierce has a temporary access to the MainServer

//: To acess logan computer, first disable it's password using the securitySystem. You probably have a password to the security level.
//: now use the method connectTo("computerName") to jump into his computer.

connectTo("LoganStation")
	//print connection success
	//print some security bullshit

//: Good, you're inside his station. Now check his files for any clues.

listFiles()

//prints the files.
PrjX Log.txt
wolverine_wallpaper.png //find wolverine picture online
bla
bla bla

openFile("PrjX Log.txt")
//Prints a small log that says some random project stuff and quotes the temporary password: cupertino

//: Great! Now we can use that password on the security system to unlock the main server
//: Connect to the main server using the connectTo method

connectTo("SecuritySystem")

disable("MainServer")
//asks password
password("cupertino")
//acess granted

connectTo("MainServer")

//Access granted

//: Wonderful!! Now, check the files and look for anything suspicious.

listFiles()

//prints
WWDC017.folder
Projects.folder

//projects is encrypted

openFolder("WWDC017")
//prints
//: Yes, this is it... Here are the secrets that are going to change the world!