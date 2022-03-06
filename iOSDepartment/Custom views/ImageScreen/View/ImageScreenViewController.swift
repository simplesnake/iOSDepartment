//
//  ImageScreenViewController.swift
//  Mobilization
//
//  Created by Ekaterina on 18/08/2021.
//  Copyright © 2021 Custom company name. All rights reserved.
//

import UIKit
import SnapKit

// Экран для полноэкранного просмотра фото

class ImageScreenViewController: BaseViewController {
    
    var localization: ImageScreenLocalization!
    var presenter: ImageScreenViewOutput!
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 5.0
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
//        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = false
//        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let mediaData = presenter.mediaData {
            imageView.downloadImage(from: mediaData.url!, aspectMode: .scaleAspectFit, completion: {
                [weak self] in
                guard let self = self else { return }
                if let myImage = self.imageView.image {
                            let myImageWidth = myImage.size.width
                            let myImageHeight = myImage.size.height
                    let myViewWidth = self.imageView.frame.size.width
                 
                            let ratio = myViewWidth/myImageWidth
                            let scaledHeight = myImageHeight * ratio

                    self.imageView.frame.size = CGSize(width: myViewWidth, height: scaledHeight)
                }
            })
            
        
        } else {
            if let image = presenter.image {
                imageView.image = image
            }
        }
        
    }
    
    func setupUI() {
        addSubviews()
        makeConstraints()
    }
    
    func addSubviews() {
    header.addButton(image: #imageLiteral(resourceName: "backIcon"), type: .left){
        [weak self] _ in
        self?.presenter.backButtonTap()
    }
        
        view.insertSubview(scrollView, belowSubview: header)
        scrollView.addSubview(imageView)
    }

    func makeConstraints() {
        
        scrollView.snp.makeConstraints{ make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        imageView.snp.makeConstraints{ make in
            make.top.bottom.left.right.equalToSuperview()
        
            make.width.equalToSuperview()
            make.height.equalToSuperview()
//            make.center.equalToSuperview()
            
        }
    }
}

extension ImageScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
           if scrollView.zoomScale > 1 {
               if let image = imageView.image {
                   let ratioW = imageView.frame.width / image.size.width
                   let ratioH = imageView.frame.height / image.size.height
                   
                   let ratio = ratioW < ratioH ? ratioW : ratioH
                   let newWidth = image.size.width * ratio
                   let newHeight = image.size.height * ratio
                   let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                   let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                   let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                   
                   let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                   
                   scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                   
               }
           } else {
               scrollView.contentInset = .zero
           }
       }
}
