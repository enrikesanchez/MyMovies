//
//  MovieDAO.swift
//  MyMovies
//
//  Created by esanchez on 3/30/19.
//  Copyright © 2019 Tec. All rights reserved.
//
import CoreData
import UIKit

class MovieDAO: NSObject {
    //MARK: Properties
    var managedObjectContext: NSManagedObjectContext!
    
    //MARK: Initializers
    override init() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext
    }
    
    //MARK: Functions
    func findAll() -> [Movie] {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        var movies: [Movie] = []
        
        do {
            movies = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            NSLog("Error fetching the movies from databse: %@", error)
        }
        
        return movies
    }
    
    func insertMovie(imdbId: String) {
        let movie: Movie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: managedObjectContext) as! Movie
        movie.imdbId = imdbId
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            NSLog("Error saving the movie in database: %@", error)
        }
    }
    
    func deleteMovie(imdbId: String) {
        
    }
}
