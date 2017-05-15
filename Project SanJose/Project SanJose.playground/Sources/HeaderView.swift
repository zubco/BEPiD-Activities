
import Foundation
import UIKit

// The HeaderView is responsible for the upper elements on the game screen.
public class HeaderView: UIView{
    
    // Label containing the welcome text.
    private var mainLabel: UILabel!
    // Label containing the title.
    private var titleLabel: UILabel!

    ///Initializes a HeaderView
    override init(frame: CGRect){
        super.init(frame:frame)
        initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    /// This method intializes the internal components of the HeaderView
    private func initialize(){
        //Sets the backgroundColor.
        self.backgroundColor = UIColor.init(red: 0.22, green: 0.38, blue: 0.54, alpha: 1.0)
        
        //Sets the custom font URL so it's possible to use it.
        let fontURL = Bundle.main.url(forResource: "VCROSDMono", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        
        // Initializes the title label, defining its size, font, font size, text color and text content.
        titleLabel = UILabel(frame: CGRect(x: 150, y: -30, width: 680, height: 160))
        titleLabel.font = UIFont(name: "VCROSDMono", size: 25)
        titleLabel.textColor = UIColor(red:0.00, green:0.95, blue:1.00, alpha:1.0)
        titleLabel.text = "San Jose iSystems"
        //Adds the label to the view.
        addSubview(titleLabel)
        
        // Initializes the main label, defining its size, font, font size, text color and text content.
        mainLabel = UILabel(frame: CGRect(x: 150, y: 10, width: 680, height: 160))
        mainLabel.font = UIFont(name: "VCROSDMono", size: 15)
        mainLabel.numberOfLines = 0
        mainLabel.text = "This is a private facility. \nRemember to respect your co-workers and their privacy. \nWelcome to the internal system."
        mainLabel.textColor = UIColor(red:0.00, green:0.95, blue:1.00, alpha:1.0)
        //Adds the label to the view.
        addSubview(mainLabel)
    }
    
}
