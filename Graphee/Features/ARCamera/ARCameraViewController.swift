//
//  ARCameraViewController.swift
//  Graphee
//
//  Created by Azura on 11/06/21.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ARCameraViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    var tempNode: SCNNode!
    var hasBeenPlaced: Bool! = false
    
    // APP LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did Load")
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.9725490212, green: 0.850980401, blue: 0.2823529541, alpha: 1)
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Show stats
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        
        // Create new Scene
        let scene = SCNScene(named: "arcamera.scnassets/ReferencePoint.scn")!
        
        sceneView.scene = scene
        
//        tempNode = scene.rootNode.childNode(withName: "tempNode", recursively: false)
//        tempNode?.position = SCNVector3(0, 0, -5)
//
//        let cubeNode = tempNode?.childNode(withName: "cubeNode", recursively: false)
//
//        print("cube node")
//
//        let sm = "float u = _surface.diffuseTexcoord.x; \n" +
//            "float v = _surface.diffuseTexcoord.y; \n" +
//            "int u100 = int(u * 100); \n" +
//            "int v100 = int(v * 100); \n" +
//            "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
//            "  // do nothing \n" +
//            "} else { \n" +
//            "    discard_fragment(); \n" +
//            "} \n"
//        cubeNode?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
//        cubeNode?.geometry?.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
//        cubeNode?.geometry?.firstMaterial?.isDoubleSided = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.videoFormat = ARWorldTrackingConfiguration.supportedVideoFormats[0]
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Setup anchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create plane visualization
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // Set material
        plane.materials.first?.diffuse.contents = UIColor.systemTeal
        
        // Set node for plane
        let planeNode = SCNNode(geometry: plane)
        
        // Setup xyz position in world
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        
        // Set angle
        planeNode.position = SCNVector3(x, y, z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.5
        
        // Add child node
        node.addChildNode(planeNode)
        print("node \(node)")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              let planeNode = node.childNodes.first,
        let plane = planeNode.geometry as? SCNPlane else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat (planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        
        planeNode.position = SCNVector3(x, y, z)
    }

//    override func didReceiveMemoryWarning() {
//        <#code#>
//    }
//
//    // AR SESSION
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        <#code#>
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        <#code#>
//    }

    
    // TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        guard let query = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .existingPlaneInfinite, alignment: .any) else { return }
        
        let results = sceneView.session.raycast(query)
        
        guard let hitTestResult = results.first else {
            print("No surface found")
            return
        }
        
//        let hitTransform = hitTestResult.worldTransform
//        print("Hit Transform : \(hitTransform)")
//
//        let translation = hitTestResult.worldTransform
//        let x = translation.columns.3.x
//        let y = translation.columns.3.y
//        let z = translation.columns.3.z
//
//        let hitVector = SCNVector3Make(x, y, z)
        
        let hitTransform = SCNMatrix4.init(hitTestResult.worldTransform)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
//
        if (!hasBeenPlaced) {
            createReferencePoint(position: hitVector)
        }
        

//        let refPointScene = SCNScene(named: "ReferencePoint.scn")
//        guard let refPointNode = refPointScene?.rootNode.childNode(withName: "refPointNode", recursively: false) else { return }
        
        
    }
    
    // ADD REFERENCE POINT
    func createReferencePoint(position: SCNVector3){
        let refPointShape = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let refPointNode = SCNNode(geometry: refPointShape)
        
        // SHADER
        let sm = "float u = _surface.diffuseTexcoord.x; \n" +
            "float v = _surface.diffuseTexcoord.y; \n" +
            "int u100 = int(u * 100); \n" +
            "int v100 = int(v * 100); \n" +
            "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
            "  // do nothing \n" +
            "} else { \n" +
            "    discard_fragment(); \n" +
            "} \n"
        
        refPointNode.geometry?.firstMaterial?.emission.contents = UIColor.yellow
        refPointNode.geometry?.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
        refPointNode.geometry?.firstMaterial?.isDoubleSided = true
        refPointNode.position = position
        sceneView.scene.rootNode.addChildNode(refPointNode)
        hasBeenPlaced = true;
    }
}
