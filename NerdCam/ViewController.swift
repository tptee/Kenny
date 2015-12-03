import AVFoundation
import UIKit



class ViewController: UIViewController {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var hatLayer: CALayer = {
        let hat = CALayer()
        hat.contents = UIImage(named: "kennyg.png")!.CGImage
        hat.contentsGravity = kCAGravityResizeAspect
        return hat
    }()

    func newVideoCaptureSession() -> AVCaptureSession? {
        let videoCamera = AVCaptureDevice
            .defaultDeviceWithMediaType(AVMediaTypeVideo)

        let videoInput: AVCaptureDeviceInput?
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCamera)
        } catch let error as NSError {
            print("\(__FUNCTION__): failed to init capture device" +
                "with video camera \(videoCamera): error \(error)")
            videoInput = nil
        }

        /* Attach the input to a capture session */
        let captureSession = AVCaptureSession()
        if !captureSession.canAddInput(videoInput) {
            print("\(__FUNCTION__): cannot add input \(videoCamera)")
            return nil
        }

        captureSession.addInput(videoInput)
        return captureSession
    }

    func addPreviewLayerForSession(session: AVCaptureSession) {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        let rootLayer = self.view.layer
        layer.frame = rootLayer.bounds
        rootLayer.addSublayer(layer)
        self.view.layer.addSublayer(self.hatLayer)

        previewLayer = layer
    }

    func addMetadataOutputToSession(session: AVCaptureSession) {
        let metadataOutput = AVCaptureMetadataOutput()
        if !session.canAddOutput(metadataOutput) {
            print("\(__FUNCTION__): cannot add output \(metadataOutput)")
            return
        }

        session.addOutput(metadataOutput)
        let queue = dispatch_queue_create(
            "com.bignerdranch.advios.NerdCam.MetadataOutput", DISPATCH_QUEUE_SERIAL
        )
        metadataOutput.setMetadataObjectsDelegate(self, queue: queue)
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Crash if we can't get a capture session */
        captureSession = newVideoCaptureSession()
        addPreviewLayerForSession(captureSession)
        addMetadataOutputToSession(captureSession)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }

    override func viewDidDisappear(animated: Bool) {
        captureSession.stopRunning()
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
            hatLayer.hidden = true
            return
        }

        let faceRect = self.previewLayer
            .rectForMetadataOutputRectOfInterest(face.bounds)
        let scaledFaceRect = CGRectInset(faceRect, -30, -30)

        dispatch_async(dispatch_get_main_queue()) {
            self.hatLayer.hidden = false
            self.hatLayer.frame = scaledFaceRect
        }
    }
}
