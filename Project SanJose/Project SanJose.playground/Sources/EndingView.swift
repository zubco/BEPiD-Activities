import Foundation
import UIKit

/// This class instantiates the last screen displayed on the game.
public class EndingView: UIView{
    // The textView is used to display a message from the AI.
    private var textView:UITextView!
    // Holds a UIImageView to fill the background
    private var backgroundImage:UIImageView!
    // Holds the label for the WWDC17 text.
    private var wwdcLabel:UILabel!
    // Holds the catchphrase.
    private var subtitleLabel:UILabel!
    
    /// Instantiates an EndingView.
    override init(frame: CGRect){
        super.init(frame: frame)
        initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    /// Initializes every component on the EndingView.
    private func initialize(){
        // Instantiates the UIImageView defining its size.
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 720, height: 600))
        // Defines the background image file
        backgroundImage.image = UIImage(named: "bg.png")
        // Adds the Image to the EndingView
        self.addSubview(backgroundImage)
        
        // Instantiates the textView defining its size.
        textView = UITextView(frame: CGRect(x: 10, y: 10, width: 700, height: 50))
        // Sets the background color to match the standard layout.
        textView.backgroundColor = UIColor.init(red: 0.22, green: 0.38, blue: 0.54, alpha: 1.0)
        
        // Sets the font URL so it can be used.
        let fontURL = Bundle.main.url(forResource: "VCROSDMono", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

        // Sets the text font, font size and text color.
        textView.font = UIFont(name: "VCROSDMono", size: 25)
        textView.textColor = UIColor(red:0.00, green:0.95, blue:1.00, alpha:1.0)
        
        // Disables the text edition on the text view.
        textView.isEditable = false
        
        // Appends a congratulations message to the text view.
        textView.text.appendConsole("YOU HAVE MADE IT! WELCOME TO THE...")
        addSubview(textView)
        
        //Instantiates the wwdcLabel, setting its size, position, color and content. Finally adds it to the view.
        wwdcLabel = UILabel(frame: CGRect(x: 100 , y: 35, width: 700, height:400))
        wwdcLabel.font = UIFont(name: "VCROSDMono", size: 150)
        wwdcLabel.textColor = UIColor(red:0.00, green:0.95, blue:1.00, alpha:1.0)
        wwdcLabel.text = "WWDC17"
        addSubview(wwdcLabel)
        
        //Instantiates the subtitleLabel, setting its size, position, color and content. Finally adds it to the view.
        subtitleLabel = UILabel(frame: CGRect(x: 35 , y: 200, width: 700, height: 400))
        subtitleLabel.font = UIFont(name: "VCROSDMono", size: 50)
        subtitleLabel.textColor = UIColor(red:0.00, green:0.95, blue:1.00, alpha:1.0)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Where great minds meet\n and change the world!"
        addSubview(subtitleLabel)
    }
}
