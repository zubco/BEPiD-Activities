import Foundation

public class Person{
    
    var name:String?
    var yearOfBirth:Int?
    var passportNumber:Int?
    
    public init(_ name: String, _ yob: Int, _ pass: Int){
        self.name = name
        self.yearOfBirth = yob
        self.passportNumber = pass
    }
    
    public func talk(_ sentence: String){
        print(sentence)
    }
}
