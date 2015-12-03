import AVFoundation
import UIKit
import Cartography


class ViewController: UIViewController, MotionHandlerDelegate {
    let kennyLayer = CALayer(
        contents: UIImage(named: "kennyg.png")!.CGImage,
        contentsGravity: kCAGravityResizeAspect
    )
    let warningLabel = UILabel(
        frame: CGRectZero,
        text: "🎷 Ermahgerd run away from Kenny G! 🎷",
        textAlignment: .Center,
        textColor: UIColor.whiteColor(),
        backgroundColor: UIColor.redColor()
    )

    var 🎷 = false
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer!
    var motionData: MotionHandler?

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

        warningLabel.hidden = true
    }
    
    func didReceiveSteps(numberOfSteps: Int) {
        if numberOfSteps >= 100 {
            🎷 = false
            pedoMeter.stopPedometerUpdates()
            return
        }
        kennyLayer.opacity = 1.0 - (Float(numberOfSteps) / 100.0)
        print(numberOfSteps)
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.addSubview(warningLabel)
        constrain(warningLabel, view) { label, view in
            label.top == view.top + 20
            label.left == view.left
            label.right == view.right
            label.height == 60
        }
        
        self.motionData = MotionHandler(delegate: self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()

        UIView.animateKeyframesWithDuration(
            2.0,
            delay: 0,
            options: [.Autoreverse, .Repeat],
            animations: { [weak self] in
                UIView.addKeyframeWithRelativeStartTime(
                    0.0,
                    relativeDuration: 0.5,
                    animations: { [weak self] in
                        self?.warningLabel.alpha = 0.0
                    }
                )
                UIView.addKeyframeWithRelativeStartTime(
                    0.5,
                    relativeDuration: 0.5,
                    animations: { [weak self] in
                        self?.warningLabel.alpha = 1.0
                    }
                )
            },
            completion: nil
        )
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
        guard let face = metadataObjects.first as? AVMetadataFaceObject else {
            return
        }
        🎷 = true // gross state 💩

        let faceRect = self.previewLayer
            .rectForMetadataOutputRectOfInterest(face.bounds)
        let scaledFaceRect = CGRectInset(faceRect, -30, -30)

        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            // TODO start updates
            self?.warningLabel.hidden = false
            self?.kennyLayer.hidden = false
            self?.kennyLayer.frame = scaledFaceRect
        }
    }
}
