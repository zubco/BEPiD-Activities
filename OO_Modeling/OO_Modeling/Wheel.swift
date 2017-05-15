import Foundation

class Wheel{
    
    fileprivate let material = "Steel"
    fileprivate let diameter = Float(5.0)
    public private(set) var speed = Float(0.0)
    
    func accelerate(_ newSpeed: Float){
        if(newSpeed > self.speed){
            self.speed = newSpeed
            print("Speed: \(newSpeed)")
        }
        else{
            print("Trying to accelerate to speed lower than current")
        }
    }
    func applyBreaks(_ newSpeed: Float){
        if(newSpeed < self.speed){
            self.speed = newSpeed
            print("Speed: \(newSpeed)")
        }
        else{
            print("Trying to reduce to speed higher than current")
        }
    }
}
