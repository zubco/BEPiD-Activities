import Foundation

public class Locomotive{
    
    fileprivate var wheels:Array<Wheel>?
    fileprivate let numberOfWheels = 8
    var machinist:Machinist?
    
    public init(){
        self.wheels = Array<Wheel>()
        for _ in 0...numberOfWheels{
            self.wheels?.append(Wheel())
        }
    }
    
    func changeSpeed(_ newSpeed: Float){
        for w in wheels!{
            if(newSpeed > w.speed){
                w.accelerate(newSpeed)
            }
            else{
                w.applyBreaks(newSpeed)
            }
        }
    }
}
