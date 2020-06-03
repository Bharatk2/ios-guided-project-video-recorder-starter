//
//  ViewController.swift
//  VideoRecorder
//
//  Created by Paul Solt on 10/2/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    // permission to show the camera, this viewcontroller will work for that.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        requestPermissionAndShowCamera()
    }
    
    // step 1
    func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // 2nd time user has used app (they've already authorized)
            showCamera()
        case .denied:
            // 2nd time user has used app (they have not given permission.)
            // take to the settings app (or show a custom onboarding screen to explain why need access)
            //we need to explain why we need the access with the camera.
            
            fatalError("Show user UI To get them to give acess") // TODO: Handle this with proper error
        case .notDetermined:
            // first time user is using app
           requestPermission()
        
        case .restricted:
            // parental controls (need to inform user they don't have access, maybe ask parents?)
            fatalError("Show user UI to request permission from boss/parent/self.")
        }
    }
    
    private func requestPermission() {
        // if we got access we will use this method
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Show your UI to get them to give access")
               // return
            }
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
        
    }
    
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: self)
    }
}
