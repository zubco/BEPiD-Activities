import Foundation
import UIKit

/** 
This class objects controls every command and its actions on the story.
For every command, there is a condition to be used, from being logged in to being on the right station.
Every command can be used multiple times in order to explore the game, however not all of them trigger an event connected to the storyline.
*/
public class Computer {
    // Receives a reference to the console TextView
    var textField:UITextView!
    // Stores the player username
    private var userName:String
    // Holds the story controller.
    private let story:StoryController
    
    /// Instantiates a new Computer.
    public init(_ txt: UITextView){
        self.userName = String()
        self.story = StoryController()
        self.textField = txt
    }
    
    /// Calculates the whole range of the text and scrolls it until it reaches the bottom, so the last appended string is visible to the user.
    private func scrollBottom(){
        let bottom = NSMakeRange(textField.text.characters.count-1,1)
        textField.scrollRangeToVisible(bottom)
    }
    
    /// Receives a string and saves it as the player userName. Also changes the loggedInLabel on the ViewController to match the inserted username.
    public func setUserName(_ name: String){
        // Only logs in if the player hasn't done it yet.
        guard(self.story.isLoggedIn == false) else{
            self.textField.text.appendConsole("You are already logged in.")
            return
        }
        // Stores the name properly.
        self.userName = name
        // Changes the story control parameter.
        self.story.isLoggedIn = true
        // Changes the loggedInLabel.
        ViewController.loggedInLabel.text = "Logged in as \(name)"
        // Prints a message for successful login on the screen.
        self.textField.text.appendConsole("Login successful!")
        // Scrolls so last message is visible.
        scrollBottom()
    }
    
    /** 
    This is the primary comunication method. It is used to answer questions and initiate conversations.
    If no event is triggered by the use of this method, only prints the same message on the screen.
    */
    public func echo(_ message: String){
        // Checks the conditions required for the command to work.
        guard(self.story.isLoggedIn == true && self.story.fileOpen == false) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            return
        }
        // Prints the player command using the proper formatting.
        self.textField.text.playerText(message, userName, self.story.usingComputer)
        // Prints the response.
        self.textField.text.appendConsole(message)
        // Starts checking the story control parameters.
        // If it's the first time the player uses the method, starts the questline by displaying the greeting message.
        if(self.story.isFirstEcho){
            self.story.isFirstEcho = false
            displayGreeting(userName)
        }
        // If the player accepts the quest, prints new instructions.
        if(message == "Yes" || message == "Accept Mission"){
            self.story.missionAccepted = true
            self.textField.text.appendConsole("GREAT!\n  You'll need to access the MainServer. However to do so you need a\n  password. Check the computer you're using for any clues. To list the\n  computer content, use the command 'content()'.")
        }
        // If the player refuses the quest, prints a response.
        if(message == "No"){
            self.textField.text.appendConsole("Oh... Okay, then...\n  Come back if you change your mind.")
        }
        // Scrolls to the end of the text.
        scrollBottom()
    }
    
    /// Displays the greeting message when the player uses the 'echo' command for the first time.
    private func displayGreeting(_ user: String){
        textField.text.appendConsole("Hello, \(user). There's a secret hidden in this computer. \n  This secret can change the world as we see it... \n  It is your task to find it. \n  Will you accept the challenge?\n  Please answer 'Yes/No'.")
    }
    
    /**
    Whenever this command is used, checks the computer being used and prints the accessible content of its hard drive.
    Does not work on certain conditions.
    */
    public func content(){
        // checks conditions for usage.
        guard(self.story.isLoggedIn == true && self.story.missionAccepted == true && self.story.fileOpen == false) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            if(self.story.missionAccepted == false){
                self.textField.text.appendConsole("You haven't accepted the quest I proposed. If you changed your mind, say 'Accept Mission'.")
            }
            return
        }
        // Prints the player command on the console.
        self.textField.text.playerText("content()", userName, self.story.usingComputer)
        // Depending on the computer being used, prints the content.
        switch self.story.usingComputer{
        case "TraineeStation":
            self.textField.text.appendConsole("To open a file, use the 'openFile(*filename.extension*)' method.\n  Content of TraineeStation:\n\n  FamilyPic.png -- a picture of your family\n  Project_SJ.log -- a diary document from one of your projects\n  Passwords.keychain -- a keychain file that stores your passwords.\n")
        case "LoganStation":
            //Only prints if the player have already unlocked with the usage of the password.
            if(self.story.loganUnlocked == true){
                self.textField.text.appendConsole("Content of LoganStation:\n\n  PrjSJ.log -- a diary document similar to the you found earlier.\n  wolverine.jpg -- a wallpaper of a fictional character.\n")
            }
            // If it hasn't, displays a warning message.
            else{
                self.textField.text.appendConsole("Enter the password first.")
            }
        case "MainServer":
            //Only prints if the player have already unlocked with the usage of the password.
            if(self.story.mainServerUnlocked == true){
                self.textField.text.appendConsole("Content of MainServer:\n\n  WWDC17 -- ???? \n  Projects -- a folder containing documents.\n")
            }
            // If it hasn't, displays a warning message.
            else{
                self.textField.text.appendConsole("Enter the password first.")
            }
        // The deafult message states an invalid computer is being used.
        default:
            self.textField.text.appendConsole("Invalid Computer!\n")
        }
        // After printing, scrolls to bottom.
        scrollBottom()
    }
    
    /**
    After listing the content of a station's hard drive, the player can open a file.
    This method provides responses to every listed file on every station of the game.
    Upon receiveing a fileName:String, the method selects the proper response.
    */    
    public func openFile(_ fileName: String){
        // Checks the usage conditions.
        guard(self.story.isLoggedIn == true && self.story.missionAccepted == true && self.story.fileOpen == false) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            if(self.story.missionAccepted == false){
                self.textField.text.appendConsole("You haven't accepted the quest I proposed. If you changed your mind, say 'Accept Mission'.")
            }
            return
        }
        // Prints the player command on the console.
        self.textField.text.playerText("openfile(\(fileName))", userName, self.story.usingComputer)
        // Selects the file response based on its name.
        // For every file checks the computer being used, so it doesn't create incompatible file accesses.
        switch fileName{
        case "Project_SJ.log":
            if(self.story.usingComputer == "TraineeStation"){
                // Prints the content of the file.
                self.textField.text.appendConsole("Last entry of \(fileName):\n\n  Day 23 - Monday\n  The project status is the same... The test results were inconclusive, so\n  we'll need to use the MainServer to perform a more consistent test.\n  Luckily, Logan Pierce has a temporary access to the MainServer.\n ")
                //And triggers a story dialog:
                self.textField.text.appendConsole("Wonderful! Now you must access Logan's Station. To do so, disable it's\n  protection on the SecuritySystem.\n  You should have the password to bypass security. Use the 'network()'\n  command to see the avaiable connections.\n  Then use the 'connecTo(*computerName*)' command to connect to another\n  station.\n")
            }
        case "FamilyPic.png":
            // In this case, make the image view (isntantiated on the ViewController) visible.
            if(self.story.usingComputer == "TraineeStation"){
                self.textField.text.appendConsole("Opening image \(fileName)...\n\n")
                ViewController.familyPhoto.isHidden = false
                // With this parameter turned on, some methods are disabled.
                self.story.fileOpen = true
            }
        case "Passwords.keychain":
            if(self.story.usingComputer == "TraineeStation"){
                // Prints the content of the file.
                self.textField.text.appendConsole("Passwords stored:\n\n  SecuritySystem - hive.ssa\n  Bank - 674523\n  Facebook - clarissa07")
            }
        case "PrjSJ.log":
            if(self.story.usingComputer == "LoganStation" && self.story.loganUnlocked == true){
                // Prints the content of the file.
                self.textField.text.appendConsole("Last entry of \(fileName):\n\n  Day 27 - Saturday\n  Working on saturday so I can use the MainServer to run the additional test... Using the password 'cupertino', I was able to access the main computer with no problem. Still waiting for the results to come up.\n")
                //And triggers a story dialog:
                self.textField.text.appendConsole("Outstanding! Now connect to the MainServer and use the password to have the access we need!")
            }
        case "wolverine.jpg":
            // In this case, make the image view (isntantiated on the ViewController) visible.
            if(self.story.usingComputer == "LoganStation" && self.story.loganUnlocked == true){
                self.textField.text.appendConsole("Opening image \(fileName)...\n\n")
                ViewController.wolverinePhoto.isHidden = false
                // With this parameter turned on, some methods are disabled.
                self.story.fileOpen = true
            }
        case "WWDC17":
            if(self.story.usingComputer == "MainServer" && self.story.mainServerPass == true){
                // Opening this file trrigers the game ending view to show up and end the simulation.
                ViewController.endingView.isHidden = false
                // Disables most commands by logging off the computer.
                self.story.isLoggedIn = false
                // Since this view cannot be disabled, it doesn't make a difference if the user keeps adding commands, they won't show up.
            }
        case "Projects":
            if(self.story.usingComputer == "MainServer" && self.story.mainServerPass == true){
                // Prints a message in response to opening this folder.
                self.textField.text.appendConsole("The Projects folder is encrypted. You can't open that.")
            }
        default:
            // By default prints a message stating the file is invalid.
            self.textField.text.appendConsole("Invalid file.")
        }
        scrollBottom()
    }
    
    /// This method only hides the image views revealed upon opening their files.
    public func closeFile(){
        // Checks the usage conditions.
        guard(self.story.isLoggedIn == true && self.story.missionAccepted == true && self.story.fileOpen == true) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            if(self.story.missionAccepted == false){
                self.textField.text.appendConsole("You haven't accepted the quest I proposed. If you changed your mind, say 'Accept Mission'.")
            }
            if(self.story.fileOpen == false){
                self.textField.text.appendConsole("There is nothing to close.")
            }
            return
        }
        // Prints the player command on the console.
        self.textField.text.playerText("closeFile()", userName, self.story.usingComputer)
        // Turns down the flag to enable the use of other methods.
        self.story.fileOpen = false
        // Ensures both image views are hidden.
        ViewController.familyPhoto.isHidden = true
        ViewController.wolverinePhoto.isHidden = true
        // Prints a message confirming the action.
        self.textField.text.appendConsole("Closing file...")
        // Scrolls text to bottom.
        scrollBottom()
    }
    
    /// Upon using this command on any computer, lists the computer network as possible connections.
    public func network(){
        // checks usage conditions
        guard(self.story.isLoggedIn == true && self.story.missionAccepted == true && self.story.fileOpen == false) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            if(self.story.missionAccepted == false){
                self.textField.text.appendConsole("You haven't accepted the quest I proposed. If you changed your mind, say 'Accept Mission'.")
            }
            return
        }
        // Prints player command on console.
        self.textField.text.playerText("network()", userName, self.story.usingComputer)
        // Prints all stations information.
        self.textField.text.appendConsole("Avaiable connections:\n\n  MainServer [ACCESS RESTRICTED]\n  SecuritySystem [ACCESS RESTRICTED]\n  LoganStation [PASSWORD PROTECTED]\n  MaryStation [PASSWORD PROTECTED]\n  BillStation [PASSWORD PROTECTED]\n  TraineeStation [LOGGED IN] ")
        // Scrolls text to bottom.
        scrollBottom()
    }
    
    /**
    This command allows connection to another station/computer. It receives a string and uses it to determine which station to jump in to.
    Every station has its own conditions for connection and/or usage. The access will be confirmed/rejected by the console response.
    */
    public func connectTo(_ computer: String){
        // Checks usage parameters.
        guard(self.story.isLoggedIn == true && self.story.missionAccepted == true && self.story.fileOpen == false) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            if(self.story.missionAccepted == false){
                self.textField.text.appendConsole("You haven't accepted the quest I proposed. If you changed your mind, say 'Accept Mission'.")
            }
            return
        }
        // Prints command on console.
        self.textField.text.playerText("connectTo(\(computer))", userName, self.story.usingComputer)
        if(computer == self.story.usingComputer){
            // If it's the same computer the player is using, prints error message.
            self.textField.text.appendConsole("You are already using this computer.")
        }
        else{
            // If not, choses an action based on the computer used.
            switch computer{
            case "SecuritySystem":
                // Although connected to the SecuritySystem, one must still use a password to acess its commands.
                self.textField.text.appendConsole("You are now connected to \(computer).\n  Enter the password using the 'password(*key*)' command.")
                // Updates the current using computer.
                self.story.usingComputer = computer
            case "LoganStation":
                // Checks if the player can connect to that station.
                if(self.story.loganUnlocked){
                    // If so, prints connection message and updates the usingComputer.
                    self.textField.text.appendConsole("You are now connected to \(computer).\n")
                    self.story.usingComputer = computer
                }
                else{
                    // If not, prints error message.
                    self.textField.text.appendConsole("Access Denied!")
                }
            case "MainServer":
                // Checks if player can access MainServer
                if(self.story.mainServerUnlocked){
                    // if yes, prints a warning about password requirement.
                    self.textField.text.appendConsole("You are now connected to \(computer).\n  Enter the password using the 'password(*key*)' command.")
                    // Updates current computer.
                    self.story.usingComputer = computer
                }
                else{
                    // Prints error message if player can't access this station yet.
                    self.textField.text.appendConsole("Access Denied!")
                }
            case "TraineeStation":
                // This is the primary station. Always grants access and prints successful message.
                self.textField.text.appendConsole("You are now connected to \(computer).")
                // Updates the current computer.
                self.story.usingComputer = computer
            default:
                // if any other station tries to be accessed, their access will be denied.
                self.textField.text.appendConsole("Access Denied!")
            }
        }
        // After printing any information, scrolls text to bottom.
        scrollBottom()
    }
        
    /**
    This command is used to access password protected stations such as the SecuritySystem and the MainServer.
    It receives a string as parameter and compares the incoming string to the set passwords.
    */
    public func password(_ passwd: String){
        // checks the usage conditions
        guard(self.story.isLoggedIn == true && self.story.missionAccepted == true && self.story.fileOpen == false && (self.story.usingComputer == "SecuritySystem" || self.story.usingComputer == "MainServer")) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            else if(self.story.missionAccepted == false){
                self.textField.text.appendConsole("You haven't accepted the quest I proposed. If you changed your mind, say 'Accept Mission'.")
            }
            else if(self.story.usingComputer != "SecuritySystem" || self.story.usingComputer != "MainServer"){
                self.textField.text.appendConsole("Command unavailable.")
            }
            return
        }
        // Prints the command on the console.
        self.textField.text.playerText("password(\(passwd))", userName, self.story.usingComputer)
        //depending on the computer being used, chooses action
        switch(self.story.usingComputer){
        case "SecuritySystem":
            // Compares the password with a given value.
            if (passwd == "hive.ssa"){
                // If correct, triggers a story event, updates its story controller parameter and prints a dialog.
                self.story.securityBypassed = true
                self.textField.text.appendConsole("You are now have acess to \(self.story.usingComputer).\n  You may use the 'disable(*computerName*)' command to disable the security\n  on that station.")
                if(self.story.securityFirstAccess){
                    // if it is the first time the player accesses the SecuritySystem, a special message is displayed as a story dialog indicating the next steps. The first access parameter is, then, turned false.
                    self.story.securityFirstAccess = false
                    self.textField.text.appendConsole("Very good. Now disable the security on LoganStation and the special access\n  requirement for the MainServer with the 'disable()' command.")
                }
            }else {
                // if the passwords don't match, prints an error message.
                self.textField.text.appendConsole("Password is incorrect!")
            }
        case "MainServer":
            // Compares the password with a given value.
            if(passwd == "cupertino"){
                // If it matches, triggers a story event and displays the proper dialog.
                self.story.mainServerPass = true
                self.textField.text.appendConsole("Amazing! I never thought you would come this far!\n  Uh... Sorry about that...\n  Okay, now check the contents of this station and see if you can find what we've been looking for all along.")
            }
            else {
                // If wrong, prints error message.
                self.textField.text.appendConsole("Password is incorrect!")
            }
        default:
            // The default case prints a command unavailable message.
            self.textField.text.appendConsole("Command unavailable.")
        }
        // After printing the info, scrolss to bottom.
        scrollBottom()
    }

    /**
    This method only works when the player is using the SecuritySystem computer.
    It disables one layer of security on the designated station (parameter input).
    */  
    public func disable(_ computer: String){
        //Checks usage conditions.
        guard(self.story.isLoggedIn == true && self.story.missionAccepted == true && self.story.fileOpen == false && self.story.usingComputer == "SecuritySystem" && self.story.securityBypassed == true) else{
            if(self.story.isLoggedIn == false){
                self.textField.text.appendConsole("You are not logged in.")
            }
            else if(self.story.missionAccepted == false){
                self.textField.text.appendConsole("You haven't accepted the quest I proposed. If you changed your mind, say 'Accept Mission'.")
            }
            else if(self.story.usingComputer != "SecuritySystem"){
                self.textField.text.appendConsole("Command unavailable.")
            }
            return
        }
        // Prints the player command on the console.
        self.textField.text.playerText("disable(\(computer))", userName, self.story.usingComputer)
        // Checks the computer being targeted.
        switch(computer){
        case "LoganStation":
            // Removes the protection on LoganStation, allowing access.
            self.story.loganUnlocked = true
            // Prints success message.
            self.textField.text.appendConsole("\(computer) has been unlocked.")
        case "MainServer":
            // Removes MainServer first layer of protection.
            self.story.mainServerUnlocked = true
            // Prints success message.
            self.textField.text.appendConsole("\(computer) has been unlocked.\n  However you still need a password to have full access.")
            // Prints a story dialog.
            self.textField.text.appendConsole("Great! Now let's get that password! Connect to LoganStation!")
        default:
            // Prints an error message by default.
            self.textField.text.appendConsole("ACCESS DENIED")
        }
        // Scrolls bottom after printing the info.
        scrollBottom()
    }
}
