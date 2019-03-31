//
//  ViewController.swift
//  MyMovies
//
//  Created by esanchez on 3/30/19.
//  Copyright © 2019 Tec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    //MARK: Outlets
    @IBOutlet weak var moviesTableView: UITableView!
    
    //MARK: Properties
    let movieDAO = MovieDAO()
    let omdbAPIService = OmdbAPIService()

    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDAO.findAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            else{
                return UITableViewCell()
        }
        
        let movie: Movie = movieDAO.findAll()[indexPath.row]
        self.omdbAPIService.searchById(movie.imdbId!) { (movieVO) in
            DispatchQueue.main.async {
                cell.textLabel?.text = movieVO.title
            }
        }

        return cell
    }

    //MARK: Actions
    @IBAction func addNewMovie(_ sender: UIBarButtonItem) {
        showRequestMovieTitleController()
    }
    
    //MARK: Functions
    func showRequestMovieTitleController() {
        var movieNameTextField: UITextField?
        
        let movieTitleAlertController = UIAlertController(title: "Add Movie", message: "Enter Movie Title", preferredStyle: .alert)
        
        let cancelAction  = UIAlertAction(title: "Cancel", style: .cancel) {(action) ->Void in
            NSLog("Search Movie Cancelled")
        }
        movieTitleAlertController.addAction(cancelAction)
        
        let searchAction = UIAlertAction(title: "Search", style: .default) {(action) -> Void in
            NSLog("Seach Movie in Progress: '\(movieNameTextField!.text ?? "")'")
            self.omdbAPIService.searchByTitle(movieNameTextField!.text!) { (movie) in
                if !movie.imdbId.isEmpty {
                    self.movieDAO.insertMovie(imdbId: movie.imdbId)
                    DispatchQueue.main.async {
                        self.moviesTableView.reloadData()
                    }
                }
            }
        }
        movieTitleAlertController.addAction(searchAction)
        
        movieTitleAlertController.addTextField() { (textField) -> Void in
            movieNameTextField = textField
        }
        present(movieTitleAlertController, animated: false, completion: nil)
    }
}

