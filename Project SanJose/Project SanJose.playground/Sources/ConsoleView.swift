import Foundation
import UIKit

/// The Consoleview is responsible for the console element of the game screen.
public class ConsoleView: UIView{
    
    // The textView that simulates the console.
    public var textView: UITextView!
    
    /// Initializes a new ConsoleView
    override init(frame: CGRect){
        super.init(frame:frame)
        initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    /// Initializes the components of the ConsoleView
    private func initialize(){
        // Sets the background color.
        self.backgroundColor = UIColor.init(red: 0.22, green: 0.38, blue: 0.54, alpha: 1.0)
        
        //Sets the custom font URL so it's possible to use it.
        let fontURL = Bundle.main.url(forResource: "VCROSDMono", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        
        // Instatiates the text view, definig it's position and size.
        textView = UITextView(frame: CGRect(x: 5, y: 5, width: 680, height: 380))

        // Sets the text view background color equal to the ConsoleView background.
        textView.backgroundColor = UIColor.init(red: 0.22, green: 0.38, blue: 0.54, alpha: 1.0)
        // Disables user direct edition on the text view to ensure the appropriate behaviour.
        textView.isEditable = false
        // Sets font, font size, text color and the content of the first append (initial text on the view).
        textView.font = UIFont(name: "VCROSDMono", size: 15)
        textView.textColor = UIColor(red:0.00, green:0.95, blue:1.00, alpha:1.0)
        textView.text.appendConsole("Hello there! Welcome to San Jose iSystems. \n  Please log in using the 'setUserName()' method.")
        // Adds text view to main console view.
        addSubview(textView)
    }
}
