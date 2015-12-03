//
//  MotionClass.swift
//  NerdCam
//
//  Created by Tanner W. Stokes on 12/3/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import UIKit
import CoreMotion

let pedoMeter = CMPedometer()

protocol MotionHandlerDelegate {
    func didReceiveSteps(numberOfSteps: Int)
}

class MotionHandler: NSObject  {
    
    let activityManager = CMMotionActivityManager()
    var delegate: MotionHandlerDelegate?

    init(delegate: MotionHandlerDelegate) {
        super.init()
        self.delegate = delegate
        self.startMotionUpdates()
    }
    
    func startMotionUpdates() {
        if CMPedometer.isStepCountingAvailable() {
            pedoMeter.startPedometerUpdatesFromDate(NSDate(), withHandler: { data, error in
                if data != nil {
                    self.delegate?.didReceiveSteps(data?.numberOfSteps as! Int)
                }
            })
        }

    }
}