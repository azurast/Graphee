//
//  MainCameraViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit
import AVFoundation
import CoreMotion

class MainCameraViewController: UIViewController {
    // MARK: - Attributes
    
    var directionArray: [Photo?]!
    
    // Capture Session
    var session: AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    var cameraInitialized = false
    
    var motionManager = CMMotionManager()
    
    private var navigationView: UIView!
    private var torchImageView: UIImageView!
    private var timerImageView: UIImageView!
    
    private var veryTopView: VeryTopView!
    private var topView: UIView!
    
    private var messageView: UIView!
    private var messageLabel: UILabel!
    
    private var bottomView: BottomCameraView!
    
    private var segmentedControl: UISegmentedControl!
    
    private var angleView: AngleView?
    
    private var settingView: SettingView?

    private var timer: Timer?
    private var seconds = 0
    private var timerDuration = 0.0
    
    private var timerView: TimerView?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.\
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        if height == 0 {
            height = UIApplication.shared.statusBarFrame.size.height
        }
        
        CameraImages.shared.setStarterImageNil()
        CameraImages.shared.setMainCaptureToFalse()
        
        view.backgroundColor =  #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)

        
        view.layer.addSublayer(previewLayer)
        
        setupNavigationView(statusBarHeight: height)
        checkCameraPermission()
        setupVeryBottomView()
        setupTopView(statusBarHeight: height)
        addSegmentedControl()
        setLabelMessage(statusBarHeight: height)
        setupBottomView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if cameraInitialized {
            self.session?.startRunning()
            bottomView.setButtonYellow()
            
            for (key, value) in CameraImages.shared.realImageDict {
                if value != nil {
                    veryTopView.unhideDoneButton()
                    return
                }
            }
        } else {
            self.navigationController?.isNavigationBarHidden = true
            cameraInitialized = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.session?.stopRunning()
        motionManager.stopDeviceMotionUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runMotionManager()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        if height == 0 {
            height = UIApplication.shared.statusBarFrame.size.height
        }
        
        if SettingHelper.shared.isRatio11Activated() {
            previewLayer.frame = CGRect(x: 0, y: topView.frame.height + height + veryTopView.frame.height, width: view.frame.width, height: view.frame.width)
        }
        else if SettingHelper.shared.isRatio43Activated() {
            let viewElements = topView.frame.height + veryTopView.frame.height + bottomView.frame.height + height + 50
            previewLayer.frame = CGRect(x: 0, y: topView.frame.height + height + veryTopView.frame.height, width: view.frame.width, height: view.frame.height - viewElements)
        }
        else if SettingHelper.shared.isRatio169Activated() {
            previewLayer.frame = CGRect(x: 0, y: height + veryTopView.frame.height, width: view.frame.width, height: view.frame.height - veryTopView.frame.height - height - 50)
            
        }
        
    }
    
    // MARK: - Motion Function
    private func runMotionManager() {
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xTrueNorthZVertical, to: OperationQueue.current!) { data, error in
            
//            let pitchDeg = 180 * data!.attitude.pitch/Double.pi
            
            let gravityZ = data!.gravity.z
            let gravityX = data!.gravity.x
            
            let roundedGravityZ = round(gravityZ * 100)
            var roundedGravityX = round(gravityX * 100)
            
            if roundedGravityX > 90 {
                roundedGravityX = 90
            } else if roundedGravityX < -90 {
                roundedGravityX = -90
            }
            
            guard let tempAngleView = self.angleView else { return }
            
            tempAngleView.updateMainHorizontalLine(gravityZ: roundedGravityZ) { message, color in
                if self.segmentedControl.selectedSegmentIndex == 1 {
                    self.messageView.backgroundColor = color
                    self.messageLabel.text = message
                }
            }
            tempAngleView.updateGyroHorizontalLine(angle: CGFloat(roundedGravityX))
        }
    }

    // MARK: - Setup UIView
    private func setupNavigationView(statusBarHeight: CGFloat) {
        
        veryTopView = VeryTopView(frame: CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: 80))
        veryTopView.backgroundColor =  #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        veryTopView.createImage()
        veryTopView.delegate = self
        veryTopView.hideDoneButton()
        view.addSubview(veryTopView)
        
        if SettingHelper.shared.isTorchActivated() {
            veryTopView.changeTorchColorActivated()
        }
        else {
            veryTopView.changeTorchColorDeactivated()
        }
        
        if SettingHelper.shared.isTimer3SecActivated() || SettingHelper.shared.isTimer10SecActivated() {
            veryTopView.changeTimerColorActivated()
        }
        else {
            veryTopView.changeTimerColorDeactivated()
        }
    }
    
    private func setupVeryBottomView() {
        let veryBottomView = UIView(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
        veryBottomView.backgroundColor =  #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1).withAlphaComponent(0.5)
        view.addSubview(veryBottomView)
    }
    
    private func setupTopView(statusBarHeight: CGFloat) {
        topView = UIView(frame: CGRect(x: 0, y: statusBarHeight + veryTopView.frame.height, width: view.frame.width, height: 50))
        topView.backgroundColor =  #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1).withAlphaComponent(0.5)
        view.addSubview(topView)
    }
    
    private func setupBottomView() {
        bottomView = BottomCameraView(frame: CGRect(x: 0, y: view.frame.height - 150 - 50, width: view.frame.width, height: 150))
        bottomView.createDirectionButton()
        bottomView.createMainButton()
        bottomView.directionButtonDelegate = self
        bottomView.mainButtonDelegate = self
        bottomView.backgroundColor =  #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1).withAlphaComponent(0.5)
        view.addSubview(bottomView)
    }
    
    private func setLabelMessage(statusBarHeight: CGFloat) {
        messageView = UIView(frame: CGRect(x: view.frame.width / 2 - ((view.frame.width - 100) / 2), y: statusBarHeight + topView.frame.height + veryTopView.frame.height + 10, width: view.frame.width - 100, height: 30))
        messageView.backgroundColor = .lightGray
        messageView.layer.cornerRadius = 10
        view.addSubview(messageView)
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: messageView.frame.width, height: 0))
        messageLabel.text = "Hello World"
        messageLabel.font = UIFont(name: "Sora-Regular", size: 12)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.frame.size.height = messageLabel.intrinsicContentSize.height
        messageLabel.textAlignment = .center
        messageLabel.center = CGPoint(x: messageView.frame.width / 2, y: messageView.frame.height / 2)
        messageView.addSubview(messageLabel)
        
    }
    
    private func setupAngleView() {
        
        angleView = AngleView(frame: CGRect(x: 0, y: previewLayer.frame.origin.y, width: view.frame.width, height: previewLayer.frame.height))
        
        view.addSubview(angleView!)
        
        angleView?.isUserInteractionEnabled = false
        angleView!.backgroundColor = .clear
        
        self.view.bringSubviewToFront(topView)
        self.view.bringSubviewToFront(bottomView)
        self.view.bringSubviewToFront(messageView)
        
        if let view = settingView {
            angleView?.isUserInteractionEnabled = false
            self.view.bringSubviewToFront(view)
        }
    }
    
    private func unsetAngleView() {
        
        angleView?.removeFromSuperview()

        angleView = nil
    }
    
    private func setupSettingView() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        if height == 0 {
            height = UIApplication.shared.statusBarFrame.size.height
        }
        
        let viewElementsHeight = topView.frame.height + veryTopView.frame.height + bottomView.frame.height + height + 50
        let ratio43Height = view.frame.height - viewElementsHeight
        
        // topView.frame.origin.y + topView.frame.height
        //view.frame.height - topView.frame.height - bottomView.frame.height - 200 - 50
        settingView = SettingView(frame: CGRect(x: 0, y: bottomView.frame.origin.y - (ratio43Height - bottomView.frame.height), width: view.frame.width, height: (ratio43Height - bottomView.frame.height)))
        settingView!.backgroundColor =  #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1).withAlphaComponent(0.5)
        settingView?.delegate = self
        view.addSubview(settingView!)
        
    }
    
    private func addSegmentedControl() {
        let titles = ["Light", "Angle"]
        
        segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Sora-Regular", size: 12)], for: .normal)
        segmentedControl.tintColor = .white
        segmentedControl.backgroundColor = .darkGray
        segmentedControl.selectedSegmentIndex = 0
        for index in 0...titles.count-1 {
            segmentedControl.setWidth(125, forSegmentAt: index)
        }
        segmentedControl.layer.cornerRadius = 10
        
        segmentedControl.frame = CGRect(x: topView.frame.width / 2 - 125, y: 5, width: 250, height: 30)
        segmentedControl.addTarget(self, action: #selector(changeColor(sender:)), for:UIControl.Event.valueChanged)
        
        topView.addSubview(segmentedControl)
    }
    
    @objc func changeColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
              case 0:
                    unsetAngleView()
                    break
              case 1:
                    setupAngleView()
                    break
            default:
                print("Nothing")
        }
    }
    
    private func timerWorking() {
        if SettingHelper.shared.isTimer3SecActivated() {
            seconds = 3

        } else if SettingHelper.shared.isTimer10SecActivated() {
            seconds = 10
            
        }
        
        timerDuration = Double(seconds)
        
        self.timerView = TimerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.timerView?.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(timerView!)
        
        self.timerView?.changeLabelText(number: String(seconds))
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc private func timerFired() {
        DispatchQueue.main.async {
            self.timerView?.changeLabelText(number: String(self.seconds))
        }
        
        if seconds == 0 {
            timer?.invalidate()
            self.timerView?.removeFromSuperview()
            self.timerView = nil
        }
        else {
            seconds -= 1
        }
        
    }
    
    // MARK: - Camera Function
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // Requested
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        default:
            break
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                let dataOutput = AVCaptureVideoDataOutput()
                let depthOutput = AVCaptureDepthDataOutput()
                
                if session.canAddOutput(dataOutput) {
                    dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Video Queue"))
                    session.addOutput(dataOutput)
                    session.addOutput(output)
                }
                
                if session.canAddOutput(depthOutput) {
                    depthOutput.setDelegate(self, callbackQueue: DispatchQueue(label: "Depth Queue"))
                    depthOutput.isFilteringEnabled = true
                    
                    session.addOutput(depthOutput)
                    
                    let depthConnection = depthOutput.connection(with: .depthData)
                    depthConnection?.videoOrientation = .portrait
                }
                
                self.session = session
                self.session?.startRunning()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - VeryTopView Delegate
extension MainCameraViewController: VeryTopViewDelegate {
    func doneButtonTapped() {
        for (_, element) in directionArray.enumerated() {
            
            guard let image = CameraImages.shared.realImageDict[(element?.direction)!] else { continue }
            
           print(element?.direction)
            
            guard let image2 = image else { return }

            if let directoryId = element?.directory {
                FileManagerHelper.instance.deleteImageInStorage(imageName: directoryId)
            }

            let imageName = UUID().uuidString
            FileManagerHelper.instance.saveImageToStorage(image: image2, imageName: imageName)

            CoreDataService.instance.updatePhotoImage(photo: element!, imageId: imageName)
        }
        
        NotificationCenter.default.post(name: Notification.Name("updateAction"), object: nil)
        
        let destinationVC = navigationController?.viewControllers.filter {$0 is FolderViewController}.first as! FolderViewController
        self.navigationController?.popToViewController(destinationVC, animated: true)
    }
    
    func cancelButtonTapped() {
        CameraImages.shared.setNextDirection(direction: "Front")
        CameraImages.shared.removeAllDictionary()
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - SettingView Delegate
extension MainCameraViewController: SettingViewDelegate {
    func setTorchImageActivate() {
        if SettingHelper.shared.isTorchActivated() {
            veryTopView.changeTorchColorActivated()
        }
        else {
            veryTopView.changeTorchColorDeactivated()
        }
        
    }
    
    func setTimerImageActivate() {
        if SettingHelper.shared.isTimer3SecActivated() || SettingHelper.shared.isTimer10SecActivated() {
            veryTopView.changeTimerColorActivated()
        }
        else {
            veryTopView.changeTimerColorDeactivated()
        }
    }
    
    func setRatioActivate() {
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        if SettingHelper.shared.isRatio11Activated() {
            previewLayer.frame = CGRect(x: 0, y: topView.frame.height + height + veryTopView.frame.height, width: view.frame.width, height: view.frame.width)
            
            if angleView != nil {
                unsetAngleView()
                setupAngleView()
            }
            
            if let view = settingView {
                angleView?.isUserInteractionEnabled = false
                self.view.bringSubviewToFront(view)
            }
        }
        else if SettingHelper.shared.isRatio43Activated() {
            previewLayer.frame = CGRect(x: 0, y: topView.frame.height + height + veryTopView.frame.height, width: view.frame.width, height: view.frame.height - topView.frame.height - veryTopView.frame.height - bottomView.frame.height - height - 50)
            
            if angleView != nil {
                unsetAngleView()
                setupAngleView()
            }
            
            if let view = settingView {
                angleView?.isUserInteractionEnabled = false
                self.view.bringSubviewToFront(view)
            }
        }
        else if SettingHelper.shared.isRatio169Activated() {
            
            previewLayer.frame = CGRect(x: 0, y: height + veryTopView.frame.height, width: view.frame.width, height: view.frame.height - veryTopView.frame.height - height - 50)
            
            if angleView != nil {
                unsetAngleView()
                setupAngleView()
            }
            
            
            self.view.bringSubviewToFront(topView)
            self.view.bringSubviewToFront(bottomView)
            
            if let view = settingView {
                angleView?.isUserInteractionEnabled = false
                self.view.bringSubviewToFront(view)
            }
        }
        
    }
}

// MARK: - MainButton Delegate
extension MainCameraViewController: MainButtonDelegate {
    func mainButtonTapped() {
        if SettingHelper.shared.isTimer3SecActivated() || SettingHelper.shared.isTimer10SecActivated() {
            timerWorking()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timerDuration + 0.5) {
                SettingHelper.shared.activateTorch()
                self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            }
        }
        else {
            SettingHelper.shared.activateTorch()
            output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }

        if SettingHelper.shared.isRatio11Activated() {
            CameraImages.shared.addRatio(direction: CameraImages.shared.getNextDirectionInString(), ratio: SettingHelper.shared.ratio11)
        } else if SettingHelper.shared.isRatio43Activated() {
            CameraImages.shared.addRatio(direction: CameraImages.shared.getNextDirectionInString(), ratio: SettingHelper.shared.ratio43)
        } else if SettingHelper.shared.isRatio169Activated() {
            CameraImages.shared.addRatio(direction: CameraImages.shared.getNextDirectionInString(), ratio: SettingHelper.shared.ratio169)
        }
    }
    
    func settingButtonTapped() {
        if settingView == nil {
            setupSettingView()
        }
        else {
            settingView?.removeFromSuperview()
            settingView = nil
        }
    }
    
    func referencePointButtonTapped() {
        print("Reference Point Tapped")
        let arcameraVC = self.storyboard?.instantiateViewController(identifier: "arcamera") as! ARCameraViewController
        self.navigationController?.pushViewController(arcameraVC, animated: true)
    }
}

// MARK: - DirectionButton Delegate
extension MainCameraViewController: DirectionButtonDelegate {
    func directionButtonTapped(direction: Direction) {
        CameraImages.shared.setNextDirection(direction: direction.rawValue)
        
        if CameraImages.shared.returnImageFromDirection(direction: direction.rawValue) != nil {
            navigateToPreviewStoryboard()
        }
    }
}

// MARK: - AVCaptureDepthDataOutput Delegate
extension MainCameraViewController: AVCaptureDepthDataOutputDelegate {
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        
        
    }
}

// MARK: - AVCapturePhotoCapture Delegate
extension MainCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        
        guard let image = UIImage(data: data) else { return }
        
        SettingHelper.shared.deactivateTorch()
        
        session?.stopRunning()
        
        let croppedImage = cropToPreviewLayer(originalImage: image)
        
        print(croppedImage)
        
        CameraImages.shared.addImage(direction: CameraImages.shared.getNextDirectionInString(), image: croppedImage)
        CameraImages.shared.mainCameraCapture[CameraImages.shared.getNextDirectionInString()] = true
    
        navigateToPreviewStoryboard()
        
    }
    
    private func cropToPreviewLayer(originalImage: UIImage) -> UIImage? {
        guard let cgImage = originalImage.cgImage else { return nil }

        let outputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: previewLayer.bounds)

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)

        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation)
        }
        
        return nil
    }

}

// MARK: - AVCaptureVideoDataOutputSampleBuffer Delegate
extension MainCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let value = getBrightness(sampleBuffer: sampleBuffer)
        
        DispatchQueue.main.async {
            if self.segmentedControl.selectedSegmentIndex == 0 {
                if value < 5 {
                    self.messageView.backgroundColor = .lightGray
                    self.messageLabel.text = "Need More Light"
                } else if value >= 20 {
                    self.messageView.backgroundColor = .lightGray
                    self.messageLabel.text = "Need Less Light"
                } else {
                    self.messageView.backgroundColor = UIColor.init(named: "YellowColor")
                    self.messageLabel.text = "Perfect Light"
                }
            }
        }
    }

    func getBrightness(sampleBuffer: CMSampleBuffer) -> Double {
        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
        let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
        let exifData = metadata.value(forKey: "{Exif}") as? NSMutableDictionary

//        let brightnessValue : Double = exifData?[kCGImagePropertyExifBrightnessValue as String] as! Double

        let fNumber: Double = exifData?["FNumber"] as! Double
        let exposureTime: Double = exifData?["ExposureTime"] as! Double
        let iSOSpeedRatingsArray = exifData!["ISOSpeedRatings"] as? NSArray
        let iSOSpeedRatings: Double = iSOSpeedRatingsArray![0] as! Double
        let calibrationConstant: Double = 50
        
        let luminosity : Double = (calibrationConstant * fNumber * fNumber ) / ( exposureTime * iSOSpeedRatings )

        return luminosity
    }
}


// MARK: - Navigation
extension MainCameraViewController {
    
    private func navigateToPreviewStoryboard() {
        let previewStoryboard = UIStoryboard(name: "PreviewStoryboard", bundle: nil)
        let previewViewController = previewStoryboard.instantiateViewController(identifier: "preview") as! PreviewViewController
        
        self.navigationController?.pushViewController(previewViewController, animated: true)
    }
    
}
