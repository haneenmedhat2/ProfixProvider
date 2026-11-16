//
//  ImagePickerView.swift
//  Waraqa
//
//  Created by Haneen on 21/08/2025.
//

import UIKit
import Kingfisher

class ImagePickerView: UIView{

    //MARK: - Outlets -
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var cameraPickerIcon: UIImageView!
    
    //MARK: - Properties -
    
    var delegate:ImagePickerViewProtocol?
    
    //MARK: - Initializer -
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        setupView()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "ImagePickerView")
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //MARK: - View Setup -
    
    func setupView(){
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.textFieldBorder.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cameraPickerIcon.addGestureRecognizer(tap)
    }
    

    func setImage(image:String){
        userImageView.kf.setImage(with: URL(string: image),placeholder: UIImage(named: "Avatar"))
    }

    //MARK: - Actions -
    
     @objc func handleTap(){
         let picker = ImagePicker()
         picker.pickImage { [weak self] image, imageData in
             guard let self = self else { return }
             self.userImageView.image = image
             self.delegate?.didTapCameraIcon(image: imageData ?? Data())
         }
    }
}

//MARK: - ImagePicker Protocol -
 protocol ImagePickerViewProtocol : AnyObject {
     func didTapCameraIcon(image : Data)
}
