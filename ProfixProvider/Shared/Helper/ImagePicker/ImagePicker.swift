//
//  ImagePicker.swift
// NewBase
//
//  Created by MGAbouarab on 08/01/2024.
//


import UIKit
import PhotosUI
import AVFoundation
import Photos

typealias PickUIImageCompltion = ((_ image: UIImage) -> Void)
typealias PickImageDataCompltion = ((_ imageData: Data?) -> Void)
typealias PickImageCompltion = ((_ image: UIImage, _ imageData: Data?) -> Void)
typealias PickImagesCompltion = ((_ images: [UIImage], _ imagesData: [Data]) -> ())

class ImagePicker: NSObject {
    
    private enum Keys {
        case pickImage, camera, gallery, cancel
        
        var value: String {
            switch self {
            case .pickImage: return "Pick Image".imagePickerLocalizable
            case .camera: return "Camera".imagePickerLocalizable
            case .gallery: return "Gallery".imagePickerLocalizable
            case .cancel: return "Cancel".imagePickerLocalizable
            }
        }
    }
    
    //MARK: - Properties -
    private var picker = UIImagePickerController()
    private lazy var alert = UIAlertController(title: Keys.pickImage.value, message: nil, preferredStyle: .actionSheet)
    private var pickImageCallback : PickImageCompltion?
    private var pickImagesCallback : PickImagesCompltion?
    private let allowEdit: Bool
    private var didConfigred: Bool = false
    var configuration = PHPickerConfiguration()
    private var pickUIImageCompltion : PickUIImageCompltion?
    private var pickImageDataCompltion : PickImageDataCompltion?
    
    init(allowEdit: Bool = false) {
        self.allowEdit = allowEdit
        super.init()
        configuration.filter = .images
        configuration.selectionLimit = 1
    }

    private func setupAlert() {
        let cameraAction = UIAlertAction(title: Keys.camera.value, style: .default) { _ in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: Keys.gallery.value, style: .default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: Keys.cancel.value, style: .cancel)
        
        picker.delegate = self
        picker.allowsEditing = self.allowEdit
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = .main
    }
    
    private func openCamera() {
        alert.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.checkCameraPermission { granted in
                guard granted else { return }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    DispatchQueue.main.async {
                        self.picker.sourceType = .camera
                        if let topVC = SceneDelegate.current?.window?.topViewController() {
                            topVC.present(self.picker, animated: true)
                        }
                    }
                } else {
                    print("this device has no camera")
                }
            }
        }
    }

    
    private func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        checkPhotoLibraryPermission { granted in
            guard granted else { return }

            let picker = PHPickerViewController(configuration: self.configuration)
            picker.delegate = self
            let window = SceneDelegate.current?.window
            window?.topViewController()?.present(picker, animated: true)
        }
    }

    
    func pickImage(_ callback: @escaping PickImageCompltion) {
        if !didConfigred {
            setupAlert()
            didConfigred = true
        }
        let window = SceneDelegate.current?.window
        guard let window = window else { return }
        window.endEditing(true)
        pickImageCallback = callback
        alert.popoverPresentationController?.sourceView = window.topViewController()?.view
        window.topViewController()?.present(alert, animated: true)
    }
    
    func pickImage(_ dataCallBack: PickImageDataCompltion?, imageCallBack: PickUIImageCompltion?) {
        if !didConfigred {
            setupAlert()
            didConfigred = true
        }
        let window = SceneDelegate.current?.window
        guard let window = window else { return }
        window.endEditing(true)
        pickUIImageCompltion = imageCallBack
        pickImageDataCompltion = dataCallBack
        alert.popoverPresentationController?.sourceView = window.topViewController()?.view
        window.topViewController()?.present(alert, animated: true)
    }
    
    func pickImages(_ callback: @escaping PickImagesCompltion) {
        if !didConfigred {
            setupAlert()
            didConfigred = true
        }
        let window = SceneDelegate.current?.window
        guard let window = window else { return }
        window.endEditing(true)
        configuration.selectionLimit = 10
        pickImagesCallback = callback
        alert.popoverPresentationController?.sourceView = window.topViewController()?.view
        window.topViewController()?.present(alert, animated: true)
    }
    
    func pickImages() {
        let window = SceneDelegate.current?.window
        guard let window = window else { return }
        alert.popoverPresentationController?.sourceView = window.topViewController()?.view
        window.topViewController()?.present(alert, animated: true)
    }
    
    //MARK: - Permission Helpers -
    private func showPermissionAlert(for type: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Permission Required".localized,
                message: "Please enable access to your settings to use this feature..".localized + type,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
            alert.addAction(UIAlertAction(title: "Settings".localized, style: .default, handler: { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
            let window = SceneDelegate.current?.window
            window?.topViewController()?.present(alert, animated: true)
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            self.showPermissionAlert(for: "Camera")
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        case .denied, .restricted:
            self.showPermissionAlert(for: "Photo Library")
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    //MARK: - Deinit
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[allowEdit ? .editedImage : .originalImage] as? UIImage else {
            fatalError("Expected an image, but got: \(info)")
        }
        let compressedData = image.jpegData(compressionQuality: 0.5)
        pickImageCallback?(image, compressedData)
        pickUIImageCompltion?(image)
        pickImageDataCompltion?(compressedData)
        guard let fullData = image.jpegData(compressionQuality: 1) else { return }
        pickImagesCallback?([image], [fullData])
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ImagePicker: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard !results.isEmpty else {
            picker.dismiss(animated: true)
            return
        }
        
        let items = results.map { $0.itemProvider }
        var importedCount = 0
        var arrayOfData: [Data] = []
        var arrayOfImages: [UIImage] = []
        
        for item in items {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    importedCount += 1
                    if let image = image as? UIImage {
                        arrayOfImages.append(image)
                        if let data = image.jpegData(compressionQuality: 0.5) {
                            arrayOfData.append(data)
                        }
                    }
                    if importedCount == items.count {
                        DispatchQueue.main.async {
                            if self.configuration.selectionLimit == 1 {
                                self.pickUIImageCompltion?(arrayOfImages[0])
                                self.pickImageDataCompltion?(arrayOfData[0])
                                self.pickImageCallback?(arrayOfImages[0], arrayOfData[0])
                            } else {
                                self.pickImagesCallback?(arrayOfImages, arrayOfData)
                            }
                            picker.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Video -
class VideoPicker: NSObject {
    
    private enum Keys {
        case pickVideo, camera, gallery, cancel
        
        var value: String {
            switch self {
            case .pickVideo: return "Pick Video".helperLocalizable
            case .camera: return "Camera".helperLocalizable
            case .gallery: return "Gallery".helperLocalizable
            case .cancel: return "Cancel".helperLocalizable
            }
        }
    }
    
    // MARK: - Properties -
    private var picker = UIImagePickerController()
    private var alert = UIAlertController(title: Keys.pickVideo.value, message: nil, preferredStyle: .actionSheet)
    private var pickVideoCallback : ((_ videoURL: URL, _ videoData: Data) -> ())?
    
    // MARK: - Initializers -
    override init() {
        super.init()
        setupAlert()
    }
    
    // MARK: - Setup Alert
    private func setupAlert() {
        let cameraAction = UIAlertAction(title: Keys.camera.value, style: .default) { _ in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: Keys.gallery.value, style: .default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: Keys.cancel.value, style: .cancel)
        
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .dark
            alert.view.tintColor = .white
        }
    }
    
    // MARK: - Open Camera
    private func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        checkCameraPermission { granted in
            guard granted else { return }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.picker.mediaTypes = ["public.movie"]
                self.picker.videoQuality = .typeHigh
                SceneDelegate.current?.window?.topViewController()?.present(self.picker, animated: true)
            } else {
                AlertManager.shared.show(message: "this device has no camera".localized, type: .image(.init(systemName: SFSymbol.error.rawValue)))
            }
        }
    }
    
    // MARK: - Open Gallery
    private func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        checkPhotoLibraryPermission { granted in
            guard granted else { return }
            self.picker.sourceType = .savedPhotosAlbum
            self.picker.mediaTypes = ["public.movie"]
            self.picker.videoQuality = .typeHigh
            SceneDelegate.current?.window?.topViewController()?.present(self.picker, animated: true)
        }
    }
    
    // MARK: - Pick Video
    func pickVideo(_ callback: @escaping ((_ videoURL: URL, _ videoData: Data) -> ())) {
        pickVideoCallback = callback
        let window = SceneDelegate.current?.window
        alert.popoverPresentationController?.sourceView = window?.topViewController()?.view
        window?.topViewController()?.present(alert, animated: true)
    }
    
    // MARK: - Save to Album
    private func savedPhotosAlbum(path: String) {
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, nil, nil)
        }
    }
    
    // MARK: - Permissions
    private func showPermissionAlert(for type: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Permission Required",
                message: "Please enable access to your \(type) from settings to use this feature.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }))
            SceneDelegate.current?.window?.topViewController()?.present(alert, animated: true)
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            showPermissionAlert(for: "Camera")
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        case .denied, .restricted:
            showPermissionAlert(for: "Photo Library")
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension VideoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let videoURL = info[.mediaURL] as? URL else {
            fatalError("Expected a dictionary containing a video URL, but got: \(info)")
        }
        savedPhotosAlbum(path: videoURL.path)
        do {
            let videoData = try Data(contentsOf: videoURL)
            pickVideoCallback?(videoURL, videoData)
        } catch {
            print(error.localizedDescription)
        }
    }
}
