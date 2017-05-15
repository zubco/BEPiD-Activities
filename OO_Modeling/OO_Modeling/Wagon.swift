import Foundation

public class Wagon{
    
    fileprivate var wheels:Array<Wheel>?
    var cargo:Cargo?
    fileprivate var numberOfWheels = 6
    
    public init(_ cargoType: String, _ destiny: String){
        self.cargo = Cargo(cargoType, destiny)
        
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
    
    public func boardPassenger(_ pass: Passenger){
        if(cargo?.cargoType == "People" && cargo?.people != nil){
            cargo?.people?.append(pass)
            print("\(pass.name!) boarded successfully!")
        }
        else{
            print("This is not a passengers wagon...")
        }
    }
}
