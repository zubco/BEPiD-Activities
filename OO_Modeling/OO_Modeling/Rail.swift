import Foundation

public class Rail{
    
    var length:Float?
    var origin:String?
    var destiny:String?
    
    public init(_ newLength: Float, _ newOrigin: String, _ newDestiny: String){
        self.length = newLength
        self.origin = newOrigin
        self.destiny = newDestiny
    }
}
