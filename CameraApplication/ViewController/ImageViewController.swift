//
//  ImageViewController.swift
//  CameraApplication
//
//  Created by RITIKA VERMA on 06/09/21.
//

import UIKit
import AVFoundation

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var capturedImageView: UIImageView!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        imagePickerController.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        capturedImageView.isUserInteractionEnabled = true
        self.capturedImageView.addGestureRecognizer(gesture)
    }
    
    //MARK:- captured image
    
    @objc func didTapImageView(){
        self.checkCameraPermission()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        capturedImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- save image to gallery
    
    @IBAction func saveCapturedImage(_ sender: UIButton) {
        
        let imgCapturedData = self.capturedImageView.image!.pngData()
        let compressedImageData = UIImage(data: imgCapturedData!)
        UIImageWriteToSavedPhotosAlbum(compressedImageData!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK:- CameraPermission
    
    func callCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    func presentCameraSettings() {
        let alert = UIAlertController(title: "Error", message: "Camera access is denied", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    _ in
                })
            }
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkCameraPermission(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .denied:
            print("Denied status")
            self.presentCameraSettings()
            break
        case .restricted:
            print("user doesn't allow")
            break
        case .authorized:
            print("success")
            self.callCamera()
            break
        case .notDetermined:
            print("not determined status")
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                if success{
                    print("permission granted")
                }else{
                    print("permission not granted")
                }
            }
            break
        }
        
    }
    
    
    
}

