//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 17.03.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage!
    
    var fullImageUrl: URL?
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        scroll.backgroundColor = .yBlack
        
        return scroll
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "BackwardSingle"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        layoutImageView()
        setupBackButton()
        setupShareButton()
        
        imageView.image = image
        setPhoto()
    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = view.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let zoomedWidth = scrollView.bounds.width * scale
        let zoomedHeight = scrollView.bounds.height * scale
        
        let horizontalInset = (scrollView.bounds.width - zoomedWidth) / 2
        let verticalInset = (scrollView.bounds.height - zoomedHeight) / 2
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset,
                                               left: horizontalInset,
                                               bottom: verticalInset,
                                               right: horizontalInset)
        scrollView.layoutIfNeeded()
    }
}

extension SingleImageViewController {
    
    func setPhoto() {
        
        guard let placeholder = UIImage(named: "placeholderImageView") else { return }
        
        rescaleAndCenterImageInScrollView(image: placeholder )
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageUrl, placeholder: placeholder) { [weak self] result in
            
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так.", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Не надо", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        let secondAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.setPhoto()
        }
        alert.addAction(action)
        alert.addAction(secondAction)
        present(alert, animated: true)
    }
    
    @objc private func backPressed() {
        dismiss(animated: true)
    }
    
    @objc private func sharePressed() {
        
        let sharing = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
        
        self.present(sharing, animated: true, completion: nil)
    }
}

extension SingleImageViewController {
    
    private func setupBackButton() {
        layoutBackButton()
        backButton.addTarget(
            self, action: #selector(backPressed), for: .touchUpInside)
    }
    
    private func setupShareButton() {
        layoutShareButton()
        shareButton.addTarget(
            self, action: #selector(sharePressed), for: .touchUpInside)
    }
    
    
    private func setupScrollView() {
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        layoutScrollView()
    }
    
    private func layoutScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
    
    private func layoutImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(imageView)
        
        let scrollGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: scrollGuide.topAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: scrollGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: scrollGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(
                equalTo: scrollGuide.bottomAnchor)
        ])
    }
    
    private func layoutBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 9)
        ])
    }
    
    private func layoutShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(shareButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor),
            shareButton.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
}
