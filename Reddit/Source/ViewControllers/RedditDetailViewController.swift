//
//  RedditDetailViewController.swift
//  Reddit
//
//  Created by Joey Wei on 3/30/18.
//  Copyright © 2018 Joey Wei. All rights reserved.
//

import UIKit

class RedditDetailViewController: UIViewController {

    var thumbnail: URL?

    var url: URL? {
        didSet {
            imageContentView?.url = url
            imageContentView?.delegate = self
        }
    }
    
    private var triedLoadingThumbnail = false

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
    
    // MARK: - State Restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        
        guard let thumbnail = thumbnail, let url = url else { return }
        coder.encode(thumbnail, forKey: "thumbnail")
        coder.encode(url, forKey: "url")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        let thumbnail = coder.decodeObject(forKey: "thumbnail") as? URL
        let url = coder.decodeObject(forKey: "url") as? URL
        self.url = url
        self.thumbnail = thumbnail
        
        super.decodeRestorableState(with: coder)
    }
}


// MARK: - Helper

private extension RedditDetailViewController {
    
    func setupUserInterface() {
        saveButton?.setTitle(NSLocalizedString("Save", comment: "Save"), for: .normal)
        cancelButton?.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        imageContentView?.url = url
        imageContentView?.delegate = self
    }
}

// MARK: - Action

private extension RedditDetailViewController {
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageContentView?.image else { return }
        save(image)
    }
}

// MARK: - Store Photo

private extension RedditDetailViewController {
    
    func save(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saved(_:with:contextInfo:)), nil)
    }
    
    @objc func saved(_ image: UIImage, with error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            presentAlert(title: NSLocalizedString("Error!", comment: "Error!"),
                         message: error.localizedDescription)
        } else {
            presentAlert(title: NSLocalizedString("Saved!", comment: "Saved!"),
                         message: NSLocalizedString("Your image has been saved to photo album.", comment: "photo saved message"))
        }
    }
}

// MARK: - ImageContentViewDelegate

extension RedditDetailViewController: ImageContentViewDelegate {
    
    func failLoading(_ error: String) {
        if triedLoadingThumbnail == false {
            triedLoadingThumbnail = true
            imageContentView?.url = thumbnail
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
