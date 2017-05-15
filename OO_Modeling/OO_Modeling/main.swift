//
//  main.swift
//  OO_Modeling
//
//  Created by Rafael Tomaz Prado on 18/04/17.
//  Copyright © 2017 BEPiD 2017. All rights reserved.
//

import Foundation

let route = Rail(167.0, "Itapetininga", "Sorocaba")
var firstTrain = Train(10)
firstTrain.rail = route

firstTrain.wagons.append(Wagon("Mineral", "Sorocaba"))
firstTrain.wagons.append(Wagon("People", "Sorocaba"))

var rafael = Passenger("Rafael", 1995, 789, 1001, 20.3, "Sorocaba")
rafael.findSeat()
firstTrain.wagons[1].boardPassenger(rafael)

var benedito = Machinist("Benedito", 1980, 2410, "Valid")
benedito.conductTrain(firstTrain)
print("The machinist is: \((firstTrain.locomotive.machinist?.name)!)")

//Teste de alteracao de velocidade em todas as rodas.
firstTrain.changeSpeed(80.0)
firstTrain.changeSpeed(50.0)
