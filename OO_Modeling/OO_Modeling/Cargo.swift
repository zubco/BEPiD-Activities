import Foundation

class Cargo{
    
    var cargoType:String?
    var destiny:String?
    var people:Array<Passenger>?
    
    public init(_ type: String, _ destiny: String){
        self.cargoType = type
        
        if(self.cargoType == "People"){
            people = Array<Passenger>()
        }
        
        self.destiny = destiny
    }
    
    public func changeCargoDestiny(_ newDestiny: String){
        self.destiny = newDestiny
    }
}
