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
    private let vlogId: String
    
    let imageHolderView = UIImageView()
    
    let slider = UISlider(frame: .zero)
    let duration = UILabel()
    let currentDuration = UILabel()
    let pausePlayButton = UIButton(type: UIButton.ButtonType.infoDark)
    
    var isPlaying = false
    
    var context: ModalHandler?
    
    private let controllerService = VlogPreviewViewControllerService()
    
    init(vlogId: String, image: UIImage, context: ModalHandler) {
        self.vlogId = vlogId
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
        
        controllerService.delegate = self
        
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
        if vlogId.isEmpty {
            saveVlog(errorString: nil)
        } else {
            controllerService.publishStream(id: vlogId)
        }
    }
    
    /**
     Handles action when user does not want to upload.
     */
    @objc private func deniedToUpload() {
        context?.dismissAllModals()
    }
    
}

extension VlogPreviewViewController: VlogPreviewViewControllerServiceDelegate {
    func saveVlog(errorString: String?) {
        if let errorString = errorString {
            BasicDialog.createAlert(message: errorString, handler: { (_) in
                self.context?.dismissAllModals()
            }, context: self)
            return
        }
        
        BasicDialog.createAlert(title: "Success", message: "The video has been published!", handler: { [unowned self] (_) in
            self.context?.dismissAllModals()
        }, context: self)
    }
}
