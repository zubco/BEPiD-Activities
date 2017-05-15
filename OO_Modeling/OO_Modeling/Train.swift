import Foundation

public class Train{
    
    public let locomotive = Locomotive()
    public var wagons:Array<Wagon>
    fileprivate var numberOfWagons:Int?
    public var rail:Rail?
    
    public init (_ size: Int){
        self.numberOfWagons = size
        self.wagons = Array<Wagon>()
    }
    
    public func changeSpeed(_ newSpeed: Float){
        locomotive.changeSpeed(newSpeed)
        for w in wagons{
            w.changeSpeed(newSpeed)
        }
    }
    
}
