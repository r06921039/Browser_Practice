//
//  WebViewCell.swift
//  Browser_Practice
//
//  Created by Jeff on 2021/9/23.
//

import UIKit

protocol CollectionDataProtocol {
    func deleteData(index: Int)
}

class WebViewCell: UICollectionViewCell {
    var vc: WebViewController?
    var delegate: CollectionDataProtocol?
    var index: IndexPath?
    
    lazy var imageView: AlignmentImageView = {
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
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width:20,height:20))
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDelete(_ sender: UIButton){
        delegate?.deleteData(index: index!.row)
    }
    
    fileprivate func setupViews(){
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: frame.width),
            imageView.heightAnchor.constraint(equalToConstant: 250)
            ])
        addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            deleteButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
        contentView.isUserInteractionEnabled = false
    }
}
