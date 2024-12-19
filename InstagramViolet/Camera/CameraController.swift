//
//  CameraController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 18.12.2024.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {

    let output = AVCapturePhotoOutput()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.rightArrowShadow.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let capturePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.capturePhoto.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        
        view.addSubviews(capturePhotoButton, dismissButton)
        capturePhotoButton.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        dismissButton.anchor(top: view.topAnchor, leading: nil, trailing: view.trailingAnchor, bottom: nil, paddingTop: 70, paddingLeading: 0, paddingTrailing: -12, paddingBottom: 0, width: 50, height: 50)
        capturePhotoButton.anchor(top: nil, leading: nil, trailing: nil, bottom: view.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: -100, width: 100, height: 100)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        //setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input: \(err)")
        }
        // setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        if let error {
            print("Error capturing photo: \(error)")
            return
        }
        print("Finish photo")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        let previewImageView = UIImageView(image: previewImage)
        view.addSubview(previewImageView)
        previewImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }

    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
