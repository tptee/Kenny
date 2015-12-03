import AVFoundation
import UIKit

struct Session {
    static func createCaptureSession(
        device: AVCaptureDevice,
        delegate: AVCaptureMetadataOutputObjectsDelegate
    ) -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        guard let
            input = try? AVCaptureDeviceInput(device: device)
            where captureSession.canAddInput(input)
        else {
            return nil
        }
        captureSession.addInput(input)
        addMetadataOutputToSession(captureSession, delegate: delegate)
        return captureSession
    }

    static func addMetadataOutputToSession(
        session: AVCaptureSession,
        delegate: AVCaptureMetadataOutputObjectsDelegate) {
        let metadataOutput = AVCaptureMetadataOutput()
        if !session.canAddOutput(metadataOutput) {
            print("Cannot add metadata output.")
            return
        }

        session.addOutput(metadataOutput)
        let queue = dispatch_queue_create(
            "com.bignerdranch.kennyg.MetadataOutput",
            DISPATCH_QUEUE_SERIAL
        )
        metadataOutput.setMetadataObjectsDelegate(delegate, queue: queue)
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
    }
}
