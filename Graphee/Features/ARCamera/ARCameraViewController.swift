//
//  ARCameraViewController.swift
//  Graphee
//
//  Created by Azura Sakan Taufik on 15/06/21.
//

import UIKit
import ARKit
import RealityKit

class ARCameraViewController: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var statusPanel: UIVisualEffectView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var animationImageView: UIImageView!
    var animationImages: [UIImage] = []
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var referencePoint : SCNNode!
    var hasBeenPlaced: Bool! = false
    var hasAnimationBeenPlayed: Bool! = false
    var hasAnimationFinished: Bool! = false
    static var translationVector: SIMD4<Float>!
    static var map: ARWorldMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusPanel.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor.init(named: "Title")
        topLabel.isHidden = true
        bottomLabel.isHidden = true
        hasAnimationBeenPlayed = SettingHelper.shared.getAnimationBeenPlayed()
        if !hasAnimationBeenPlayed {
            setupAnimation()
            SettingHelper.shared.setAnimationBeenPlayed(status: true)
        }
        
        // Add Replace Button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Replace", style: .plain, target: self, action: #selector(replacePoint))
        // Add tap gesture recognizer
        addTapGestureRecognizer()
        // Configure lighting
        configureLighting()
        // Check
        if let translationVec = ARCameraViewController.translationVector {
            createReferencePoint(translationVector: translationVec)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func setupAnimation() {
        topLabel.isHidden = false
        bottomLabel.isHidden = false
        self.topLabel.text = "Tap anywhere to set reference point"
        
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.topLabel.alpha = 1.0
        }, completion: { [self]
            finished in
                    if finished {
                        UIView.animate(withDuration: 1.0, delay: 9.5, options: .curveEaseOut, animations: { self.topLabel.alpha = 0.0
                        }, completion: nil)
                    }
                })
    
        self.bottomLabel.text = "Reference point can be used as a guidance \nwhen you adjust your product's rotation"
        
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.bottomLabel.alpha = 1.0
        }, completion: { [self]
            finished in
                    if finished {
                        UIView.animate(withDuration: 1.0, delay: 9.5, options: .curveEaseOut, animations: { self.bottomLabel.alpha = 0.0
                        }, completion: nil)
                    }
                })
    
        animationImages = createImageArray(total: 1255, imagePrefix: "animateTest-")
        animate(imageView: animationImageView, images: animationImages)
    }
    
    func createImageArray(total: Int, imagePrefix: String) ->[UIImage] {
        var imageArray: [UIImage] = []
        for imageCount in 1000...total {
            let imageName = "\(imagePrefix)\(imageCount).png"
            let image = UIImage(named: imageName)!
            imageArray.append(image)
        }
        return imageArray
    }
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 10.25
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
    
    @objc func replacePoint() {
        let actionSheet = UIAlertController(title: "Replace current reference point?", message: "You will lose current point", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Replace", style: .destructive, handler: {_ in
            self.referencePoint?.removeFromParentNode()
            self.hasBeenPlaced = false
            ARCameraViewController.translationVector = nil
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            SettingHelper.shared.setAnimationBeenPlayed(status: false)
            self.setupAnimation()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation controller
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(named: "Title")
        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "LightColor")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Setup scene view
        setupSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause session
        self.sceneView.session.pause()
        self.sceneView.session.getCurrentWorldMap {
            (worldMap, error) in
            guard let worldMap = worldMap else { return }
            ARCameraViewController.map = worldMap
        }
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "Title")
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(named: "AccentColor")
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        // Setup configurations
        configuration.videoFormat = ARWorldTrackingConfiguration.supportedVideoFormats[0]
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal
        // Save world map state
        if let worldMap = ARCameraViewController.map {
            configuration.initialWorldMap = ARCameraViewController.map
        }
        sceneView.session.run(configuration)
        sceneView.delegate = self
    }
    
    func configureLighting() {
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @objc func addReferencePoint(withGestureRecognizer recognizer: UIGestureRecognizer) {
        if hasBeenPlaced { return }
        let tapLocation = recognizer.location(in: sceneView)
        guard let query = sceneView.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return  }
        let results = sceneView.session.raycast(query)
        guard let result = results.first else { return }
        let translation = result.worldTransform.columns
        ARCameraViewController.translationVector = translation.3
        createReferencePoint(translationVector: translation.3)
        hasBeenPlaced = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func createReferencePoint(translationVector: SIMD4<Float>) {
        // MARK : PLANAR 2D Ref Point
        let image = UIImage(named: "RefPoint")
        referencePoint = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
        referencePoint.position.z = 0.1
        referencePoint.eulerAngles.x = -.pi / 2
        referencePoint.geometry?.materials.first?.diffuse.contents  = image
        referencePoint.opacity = 0.7
        referencePoint.position = SCNVector3(translationVector.x, translationVector.y, translationVector.z)
        sceneView.scene.rootNode.addChildNode(referencePoint)
    }
    
    func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addReferencePoint(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
}

extension ARCameraViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        DispatchQueue.main.async {
            self.statusLabel.text = "Surface Detected"
        }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor(hue: 255, saturation: 255, brightness: 255, alpha: 0)

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 1
        node.addChildNode(planeNode)
    
    }
    
    
    func addReferencePointer() -> SCNNode {
        let image = UIImage(named: "RefPoint")
        let refPointNode = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
        refPointNode.position.y = 0.1
        refPointNode.geometry?.materials.first?.diffuse.contents  = image
        return refPointNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              let planeNode = node.childNodes.first,
              let plane = planeNode.geometry as? SCNPlane else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height

        planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
    }
}
