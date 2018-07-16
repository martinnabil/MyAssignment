//
//  MovieTableViewCell.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 2/4/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var movieOverviewLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var movie: Results! {
        didSet {
            adjustData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK:- Configuration
    func configureUI() {
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        
        shadowView.shadowRadius = 4
        shadowView.shadowOffset = CGSize.zero
        shadowView.shadowColor = UIColor.black
        shadowView.shadowOpacity = 0.1
        
        cellImage.layer.cornerRadius = 4
        cellImage.layer.masksToBounds = true
        
        adjustFonts()
    }
    
    func adjustFonts() {
        titleLbl.font = FontsManager.shared.OpenSansSemiBoldWithSize(13)
        dateLbl.font = FontsManager.shared.OpenSansRegularWithSize(9)
        movieOverviewLbl.font = FontsManager.shared.OpenSansRegularWithSize(10)
        
    }
    
    // MARK:- Adjust data
    func adjustData() {
        titleLbl.text = movie.title
        movieOverviewLbl.text = movie.overview
        if let date: String = movie.release_date {
            dateLbl.text = date
        }
        if let image = movie.poster_path {
            let url = URL(string:EnviromentManager.shared.imagesUrl + image)
            cellImage.kf.setImage(with: url)
        } else {
            cellImage.image = #imageLiteral(resourceName: "iTunesArtwork")
        }
        
    }
    
    
}
