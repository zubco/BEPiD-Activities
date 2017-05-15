import Foundation

public class Machinist : Person{
    
    var license:String?
    var train:Train?
    var retired:Bool?
    
    public init(_ name: String, _ yob: Int, _ pass: Int, _ license: String){
        super.init(name, yob, pass)
        self.license = license
        if((2017 - yob) > 60){
            self.retired = true
        }
        else{
            self.retired = false
        }
    }
    
    public func conductTrain (_ train: Train){
        if(self.retired == false){
            self.train = train
            train.locomotive.machinist = self
        }
        else{
            print("This machinist is retired...")
        }
    }
}
