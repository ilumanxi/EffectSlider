//
//  EffectSlider.swift
//  EffectSlider
//
//  Created by 风起兮 on 2022/3/21.
//

import UIKit

/**

let value: Float = -1
let minimumValue: Float = -50
let maximumValue: Float = 50
let percentage =  (value - minimumValue) / (maximumValue - minimumValue)
let newValue = (maximumValue - minimumValue) * percentage - maximumValue
*/

open class EffectSlider: UIControl {
    
    fileprivate var value: Float = 0 // default 0.0. this value will be pinned to min/max
    
    open var percentage: Float = 0 // default 0.0. this value will be pinned to (value - minimumValue) / (maximumValue - minimumValue)

    open var minimumValue: Float = 0 // default 0.0. the current value may change if outside new min value

    open var maximumValue: Float = 1.0 // default 1.0. the current value may change if outside new max value
    
    private let trackSize: CGFloat = 4
    private lazy var minimumTrackImageView: UIImageView = {
        let size = CGSize(width: trackSize, height: trackSize)
        let colors = [
            UIColor(red: 0.53, green: 0.53, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.74, green: 0.55, blue: 1, alpha: 1).cgColor]
        let image = EffectSlider.gradientImage(size: size, colors: colors)
        let view = UIImageView(image: image)
        view.layer.cornerRadius = min(size.width, size.width) / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var maximumTrackImageView: UIImageView = {
        let size = CGSize(width: trackSize, height: trackSize)
        let colors = [
            UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).cgColor,
            UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).cgColor]
        let image = EffectSlider.gradientImage(size: size, colors: colors)
        let view = UIImageView(image: image)
        view.layer.cornerRadius = min(size.width, size.width) / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    

    let thumbImageSize = CGSize(width: 16, height: 16)
    private lazy var thumbImageView: UIImageView = {
        let size = thumbImageSize
        let colors = [
            UIColor(red: 0.53, green: 0.53, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.74, green: 0.55, blue: 1, alpha: 1).cgColor]
        let image = EffectSlider.gradientImage(size: size, colors: colors)
        let view = UIImageView(image: image)
        view.layer.cornerRadius = min(size.width, size.width) / 2.0
        view.layer.masksToBounds = true
        return view
    }()
    
    
    private static func gradientImage(size: CGSize, colors: [CGColor]) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: size)
        gradient.colors = colors
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    // MARK - 手势
    func updateValueWithTouches(_ touches: Set<UITouch>, event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        let itemWidth = thumbImageView.bounds.width
        let itemCenter = itemWidth / 2
        let move = max(itemCenter, min(position.x, bounds.width - itemCenter)) - itemCenter
        let newPercentage =  Float(move / (bounds.width - itemWidth))
        percentage = newPercentage
        setNeedsLayout()
        sendActions(for: .valueChanged)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateValueWithTouches(touches, event: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateValueWithTouches(touches, event: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // There's no need to handle `touchesCancelled(_:withEvent:)` for this control.
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // There's no need to handle `touchesCancelled(_:withEvent:)` for this control.
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    open override var isAccessibilityElement: Bool {
        set { /* ignore value */ }
        
        get { return false }
    }
    
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 31)
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        self.addSubview(maximumTrackImageView)
        self.addSubview(minimumTrackImageView)
        self.addSubview(thumbImageView)
       
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let value = CGFloat(self.percentage)
        let itemWidth = thumbImageView.bounds.width
        let itemCenter = itemWidth / 2
        let width = bounds.width
        let move = max(itemCenter, min(width * value, bounds.width - itemCenter)) - itemCenter
        
        let minimumTrackValue = bounds.width * value
        let maximumTrackValue = bounds.width - minimumTrackValue
        
        thumbImageView.frame = CGRect(x: move, y: (bounds.height - thumbImageSize.height) / 2, width: thumbImageSize.width, height: thumbImageSize.height)
        minimumTrackImageView.frame = CGRect(x: 0, y: (bounds.height - trackSize) / 2 , width: minimumTrackValue, height: trackSize)
        maximumTrackImageView.frame = CGRect(x: minimumTrackValue, y: (bounds.height - trackSize) / 2 , width: maximumTrackValue, height: trackSize)

    }
}

extension CGRect {
    
    var center: CGPoint {
            get {
                let centerX = origin.x + (size.width / 2)
                let centerY = origin.y + (size.height / 2)
                return CGPoint(x: centerX, y: centerY)
            }
            set(newCenter) {
                origin.x = newCenter.x - (size.width / 2)
                origin.y = newCenter.y - (size.height / 2)
            }
        }
}
