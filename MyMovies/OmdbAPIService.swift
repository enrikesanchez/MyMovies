//
//  OmdbAPIService.swift
//  MyMovies
//
//  Created by esanchez on 3/30/19.
//  Copyright © 2019 Tec. All rights reserved.
//

import Foundation

class OmdbAPIService: NSObject {
    //MARK: Functions
    func searchByTitle(_ titleToSearch: String, handler: @escaping (MovieVO) -> Void) {
        guard let encodedTitleToSearch = titleToSearch.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            else {
                NSLog("Error encoding title %@", titleToSearch)
                return
        }
        
        let omdbapiEndpoint: String = "https://www.omdbapi.com/?t=\(encodedTitleToSearch)&apikey=3ba2fd78"
        
        guard let url = URL(string: omdbapiEndpoint) else {
            NSLog("Error creating URL %@", omdbapiEndpoint)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("Error calling URL")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error data is empty")
                return
            }
            
            do {
                guard let omdbapiResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("Error trying to convert data to JSON")
                        return
                }
                
                let movie = self.buildMovieFromAPIResponse(omdbapiResponse)
                
                handler(movie)
            } catch  {
                print("Error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func searchById(_ idToSearch: String, handler: @escaping (MovieVO) -> Void) {
        let omdbapiEndpoint: String = "https://www.omdbapi.com/?i=\(idToSearch)&apikey=3ba2fd78"
        
        guard let url = URL(string: omdbapiEndpoint) else {
            NSLog("Error creating URL %@", omdbapiEndpoint)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("Error calling URL")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error data is empty")
                return
            }
            
            do {
                guard let omdbapiResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("Error trying to convert data to JSON")
                        return
                }
                
                let movie = self.buildMovieFromAPIResponse(omdbapiResponse)
                
                handler(movie)
            } catch  {
                print("Error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    private func buildMovieFromAPIResponse(_ omdbapiResponse: [String: Any]) -> MovieVO {
        let movie = MovieVO()
        
        if let imdbId = omdbapiResponse["imdbID"] as? String {
            movie.imdbId = imdbId
        }
        
        if let title = omdbapiResponse["Title"] as? String {
            movie.title = title
        }
        
        if let year = omdbapiResponse["Year"] as? String {
            movie.year = year
        }
        
        if let rated = omdbapiResponse["Rated"] as? String {
            movie.rated = rated
        }
        
        if let poster = omdbapiResponse["Poster"] as? String {
            movie.poster = poster
        }
        
        return movie
    }
}

