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
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    var player: AVPlayer?
    var playerView: VideoPlayerView!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCaptureSession()
        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // we will add the start and stop methods here because we don't wan't it to load only once.
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    private func setUpCaptureSession() {
        captureSession.beginConfiguration()
        // inputs
        
        // camera
        let camera = bestCamera()
        // get the video data
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                //issue? then give error
                // FUTURE: Display the error so you understand why it failed.
                fatalError("Cannot create cmaera input, do something better than crashing?")
        }
        captureSession.addInput(cameraInput)
        // microphone
        
        
        //quality level
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        // outputs
        //  step 2 add thhe output here.
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot add movie recording")
        }
        captureSession.addOutput(fileOutput)
        // set the captureSession into our camera preview view.
        captureSession.commitConfiguration()
        cameraView.session = captureSession
        
        
    }
    
    private func bestCamera() -> AVCaptureDevice {
        // ideal camera, fallback camera, FUTURE: we add a button to choose front/back
        
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }
        
        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) { // try .front
            return wideAngleCamera
        }
        
        // simulator or thr request hardware camera doesn't work
        fatalError("No camera available , are you on simnulator") // TODO: show UI instead of a fatal error.
        
        
        
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecording()
    }
    
    private func toggleRecording() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            updateViews()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
            updateViews()
        }
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
    
    private func playMovie(url: URL) {
        
    }
}
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Did start recording: \(fileURL)")
        
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving movie: \(error)")
            return
        }
        print("Play Movie!")
        
        DispatchQueue.main.async {
            self.playMovie(url: outputFileURL)
        }
    
        //play the movie if no error
        updateViews()
    }

}

