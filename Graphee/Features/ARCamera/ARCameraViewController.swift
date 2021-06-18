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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimation()
        statusPanel.isHidden = false
        // Add Replace Button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Replace", style: .plain, target: self, action: #selector(replacePoint))
        // Add tap gesture recognizer
        addTapGestureRecognizer()
        // Configure lighting
        configureLighting()
        
    }
    
    func setupAnimation() {
        self.topLabel.text = "Tap anywhere to set reference point"
        
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.topLabel.alpha = 1.0
        }, completion: { [self]
            finished in
            
                    if finished {
                        //self.topLabel.text = "Tap anywhere to set reference point"
                        
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
            print(imageArray.count)
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
        print("Replace Point Tapped")
        let actionSheet = UIAlertController(title: "Replace current reference point?", message: "You will lose current point", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Replace", style: .destructive, handler: {_ in
            self.referencePoint?.removeFromParentNode()
            self.hasBeenPlaced = false
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation controller
        self.navigationController?.isNavigationBarHidden = false
        // Setup scene view
        setupSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause session
        sceneView.session.pause()
    }
    
    func setupSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.debugOptions = .showFeaturePoints
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @objc func addReferencePoint(withGestureRecognizer recognizer: UIGestureRecognizer) {
        print("Add Reference Point")
        if hasBeenPlaced { return }
        let tapLocation = recognizer.location(in: sceneView)
        guard let query = sceneView.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return  }
        let results = sceneView.session.raycast(query)
        guard let result = results.first else { return }
        let translation = result.worldTransform.columns
        
        // MARK : 3D Ref Point
        //        let referencePointScene = SCNScene(named: "assetcatalog.scnassets/ReferencePoint.scn")
        //        guard let referencePointNode = referencePointScene?.rootNode.childNode(withName: "refPointNode", recursively: false) else { return }
        //
        //        let shader = "float u = _surface.diffuseTexcoord.x; \n" +
        //                    "float v = _surface.diffuseTexcoord.y; \n" +
        //                    "int u100 = int(u * 100); \n" +
        //                    "int v100 = int(v * 100); \n" +
        //                    "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
        //                    "  // do nothing \n" +
        //                    "} else { \n" +
        //                    "    discard_fragment(); \n" +
        //                    "} \n"
        //
        //        referencePointNode.geometry?.firstMaterial?.emission.contents = UIColor.yellow
        //        referencePointNode.geometry?.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: shader]
        //        referencePointNode.geometry?.firstMaterial?.isDoubleSided = true
                
        //        referencePointNode.position = SCNVector3(translation.3.x, translation.3.y, translation.3.z)
        //        sceneView.scene.rootNode.addChildNode(referencePointNode)
        
        // MARK : PLANAR 2D Ref Point
        let image = UIImage(named: "RefPoint")
        referencePoint = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
        referencePoint.position.z = 0.1
        referencePoint.eulerAngles.x = -.pi / 2
        referencePoint.geometry?.materials.first?.diffuse.contents  = image
        referencePoint.opacity = 0.7
        referencePoint.position = SCNVector3(translation.3.x, translation.3.y, translation.3.z)
        sceneView.scene.rootNode.addChildNode(referencePoint)
        
        
        hasBeenPlaced = true
    }
    
    func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addReferencePoint(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
}

extension ARCameraViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("didAdd")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor(hue: 255, saturation: 255, brightness: 255, alpha: 0)

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 1
        
//        let refPointNode = addReferencePointer()
//        planeNode.addChildNode(refPointNode)
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
        print("didUpdate")
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
