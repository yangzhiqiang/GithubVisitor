//
//  ViewController.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // register notification observer
        registerNotification();
    }

    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    func registerNotification() -> Void {
        // Register the observer for cache datebase.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentByNotification(_:)),
                                               name: .githubCacheChanged,
                                               object: nil)
    }
    
    @objc func updateContentByNotification(_ noti : Notification){
        //refreshTableContent();
        if let record = DataCenter.shared.latestRecord() {
            print("Start at: \(record.startTime) End at: \(record.endTime), content: \(record.rawString)")
        }
    }
}

