//
//  CameraViewController.swift
//  Snapchat
//
//  Created by Danny Dramond on 26/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit
import AVFoundation

open class CameraViewController: UIViewController {
    
    public enum CameraSelection {
        case rear
        case front
    }
    
    public enum VideoQuality {
        case high
        case medium
        case low
        case resolution352x288
        case resolution640x480
        case resolution1280x720
        case resolution1920x1080
        case resolution3840x2160
        case iframe960x540
        case iframe1280x720
    }
    
    fileprivate enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    public weak var cameraDelegate: CameraViewControllerDelegate?
    public var maximumVideoDuration : Double     = 0.0
    public var videoQuality : VideoQuality       = .high
    public var flashEnabled                      = false
    public var pinchToZoom                       = true
    public var maxZoomScale                         = CGFloat.greatestFiniteMagnitude
    public var tapToFocus                        = true
    public var lowLightBoost                     = true
    public var allowBackgroundAudio              = true
    public var doubleTapCameraSwitch            = true
    public var swipeToZoom                     = true
    public var swipeToZoomInverted             = false
    public var defaultCamera                   = CameraSelection.rear
    public var shouldUseDeviceOrientation      = false
    public var allowAutoRotate                = false
    public var videoGravity                   : CameraVideoGravity = .resizeAspect
    public var audioEnabled                   = true
    fileprivate(set) public var pinchGesture  : UIPinchGestureRecognizer!
    fileprivate(set) public var panGesture    : UIPanGestureRecognizer!
    private(set) public var isVideoRecording      = false
    private(set) public var isSessionRunning     = false
    private(set) public var currentCamera        = CameraSelection.rear
    public let session                           = AVCaptureSession()
    fileprivate let sessionQueue                 = DispatchQueue(label: "session queue", attributes: [])
    fileprivate var zoomScale                    = CGFloat(1.0)
    fileprivate var beginZoomScale               = CGFloat(1.0)
    fileprivate var isCameraTorchOn              = false
    fileprivate var setupResult                  = SessionSetupResult.success
    fileprivate var backgroundRecordingID        : UIBackgroundTaskIdentifier? = nil
    fileprivate var videoDeviceInput             : AVCaptureDeviceInput!
    fileprivate var movieFileOutput              : AVCaptureMovieFileOutput?
    fileprivate var photoFileOutput              : AVCaptureStillImageOutput?
    fileprivate var videoDevice                  : AVCaptureDevice?
    fileprivate var previewLayer                 : PreviewView!
    fileprivate var flashView                    : UIView?
    fileprivate var previousPanTranslation       : CGFloat = 0.0
    fileprivate var deviceOrientation            : UIDeviceOrientation?
    
    override open var shouldAutorotate: Bool {
        return allowAutoRotate
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        previewLayer = PreviewView(frame: view.frame, videoGravity: videoGravity)
        view.addSubview(previewLayer)
        view.sendSubview(toBack: previewLayer)
        
        addGestureRecognizers()
        
        previewLayer.session = session
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            
            break
        case .notDetermined:
            
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        default:
            setupResult = .notAuthorized
        }
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        
        layer.videoOrientation = orientation
        
        previewLayer.frame = self.view.bounds
        
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.previewLayer?.videoPreviewLayer.connection  {
            
            let currentDevice: UIDevice = UIDevice.current
            
            let orientation: UIDeviceOrientation = currentDevice.orientation
            
            let previewLayerConnection : AVCaptureConnection = connection
            
            if previewLayerConnection.isVideoOrientationSupported {
                
                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                    
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                
                    break
                    
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                
                    break
                    
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                
                    break
                    
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                }
            }
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldUseDeviceOrientation {
            subscribeToDeviceOrientationChangeNotifications()
        }
        
        setBackgroundAudioPreference()
        
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                
                DispatchQueue.main.async {
                    self.previewLayer.videoPreviewLayer.connection?.videoOrientation = self.getPreviewLayerOrientation()
                }
                
            case .notAuthorized:
                self.promptToAppSettings()
            case .configurationFailed:
                DispatchQueue.main.async(execute: { [unowned self] in
                    let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isSessionRunning == true {
            self.session.stopRunning()
            self.isSessionRunning = false
        }
        
        disableFlash()
        
        if shouldUseDeviceOrientation {
            unsubscribeFromDeviceOrientationChangeNotifications()
        }
    }
    
    public func takePhoto() {
        
        guard let device = videoDevice else {
            return
        }
        
        if device.hasFlash == true && flashEnabled == true {
            changeFlashSettings(device: device, mode: .on)
            capturePhotoAsyncronously(completionHandler: { (_) in })
            
        } else if device.hasFlash == false && flashEnabled == true && currentCamera == .front {
            flashView = UIView(frame: view.frame)
            flashView?.alpha = 0.0
            flashView?.backgroundColor = UIColor.white
            previewLayer.addSubview(flashView!)
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.flashView?.alpha = 1.0
                
            }, completion: { (_) in
                self.capturePhotoAsyncronously(completionHandler: { (success) in
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.flashView?.alpha = 0.0
                    }, completion: { (_) in
                        self.flashView?.removeFromSuperview()
                    })
                })
            })
        } else {
            if device.isFlashActive == true {
                changeFlashSettings(device: device, mode: .off)
            }
            capturePhotoAsyncronously(completionHandler: { (_) in })
        }
    }
    
    public func startVideoRecording() {
        guard let movieFileOutput = self.movieFileOutput else {
            return
        }
        
        if currentCamera == .rear && flashEnabled == true {
            enableFlash()
        }
        
        if currentCamera == .front && flashEnabled == true {
            flashView = UIView(frame: view.frame)
            flashView?.backgroundColor = UIColor.white
            flashView?.alpha = 0.85
            previewLayer.addSubview(flashView!)
        }
        
        sessionQueue.async { [unowned self] in
            if !movieFileOutput.isRecording {
                if UIDevice.current.isMultitaskingSupported {
                    self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                }
                
                let movieFileOutputConnection = self.movieFileOutput?.connection(with: .video)
                
                if self.currentCamera == .front {
                    movieFileOutputConnection?.isVideoMirrored = true
                }
                
                movieFileOutputConnection?.videoOrientation = self.getVideoOrientation()
                
                let outputFileName = UUID().uuidString
                let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
                self.isVideoRecording = true
                DispatchQueue.main.async {
                    self.cameraDelegate?.camera(self, didBeginRecordingVideo: self.currentCamera)
                }
            }
            else {
                movieFileOutput.stopRecording()
            }
        }
    }
    
    public func stopVideoRecording() {
        if self.movieFileOutput?.isRecording == true {
            self.isVideoRecording = false
            movieFileOutput!.stopRecording()
            disableFlash()
            
            if currentCamera == .front && flashEnabled == true && flashView != nil {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.flashView?.alpha = 0.0
                }, completion: { (_) in
                    self.flashView?.removeFromSuperview()
                })
            }
            DispatchQueue.main.async {
                self.cameraDelegate?.camera(self, didFinishRecordingVideo: self.currentCamera)
            }
        }
    }
    
    public func switchCamera() {
        guard isVideoRecording != true else {
            print("[SwiftyCam]: Switching between cameras while recording video is not supported")
            return
        }
        
        guard session.isRunning == true else {
            return
        }
        
        switch currentCamera {
        case .front:
            currentCamera = .rear
        case .rear:
            currentCamera = .front
        }
        
        session.stopRunning()
        
        sessionQueue.async { [unowned self] in
            
            for input in self.session.inputs {
                self.session.removeInput(input as! AVCaptureInput)
            }
            
            self.addInputs()
            DispatchQueue.main.async {
                self.cameraDelegate?.camera(self, didSwitchCameras: self.currentCamera)
            }
            
            self.session.startRunning()
        }
        
        disableFlash()
    }
    
    fileprivate func configureSession() {
        guard setupResult == .success else { return }
        currentCamera = defaultCamera
        
        session.beginConfiguration()
        configureVideoPreset()
        addVideoInput()
        addAudioInput()
        configureVideoOutput()
        configurePhotoOutput()
        
        session.commitConfiguration()
    }
    
    fileprivate func addInputs() {
        session.beginConfiguration()
        configureVideoPreset()
        addVideoInput()
        addAudioInput()
        session.commitConfiguration()
    }
    
    fileprivate func configureVideoPreset() {
        if currentCamera == .front {
            session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
        } else {
            if session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))) {
                session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))
            } else {
                session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
            }
        }
    }
    
    fileprivate func addVideoInput() {
        switch currentCamera {
        case .front:
            videoDevice = CameraController.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .front)
        case .rear:
            videoDevice = CameraController.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .back)
        }
        
        if let device = videoDevice {
            do {
                try device.lockForConfiguration()
                if device.isFocusModeSupported(.continuousAutoFocus) {
                    device.focusMode = .continuousAutoFocus
                    if device.isSmoothAutoFocusSupported {
                        device.isSmoothAutoFocusEnabled = true
                    }
                }
                
                if device.isExposureModeSupported(.continuousAutoExposure) {
                    device.exposureMode = .continuousAutoExposure
                }
                
                if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                    device.whiteBalanceMode = .continuousAutoWhiteBalance
                }
                
                if device.isLowLightBoostSupported && lowLightBoost == true {
                    device.automaticallyEnablesLowLightBoostWhenAvailable = true
                }
                
                device.unlockForConfiguration()
            } catch {
                print("[SwiftyCam]: Error locking configuration")
            }
        }
        
        do {
            
            guard let video = videoDevice else { return }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: video)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                print("[SwiftyCam]: Could not add video device input to the session")
                print(session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))))
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("[SwiftyCam]: Could not create video device input: \(error)")
            setupResult = .configurationFailed
            return
        }
    }
    
    fileprivate func addAudioInput() {
        guard audioEnabled == true else { return }
        do {
            let audioDevice = AVCaptureDevice.default(for: .audio)
            
            guard let audio = audioDevice else { return }
            
            let audioDeviceInput = try AVCaptureDeviceInput(device: audio)
            
            if session.canAddInput(audioDeviceInput) {
                session.addInput(audioDeviceInput)
            }
            else {
                print("[SwiftyCam]: Could not add audio device input to the session")
            }
        }
        catch {
            print("[SwiftyCam]: Could not create audio device input: \(error)")
        }
    }
    
    fileprivate func configureVideoOutput() {
        let movieFileOutput = AVCaptureMovieFileOutput()
        
        if self.session.canAddOutput(movieFileOutput) {
            self.session.addOutput(movieFileOutput)
            if let connection = movieFileOutput.connection(with: .video) {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }
            self.movieFileOutput = movieFileOutput
        }
    }
    
    fileprivate func configurePhotoOutput() {
        let photoFileOutput = AVCaptureStillImageOutput()
        
        if self.session.canAddOutput(photoFileOutput) {
            photoFileOutput.outputSettings  = [AVVideoCodecKey: AVVideoCodecJPEG]
            self.session.addOutput(photoFileOutput)
            self.photoFileOutput = photoFileOutput
        }
    }
    
    fileprivate func subscribeToDeviceOrientationChangeNotifications() {
        self.deviceOrientation = UIDevice.current.orientation
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    fileprivate func unsubscribeFromDeviceOrientationChangeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.deviceOrientation = nil
    }
    
    @objc fileprivate func deviceDidRotate() {
        if !UIDevice.current.orientation.isFlat {
            self.deviceOrientation = UIDevice.current.orientation
        }
    }
    
    fileprivate func getPreviewLayerOrientation() -> AVCaptureVideoOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .unknown:
            return AVCaptureVideoOrientation.portrait
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        case .portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        }
    }
    
    fileprivate func getVideoOrientation() -> AVCaptureVideoOrientation {
        guard shouldUseDeviceOrientation, let deviceOrientation = self.deviceOrientation else { return previewLayer!.videoPreviewLayer.connection!.videoOrientation }
        
        switch deviceOrientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    fileprivate func getImageOrientation(forCamera: CameraSelection) -> UIImageOrientation {
        guard shouldUseDeviceOrientation, let deviceOrientation = self.deviceOrientation else { return forCamera == .rear ? .right : .leftMirrored }
        
        switch deviceOrientation {
        case .landscapeLeft:
            return forCamera == .rear ? .up : .downMirrored
        case .landscapeRight:
            return forCamera == .rear ? .down : .upMirrored
        case .portraitUpsideDown:
            return forCamera == .rear ? .left : .rightMirrored
        default:
            return forCamera == .rear ? .right : .leftMirrored
        }
    }
    
    fileprivate func processPhoto(_ imageData: Data) -> UIImage {
        let dataProvider = CGDataProvider(data: imageData as CFData)
        let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        
        let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: self.getImageOrientation(forCamera: self.currentCamera))
        
        return image
    }
    
    fileprivate func capturePhotoAsyncronously(completionHandler: @escaping(Bool) -> ()) {
        if let videoConnection = photoFileOutput?.connection(with: .video) {
            
            photoFileOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let image = self.processPhoto(imageData!)
                    
                    DispatchQueue.main.async {
                        self.cameraDelegate?.camera(self, didTake: image)
                    }
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            })
        } else {
            completionHandler(false)
        }
    }
    
    fileprivate func promptToAppSettings() {
        
        DispatchQueue.main.async(execute: { [unowned self] in
            let message = NSLocalizedString("AVCam doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
            let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { action in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                } else {
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(appSettings)
                    }
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    fileprivate func videoInputPresetFromVideoQuality(quality: VideoQuality) -> String {
        switch quality {
        case .high: return AVCaptureSession.Preset.high.rawValue
        case .medium: return AVCaptureSession.Preset.medium.rawValue
        case .low: return AVCaptureSession.Preset.low.rawValue
        case .resolution352x288: return AVCaptureSession.Preset.cif352x288.rawValue
        case .resolution640x480: return AVCaptureSession.Preset.vga640x480.rawValue
        case .resolution1280x720: return AVCaptureSession.Preset.hd1280x720.rawValue
        case .resolution1920x1080: return AVCaptureSession.Preset.hd1920x1080.rawValue
        case .iframe960x540: return AVCaptureSession.Preset.iFrame960x540.rawValue
        case .iframe1280x720: return AVCaptureSession.Preset.iFrame1280x720.rawValue
        case .resolution3840x2160:
            if #available(iOS 9.0, *) {
                return AVCaptureSession.Preset.hd4K3840x2160.rawValue
            }
            else {
                print("[SwiftyCam]: Resolution 3840x2160 not supported")
                return AVCaptureSession.Preset.high.rawValue
            }
        }
    }
    
    fileprivate class func deviceWithMediaType(_ mediaType: String, preferringPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if let devices = AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType)) as? [AVCaptureDevice] {
            return devices.filter({ $0.position == position }).first
        }
        
        return nil
    }
    
    fileprivate func changeFlashSettings(device: AVCaptureDevice, mode: AVCaptureDevice.FlashMode) {
        do {
            try device.lockForConfiguration()
            device.flashMode = mode
            device.unlockForConfiguration()
        } catch {
            print("[SwiftyCam]: \(error)")
        }
    }
    
    fileprivate func enableFlash() {
        if self.isCameraTorchOn == false {
            toggleFlash()
        }
    }
    
    fileprivate func disableFlash() {
        if self.isCameraTorchOn == true {
            toggleFlash()
        }
    }
    
    fileprivate func toggleFlash() {
        guard self.currentCamera == .rear else { return }
        let device = AVCaptureDevice.default(for: .video)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if device?.torchMode == .on {
                    device?.torchMode = .off
                    self.isCameraTorchOn = false
                } else {
                    do {
                        try device?.setTorchModeOn(level: 1.0)
                        self.isCameraTorchOn = true
                    } catch {
                        print("[SwiftyCam]: \(error)")
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print("[SwiftyCam]: \(error)")
            }
        }
    }
    
    fileprivate func setBackgroundAudioPreference() {
        guard allowBackgroundAudio == true else {
            return
        }
        
        guard audioEnabled == true else {
            return
        }
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord,
                                                            with: [.duckOthers, .defaultToSpeaker])
            
            session.automaticallyConfiguresApplicationAudioSession = false
        }
        catch {
            print("[SwiftyCam]: Failed to set background audio preference")
            
        }
    }
}

extension CameraViewController: CameraButtonDelegate {
    
    public func setMaxiumVideoDuration() -> Double {
        return maximumVideoDuration
    }
    
    public func buttonWasTapped() {
        takePhoto()
    }
    
    public func buttonDidBeginLongPress() {
        startVideoRecording()
    }
    
    
    public func buttonDidEndLongPress() {
        stopVideoRecording()
    }
    
    public func longPressDidReachMaximumDuration() {
        stopVideoRecording()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let currentBackgroundRecordingID = backgroundRecordingID {
            backgroundRecordingID = UIBackgroundTaskInvalid
            
            if currentBackgroundRecordingID != UIBackgroundTaskInvalid {
                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
            }
        }
        if error != nil {
            print("[Camera]: Movie file finishing error: \(error)")
        } else {
            DispatchQueue.main.async {
                self.cameraDelegate?.camera(self, didFinishProcessVideoAt: outputFileURL)
            }
        }
    }
}

extension CameraViewController {
    
    @objc fileprivate func zoomGesture(pinch: UIPinchGestureRecognizer) {
        guard pinchToZoom == true && self.currentCamera == .rear else { return }
        do {
            let captureDevice = AVCaptureDevice.devices().first as? AVCaptureDevice
            try captureDevice?.lockForConfiguration()
            
            zoomScale = min(maxZoomScale, max(1.0, min(beginZoomScale * pinch.scale,  captureDevice!.activeFormat.videoMaxZoomFactor)))
            
            captureDevice?.videoZoomFactor = zoomScale
            DispatchQueue.main.async {
                self.cameraDelegate?.camera(self, didChangeZoomLevel: self.zoomScale)
            }
            
            captureDevice?.unlockForConfiguration()
            
        } catch {
            print("[SwiftyCam]: Error locking configuration")
        }
    }
    
    @objc fileprivate func singleTapGesture(tap: UITapGestureRecognizer) {
        guard tapToFocus == true else { return }
        
        let screenSize = previewLayer!.bounds.size
        let tapPoint = tap.location(in: previewLayer!)
        let x = tapPoint.y / screenSize.height
        let y = 1.0 - tapPoint.x / screenSize.width
        let focusPoint = CGPoint(x: x, y: y)
        
        if let device = videoDevice {
            do {
                try device.lockForConfiguration()
                
                if device.isFocusPointOfInterestSupported == true {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                }
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .continuousAutoExposure
                device.unlockForConfiguration()
                
                DispatchQueue.main.async {
                    self.cameraDelegate?.camera(self, didFocusAtPoint: tapPoint)
                }
            }
            catch {
                
            }
        }
    }
    
    @objc fileprivate func doubleTapGesture(tap: UITapGestureRecognizer) {
        guard doubleTapCameraSwitch == true else {
            return
        }
        switchCamera()
    }
    
    @objc private func panGesture(pan: UIPanGestureRecognizer) {
        
        guard swipeToZoom == true && self.currentCamera == .rear else { return }
        let currentTranslation    = pan.translation(in: view).y
        let translationDifference = currentTranslation - previousPanTranslation
        
        do {
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            try captureDevice?.lockForConfiguration()
            
            let currentZoom = captureDevice?.videoZoomFactor ?? 0.0
            
            if swipeToZoomInverted == true {
                zoomScale = min(maxZoomScale, max(1.0, min(currentZoom - (translationDifference / 75),  captureDevice!.activeFormat.videoMaxZoomFactor)))
            } else {
                zoomScale = min(maxZoomScale, max(1.0, min(currentZoom + (translationDifference / 75),  captureDevice!.activeFormat.videoMaxZoomFactor)))
                
            }
            
            captureDevice?.videoZoomFactor = zoomScale
            
            DispatchQueue.main.async {
                self.cameraDelegate?.camera(self, didChangeZoomLevel: self.zoomScale)
            }
            
            captureDevice?.unlockForConfiguration()
            
        } catch {
            print("[SwiftyCam]: Error locking configuration")
        }
        
        if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            previousPanTranslation = 0.0
        } else {
            previousPanTranslation = currentTranslation
        }
    }
    
    fileprivate func addGestureRecognizers() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomGesture(pinch:)))
        pinchGesture.delegate = self
        previewLayer.addGestureRecognizer(pinchGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture(tap:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = self
        previewLayer.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(tap:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        previewLayer.addGestureRecognizer(doubleTapGesture)
    }
}

extension CameraViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = zoomScale;
        }
        return true
    }
}
