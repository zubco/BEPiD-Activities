import Foundation
import UIKit

/// Creates two extensions to make the text appending to the UITextField.text easier.
extension String{
	/// Appends a new sentence to the ConsoleView text adding a '>' character at the beginning.
    public mutating func appendConsole(_ txt: String){
        self += "> "
        self.append(txt+"\n")
    }
    /// Appends a new string to the ConsoleView text using the "user@computer>$" format, simulating a console command input.
    public mutating func playerText(_ txt: String, _ name: String, _ computer: String){
        self += "\n \(name)@\(computer)>$ "
        self.append(txt+"_\n\n")
    }
}
