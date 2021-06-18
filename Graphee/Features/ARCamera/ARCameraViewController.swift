//
//  ARCameraViewController.swift
//  Graphee
//
//  Created by Azura Sakan Taufik on 15/06/21.
//

import UIKit
import ARKit

class ARCameraViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    var hasBeenPlaced: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add tap gesture recognizer
        addTapGestureRecognizer()
        // Configure lighting
        configureLighting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        let tapLocation = recognizer.location(in: sceneView)
        guard let query = sceneView.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return  }
        let results = sceneView.session.raycast(query)
        guard let result = results.first else { return }
        let translation = result.worldTransform.columns
        
        let referencePointScene = SCNScene(named: "assetcatalog.scnassets/ReferencePoint.scn")
        guard let referencePointNode = referencePointScene?.rootNode.childNode(withName: "refPointNode", recursively: false) else { return }
        
        let shader = "float u = _surface.diffuseTexcoord.x; \n" +
                    "float v = _surface.diffuseTexcoord.y; \n" +
                    "int u100 = int(u * 100); \n" +
                    "int v100 = int(v * 100); \n" +
                    "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
                    "  // do nothing \n" +
                    "} else { \n" +
                    "    discard_fragment(); \n" +
                    "} \n"

        referencePointNode.geometry?.firstMaterial?.emission.contents = UIColor.yellow
        referencePointNode.geometry?.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: shader]
        referencePointNode.geometry?.firstMaterial?.isDoubleSided = true
        referencePointNode.position = SCNVector3(translation.3.x, translation.3.y, translation.3.z)
        sceneView.scene.rootNode.addChildNode(referencePointNode)
        hasBeenPlaced = true
    }
    
    func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addReferencePoint(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
}

extension ARCameraViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = UIColor.systemTeal
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0
        
        node.addChildNode(planeNode)
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
