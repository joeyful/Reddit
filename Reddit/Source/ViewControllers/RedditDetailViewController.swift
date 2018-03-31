//
//  RedditDetailViewController.swift
//  Reddit
//
//  Created by Joey Wei on 3/30/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditDetailViewController: UIViewController {

    var child: Child?
    private var isThumbnailLoaded = false

    // MARK: - Outlets

    @IBOutlet weak var imageContentView  : ImageContentView?
    @IBOutlet weak var saveButton        : UIButton?
    @IBOutlet weak var cancelButton      : UIButton?
    @IBOutlet weak var loadingGuardView  : UIView?
    
    // MARK: - Class Function

    class func buildFromStoryboard() -> RedditDetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let redditDetailViewController = storyboard.instantiateViewController(withIdentifier:  "RedditDetailVC") as? RedditDetailViewController else { return nil }
        return  redditDetailViewController
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
}


// MARK: - Helper

private extension RedditDetailViewController {
    
    func setupUserInterface() {
        saveButton?.setTitle(NSLocalizedString("Save", comment: "Save"), for: .normal)
        cancelButton?.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        imageContentView?.url = child?.image?.url
        imageContentView?.delegate = self
    }
}


// MARK: - Action

extension RedditDetailViewController {
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        // save image to photo library
        // in a group named Reddit
    }
}


// MARK: - ImageContentViewDelegate

extension RedditDetailViewController: ImageContentViewDelegate {
    
    func failLoading(_ error: String) {
        if isThumbnailLoaded == false {
            isThumbnailLoaded = true
            imageContentView?.url = child?.thumbnail
        }
        else {
            presentAlert(title: NSLocalizedString("Error", comment: "error alert title"), message: error)
            loadingGuardView?.fadeOut()
        }
    }
    
    func imageLoaded(_ image: UIImage) {
        loadingGuardView?.fadeOut()
        saveButton?.isEnabled = true

    }
}
