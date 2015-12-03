import AVFoundation
import UIKit

class ViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer!
    let kennyLayer = CALayer(
        contents: UIImage(named: "kennyg.png")!.CGImage,
        contentsGravity: kCAGravityResizeAspect
    )

    func addPreviewLayerForSession(session: AVCaptureSession) {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        let rootLayer = self.view.layer
        layer.frame = rootLayer.bounds

        rootLayer.addSublayer(layer)
        rootLayer.addSublayer(self.kennyLayer)

        previewLayer = layer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let videoCamera = AVCaptureDevice
            .defaultDeviceWithMediaType(AVMediaTypeVideo)
        guard let session = Session.createCaptureSession(
            videoCamera, delegate: self
        ) else {
            fatalError("Could not create AV session.")
        }

        captureSession = session

        addPreviewLayerForSession(session)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()
    }

    override func viewDidDisappear(animated: Bool) {
        captureSession?.stopRunning()
        super.viewWillDisappear(animated)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewWillTransitionToSize(
        size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        previewLayer.frame = CGRect(origin: CGPointZero, size: size)
        let currentOrientation = UIDevice.currentDevice().orientation
        let videoOrientation = AVCaptureVideoOrientation(
            rawValue: currentOrientation.rawValue
        )!
        previewLayer.connection.videoOrientation = videoOrientation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(
        captureOutput: AVCaptureOutput!,
        didOutputMetadataObjects metadataObjects: [AnyObject]!,
        fromConnection connection: AVCaptureConnection!
    ) {
        guard let face = metadataObjects.first as? AVMetadataObject else {
            kennyLayer.hidden = true
            return
        }

        let faceRect = self.previewLayer
            .rectForMetadataOutputRectOfInterest(face.bounds)
        let scaledFaceRect = CGRectInset(faceRect, -30, -30)

        dispatch_async(dispatch_get_main_queue()) {
            self.kennyLayer.hidden = false
            self.kennyLayer.frame = scaledFaceRect
        }
    }
}
