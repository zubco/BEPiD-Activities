import Foundation

public class Passenger : Person{
    
    var boardingPass:Int?
    var bagsWeight:Float?
    var destiny:String?
    
    public init(_ name: String, _ yob: Int, _ pass: Int, _ boarding: Int, _ bags: Float, _ destiny:String){
        super.init(name, yob, pass)
        self.boardingPass = boarding
        self.bagsWeight = bags
        self.destiny = destiny
    }
    
    public func findSeat(){
        let wagonNumber = self.boardingPass! / 1000
        let seatNumber = self.boardingPass! % 1000
        
        print("Your seat is on wagon \(wagonNumber), seat \(seatNumber)")
    }
}
