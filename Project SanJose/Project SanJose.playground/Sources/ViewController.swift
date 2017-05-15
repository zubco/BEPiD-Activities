import Foundation
import UIKit

///The ViewController class instantiates and manages the views to compose the game environment.

public class ViewController{
    
    // This is the view controller main view.    
    public var view: UIView
    // The HeaderView is responsible for the upper elements on the game screen.
    public var headerView:HeaderView
    // The Consoleview is responsible for the console element of the game screen.
    public var consoleView:ConsoleView
    // The EndingView is responsible for displaying the game-ending screen.
    public static var endingView:EndingView!
    // The label that contains the login information. It is static so it can be changed easily.
    public static var loggedInLabel: UILabel!
    // Declaration of two image view that hold the image files contained on the stations.
    public static var familyPhoto: UIImageView!
    public static var wolverinePhoto: UIImageView!
    
    /// Instantiates a ViewController and all its components.
    public init() {
        // Sets the main view size, position and backgroundColor
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: 720, height: 600))
        self.view.backgroundColor = UIColor.init(red: 0.22, green: 0.38, blue: 0.54, alpha: 0.75)
        
        // instantiates a header view and adds it to the main view.
        headerView = HeaderView(frame: CGRect(x: 15, y: 10, width: 690, height:166))
        self.view.addSubview(headerView)
        
        // Instantiates the logged in label and positions it correctly.
        ViewController.loggedInLabel = UILabel(frame: CGRect(x: 150, y: 55, width: 680, height: 160))
        // Sets the font, size and color.
        ViewController.loggedInLabel.font = UIFont(name: "VCROSDMono", size: 15)
        ViewController.loggedInLabel.textColor = UIColor(red:0.00, green:0.95, blue:1.00, alpha:1.0)
        // Initially the text says that the user is not logged in.
        ViewController.loggedInLabel.text = "Not logged in."
        // adds label to main view
        self.view.addSubview(ViewController.loggedInLabel)

        // Instantiates the ConsoleView and adds it to the main view
        consoleView = ConsoleView(frame: CGRect(x: 15, y: 186 , width: 690, height:400))
        self.view.addSubview(consoleView)
        
        // Instantiates the header icon and sets its size, position and image.
        let headerIconView = UIView(frame: CGRect(x: 35, y:35, width: 0, height: 0 ))
        let image = UIImage(named: "Computer.png")
        headerIconView.addSubview(UIImageView(image: image))
        //Adds it to the main view.
        self.view.addSubview(headerIconView)
        
        // Instantiates the first photo, sets the appropriate size and initializes the image.
        ViewController.familyPhoto = UIImageView(frame: CGRect(x: 0, y: 25, width: 720, height: 456))
        ViewController.familyPhoto.image = UIImage(named: "family.jpg")
        // Makes it hidden until it is openned by the user.
        ViewController.familyPhoto.isHidden = true
        self.view.addSubview(ViewController.familyPhoto)
        
        // Instantiates the second photo, sets the appropriate size and initializes the image.
        ViewController.wolverinePhoto = UIImageView(frame: CGRect(x: 0, y: 98, width: 720, height: 432))
        ViewController.wolverinePhoto.image = UIImage(named: "wolverine.jpg")
        // Makes it hidden until it is openned by the user.
        ViewController.wolverinePhoto.isHidden = true
        self.view.addSubview(ViewController.wolverinePhoto)
        
        // Instantiates the ending view and hides it until the game ends.
        ViewController.endingView = EndingView(frame: CGRect(x: 0, y: 0, width: 720, height: 600))
        ViewController.endingView.isHidden = true
        self.view.addSubview(ViewController.endingView)
    }
    
}
