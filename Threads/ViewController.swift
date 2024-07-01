//
//  ViewController.swift
//  Threads
//
//  Created by E5000861 on 26/06/24.
//

import UIKit
import AVKit
import AVFoundation
class ViewController: UIViewController {
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    let imageView = UIImageView()
    let fetchImageButton = UIButton(type: .system)
    let playVideoButton = UIButton(type: .system)
    let videoContainerView = UIView()
    let videoView = UIView()
    let activity = UIActivityIndicatorView()
    var isAlertPresented = false
    var avPlayer = AVPlayer()
    var playerView = AVPlayerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    class SpinnerViewController: UIViewController {
        var spinner = UIActivityIndicatorView(style: .whiteLarge)
        
        override func loadView() {
            view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            view.addSubview(spinner)
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    func createSpinnerView() {
        let child =  SpinnerViewController()
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    func setupUI() {
        // Setup video container view
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoContainerView)
        NSLayoutConstraint.activate([
            videoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            videoContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            videoContainerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Setup image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Setup fetch image button
        fetchImageButton.setTitle("Fetch Image", for: .normal)
        fetchImageButton.backgroundColor = .black
        fetchImageButton.translatesAutoresizingMaskIntoConstraints = false
        fetchImageButton.addTarget(self, action: #selector(fetchImage), for: .touchUpInside)
        view.addSubview(fetchImageButton)
        NSLayoutConstraint.activate([
            fetchImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            fetchImageButton.widthAnchor.constraint(equalToConstant: 150),
            fetchImageButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Setup play video button
        playVideoButton.setTitle("Play Video", for: .normal)
        playVideoButton.translatesAutoresizingMaskIntoConstraints = false
        playVideoButton.backgroundColor = .black
        playVideoButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        view.addSubview(playVideoButton)
        NSLayoutConstraint.activate([
            playVideoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playVideoButton.topAnchor.constraint(equalTo: fetchImageButton.bottomAnchor, constant: 20),
            playVideoButton.widthAnchor.constraint(equalToConstant: 150),
            playVideoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func fetchImage() {
        // Create a new thread to fetch the image
        createSpinnerView()
        self.activity
        let fetchThread = Thread(target: self, selector: #selector(fetchImageInBackground), object: nil)
        fetchThread.start()
    }
    
    @objc func fetchImageInBackground() {
        let imageUrlString = "https://picsum.photos/200/200"
        
        guard let url = URL(string: imageUrlString) else {
            self.performSelector(onMainThread: #selector(showErrorAlert(_:)), with: "Invalid URL", waitUntilDone: false)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                // Update UI on main thread
                self.performSelector(onMainThread: #selector(updateImageView(_:)), with: image, waitUntilDone: false)
            } else {
                self.performSelector(onMainThread: #selector(showErrorAlert(_:)), with: "Failed to create image from data", waitUntilDone: false)
            }
        } catch {
            self.performSelector(onMainThread: #selector(showErrorAlert(_:)), with: "Error: \(error.localizedDescription)", waitUntilDone: false)
        }
    }
    
    @objc func updateImageView(_ image: UIImage) {
        self.imageView.image = image
    }
    
    
    @objc func showErrorAlert(_ message: String) {
        guard !isAlertPresented else { return }
        isAlertPresented = true
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.isAlertPresented = false
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func playVideo() {
        // URL of the video to be played
        createSpinnerView()
        let videoUrlString = "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
        
        guard let url = URL(string: videoUrlString) else {
            showErrorAlert("Invalid Video URL")
            return
        }
        
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoContainerView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoContainerView.layer.addSublayer(playerLayer)
        // Play the video
        player.play()
       
    }
 

  
    
 
    
    
  
    
}

