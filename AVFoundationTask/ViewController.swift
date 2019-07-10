//
//  ViewController.swift
//  AVFoundationTask
//
//  Created by Indra Sumawi on 10/07/19.
//  Copyright © 2019 Indra Sumawi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let captureSession = AVCaptureSession()
    var previewView = PreviewView()
    var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    var photoOutput = AVCapturePhotoOutput()
    var  outputImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        askCameraPermission { (granted) in
            if  granted {
                DispatchQueue.main.sync {
                    self.setupView()
                    
                }
                DispatchQueue.global().async {
                    self.configuringSession()
                }
            }
        }
    }
    
    func askCameraPermission(completion: @escaping ((Bool) -> Void) ) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if !granted {
                let alert = UIAlertController(title: "Message", message: "Give permission", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    completion(false)
                })
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                completion(true)
            }
        }
    }
    
    func configuringSession(){
        captureSession.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return  }
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice), captureSession.canAddInput(videoDeviceInput)
            else {return}
        captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(photoOutput) else {return}
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        captureSession.commitConfiguration()
        
        DispatchQueue.main.async{
            self.previewView.videoPreviewLayer.session = self.captureSession
            self.captureSession.startRunning()
        }
    }
    
    func setupView(){
        
        let xPosition = (UIScreen.main.bounds.width / 2.0) - 40
        let yPosition = UIScreen.main.bounds.height - 170.0
        let buttonRect = CGRect(x: xPosition, y: yPosition, width: 80, height: 80)
        let buttonShoot = UIButton (frame: buttonRect)
        
        buttonShoot.backgroundColor = UIColor.white
        buttonShoot.layer.cornerRadius = buttonShoot.frame.width / 2.0
        buttonShoot.layer.masksToBounds = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonShotDidTap))
        buttonShoot.addGestureRecognizer(tap)
        view.addSubview(buttonShoot)
        
        
        
        view.backgroundColor = .black
        
        // setting preview view for camera
        previewView.frame = CGRect (x: 0, y: 0, width: UIScreen.main.bounds.width, height: 650)
        view.addSubview(previewView)
        
        // show image for photo preview
        outputImageView.frame = CGRect(x: (xPosition / 2) - 25, y: yPosition + 10, width: 50, height: 50)
        outputImageView.layer.borderColor = UIColor.gray.cgColor
        outputImageView.layer.borderWidth = 1
        outputImageView.layer.masksToBounds = true
        outputImageView.contentMode = .scaleAspectFill
        view.addSubview(outputImageView)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.captureSession.stopRunning()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func buttonShotDidTap() {
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        
        photoOutput.capturePhoto(with: settings, delegate: self as! AVCapturePhotoCaptureDelegate) // force fix
    }

}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput (_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        let image = UIImage(data: imageData)
        outputImageView.image = image
    }
    
    
}

