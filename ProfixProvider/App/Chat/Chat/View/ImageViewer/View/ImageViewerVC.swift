//
//  ImageViewer.swift
//  Esterad
//
//  Created by Haneen on 10/12/2025.
//

import UIKit
import Kingfisher

class ImageViewerVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Properties -
    
    let viewModel : ImageViewerVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : ImageViewerVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ImageViewerVC", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupImageView()
    }
    
    //MARK: - View Configuration -
    
    func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor  = .black.withAlphaComponent(0.8)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
        contentView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectBackView))
        backView.addGestureRecognizer(tap)
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
    }
    
    func appear(sender:UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide(){
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut){
            self.backView.alpha = 0
            self.contentView.alpha = 0
            
        }completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    func setupImageView() {
        switch viewModel.image {
        case .local(let data):
            imageView.image = UIImage(data: data)
        case .remote(let string):
            imageView.kf.setImage(with: URL(string: string))

        }
    }
    
    @objc func didSelectBackView(){
        hide()
    }
}

//MARK: - Scroll View Delegate Method -

extension ImageViewerVC : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
