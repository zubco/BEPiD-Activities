import Foundation

///The StoryController manages the quest storyline.
public class StoryController{
    // Login information
    var isLoggedIn:Bool = false
    
    //Story milestones - control the storyline flow and restraints the usage of some methods.
    // If the first contact has been estabilished, turns false.
    var isFirstEcho:Bool = true
    // If the player accepts the mission, turns true and starts the quest
    var missionAccepted:Bool = false
    // If the player accesses the SecuritySystem for the first time it turns false
    var securityFirstAccess:Bool = true
    // Turns true when the player manages to enter the correct password on the SecurityServer
    var securityBypassed:Bool = false
    // Turns true when the player disables security from LoganStation
    var loganUnlocked:Bool = false
    // Turns true when the player disables the first layer of the MainServer security
    var mainServerUnlocked:Bool = false
    // Turns true when the player manages to enter the correct password on the MainServer
    var mainServerPass:Bool = false
    
    // Stores the name of the computer being used. Limits the usage of a few commands.
    var usingComputer:String = "TraineeStation"
    // Turns true if a file is open (only to control images)
    var fileOpen:Bool = false
}
