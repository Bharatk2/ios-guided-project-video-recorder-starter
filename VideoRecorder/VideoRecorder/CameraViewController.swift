//
//  CameraViewController.swift
//  VideoRecorder
//
//  Created by Paul Solt on 10/2/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import AVFoundation
class CameraViewController: UIViewController {

    lazy var captureSession = AVCaptureSession()
    
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!


	override func viewDidLoad() {
		super.viewDidLoad()
setUpCaptureSession()
		// Resize camera preview to fill the entire screen
		cameraView.videoPlayerView.videoGravity = .resizeAspectFill
	}

    private func setUpCaptureSession() {
        // inputs
        
        // camera
        
        // microphone
        
        //quality level
        
        // outputs
        
        // set the captureSession into our camera preview view.
        captureSession.commitConfiguration()
        cameraView.session = captureSession
        
        
    }
    
    private func bestCamera() -> AVCaptureDevice {
        // ideal camera, fallback camera, FUTURE: we add a button to choose front/back
        
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }
        
        
    }
    
    
    @IBAction func recordButtonPressed(_ sender: Any) {

	}
	
	/// Creates a new file URL in the documents directory
	private func newRecordingURL() -> URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime]

		let name = formatter.string(from: Date())
		let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
		return fileURL
	}
}

