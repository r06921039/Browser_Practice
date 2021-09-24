//
//  WebViewCell.swift
//  Browser_Practice
//
//  Created by Jeff on 2021/9/23.
//

import UIKit

class WebViewCell: UICollectionViewCell {
    var vc: WebViewController?
    var imageView: AlignmentImageView = {
        let iv = AlignmentImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .yellow
        iv.layer.cornerRadius = 10
//        iv.layer.borderWidth = 1
//        iv.layer.borderColor = UIColor.darkGray.cgColor
        iv.layer.masksToBounds = true
        iv.horizontalAlignment = .left
        iv.verticalAlignment = .top
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: frame.width),
            imageView.heightAnchor.constraint(equalToConstant: 250)
            ])
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
    }
}
