//
//  ARCameraViewController.swift
//  Graphee
//
//  Created by Azura on 11/06/21.
//

import UIKit
import SceneKit
import ARKit

class ARCameraViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    // APP LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did Load")
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.9725490212, green: 0.850980401, blue: 0.2823529541, alpha: 1)
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show stats
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        
        // Create new Scene
        let scene = SCNScene(named: "arcamera.scnassets/ReferencePoint.scn")!
        
        sceneView.scene = scene
        
        let tempNode = scene.rootNode.childNode(withName: "tempNode", recursively: true)
        tempNode?.position = SCNVector3(0, 0, -5)
        
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
        // Detect touch, make sure a touch is happening , or else skip
        guard let touch = touches.first else { return }
        guard let query = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .existingPlaneInfinite, alignment: .any) else { return }
        let results = sceneView.session.raycast(query)
        print("Results : \(results)")
        guard let hitTestResult = results.first else {
            print("No surface found")
            return
        }
        let hitTransform = hitTestResult.worldTransform
        print("Hit Transform : \(hitTransform)")
        
    }
    
    // ADD REFERENCE POINT
    func createReferencePoint(position: SCNVector3){
        let refPointShape = SCNSphere(radius: 0.1)
        let refPointNode = SCNNode(geometry: refPointShape)
        refPointNode.position = position
        sceneView.scene.rootNode.addChildNode(refPointNode)
    }
}
