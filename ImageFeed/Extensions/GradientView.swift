//
//  GradientView.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 11.03.2024.
//

import UIKit

final class GradientView: UIView {
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradient()
        }
    }
    
    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradient()
        }
    }
    
    let gradient = CAGradientLayer()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    private func addGradient() {
        self.layer.addSublayer(gradient)
    }
    
    
    private func setupGradient() {
        guard let startColor, let endColor else { return }
        gradient.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    
}
