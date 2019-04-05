//
//  DetailViewController.swift
//  MyMovies
//
//  Created by esanchez on 3/31/19.
//  Copyright © 2019 Tec. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var imdbIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    //MARK: Properties
    var movie: MovieVO?
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        imdbIdLabel.text = movie!.imdbId
        titleLabel.text = movie!.title
        yearLabel.text = movie!.year
        ratedLabel.text = movie!.rated
        
        let posterUrl = URL(string: movie!.poster)
        getData(from: posterUrl!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.posterImageView.image = UIImage(data: data)
            }
        }
    }
    
    //MARK: Functions
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
