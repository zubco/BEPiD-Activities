//
//  SeasonDAO.swift
//  GameOfThronesGuide
//
//  Created by Fernando Celarino on 29/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import CoreData

class SeasonDAO {
    
    /// Method responsible for saving a season into database
    /// - parameters:
    ///     - objectToBeSaved: season to be saved on database
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func create(_ objectToBeSaved: Season) throws {
        do {
            // add object to be saved to the context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.insert(objectToBeSaved)
            
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for updating a season into database
    /// - parameters:
    ///     - objectToBeUpdated: season to be updated on database
    /// - throws: if an error occurs during updating an object into database (Errors.DatabaseFailure)
    static func update(_ objectToBeUpdated: Season) throws {
        do {
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for deleting a season from database
    /// - parameters:
    ///     - objectToBeSaved: season to be saved on database
    /// - throws: if an error occurs during deleting an object into database (Errors.DatabaseFailure)
    static func delete(_ objectToBeDeleted: Season) throws {
        do {
            // delete element from context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(objectToBeDeleted)
            
            // persist the operation
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for gettings all seasons from database
    /// - returns: a list of seasons from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findAll() throws -> [Season] {
        // list of seasons to be returned
        var seasonList:[Season]
        
        do {
            // creating fetch request
            let request:NSFetchRequest = NSFetchRequest<Season>()
            
            // perform search
            seasonList = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }
        
        return seasonList
    }
    
}
