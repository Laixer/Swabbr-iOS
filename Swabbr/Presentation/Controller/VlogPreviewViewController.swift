//
//  VlogPreviewViewController.swift
//  Swabbr
//
//  Created by James Bal on 08-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  swiftlint:disable identifier_name

import UIKit

class VlogPreviewViewController: UIViewController, BaseViewProtocol {
    
    let image: UIImage
    
    let imageHolderView = UIImageView()
    
    let slider = UISlider(frame: .zero)
    let duration = UILabel()
    let currentDuration = UILabel()
    let pausePlayButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    var isPlaying = false
    
    var context: ModalHandler?
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage, context: ModalHandler) {
        self.image = image
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.blue
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(deniedToUpload))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(agreedToUpload))
        
        initElements()
        applyConstraints()

    }
    
    func initElements() {
        imageHolderView.image = image
        view.addSubview(imageHolderView)
    }
    
    func applyConstraints() {
        imageHolderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageHolderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageHolderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageHolderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageHolderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /**
     Handles action when user wants to upload.
    */
    @objc private func agreedToUpload() {
        
    }
    
    /**
     Handles action when user does not want to upload.
     */
    @objc private func deniedToUpload() {
        context?.dismissAllModals()
    }
    
}
