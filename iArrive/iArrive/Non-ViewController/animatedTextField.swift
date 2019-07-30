//
//  animatedTextField.swift
//  iArrive
//
//  Created by Will Lam on 25/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

@IBDesignable
class animatedTextField: UIView {

    // MARK: Local Variables
    let animationDuration = 0.3
    let bordersWidth: CGFloat = 1.0
    var mainTextField = UITextField()
    var placeholderLabel = UILabel()
    let magnifiedPlaceholderLabel = UILabel()
    let minifiedPlaceholderLabel = UILabel()
    let underlineView = UIView()
    let upperlineView = UIView()
    let leftlineView = UIView()
    let rightlineView = UIView()
    var borderStatus = 0                // 0 for underline, 1 for whole borders
    var placeholderLabelStatus = 0      // 0 for minified, 1 for magnified
    
    // MARK: Properties
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
            if text == nil {
                mainTextField.text = ""
                text = ""
            }
            setup()
        }
    }
    
    var text: String? {
        didSet {
            if text != "" {
                mainTextField.text = text
                text = ""
            }
            setup()
        }
    }
    
    // MARK: Initialization
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    
    // MARK: private Methods

    private func setup() {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 4.0
        for borderSubview in [underlineView, upperlineView, leftlineView, rightlineView] {
            borderSubview.backgroundColor = .white
        }
        
        mainTextField.frame = CGRect(x: 15.0, y: 20.0, width: frame.width-30.0, height: frame.height-20.0)
        mainTextField.textColor = .white
        mainTextField.font = UIFont(name: "NotoSans-SemiBold", size: 20.0)
        
        placeholderLabel.textColor = .white
        
        if mainTextField.text == "" {
            setupMagnifiedPlaceholder()
            setupFullBorders()
        } else {
            setupMinifiedPlaceholder()
            setupUnderlineBorder()
        }
    
        for subview in [mainTextField, placeholderLabel, underlineView, upperlineView, leftlineView, rightlineView] {
            self.addSubview(subview)
            self.bringSubviewToFront(subview)
        }
        
        // Associate textfield objects with action methods
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        mainTextField.addTarget(self, action: #selector(textFieldTap), for: .touchDown)
        mainTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainTextField.addTarget(self, action: #selector(textFieldCancel), for: .editingDidEnd)
    }

    
    private func updateTextFieldStatus() {
        if mainTextField.isFirstResponder && borderStatus == 0 {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
                self.setupHalfBorders()
            }, completion: { finished in
                self.borderStatus = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.setupFullBorders()
            })
        } else if mainTextField.text != "" && !mainTextField.isFirstResponder && borderStatus == 1 {
            setupHalfBorders()
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.backgroundColor = .clear
                self.setupUnderlineBorder()
            }, completion: { finish in
                self.borderStatus = 0
            })
        }
        
        if mainTextField.text == "" && !mainTextField.isFirstResponder {
            print("NO")
            if placeholderLabelStatus == 0 {
                magnifyingPlaceholder()
            }
        } else {
            print("Yes")
            if placeholderLabelStatus == 1 {
                minifyingPlaceholder()
            }
        }
    }
    
    
    private func magnifyingPlaceholder() {
        print("magnifying")
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.placeholderLabel.transform = self.scaleTransform(from: self.minifiedPlaceholderLabel.frame.size, to: self.magnifiedPlaceholderLabel.frame.size).concatenating(self.translateTransform(from: self.minifiedPlaceholderLabel.center, to: self.magnifiedPlaceholderLabel.center))
            self.backgroundColor = .clear
            self.layer.opacity = 0.5
        }, completion: { finished in
            self.placeholderLabelStatus = 1
        })
    }
    
    private func minifyingPlaceholder() {
        print("minifying")
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.placeholderLabel.transform = self.scaleTransform(from: self.magnifiedPlaceholderLabel.frame.size, to: self.minifiedPlaceholderLabel.frame.size).concatenating(self.translateTransform(from: self.magnifiedPlaceholderLabel.center, to: self.minifiedPlaceholderLabel.center))
            self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
            self.layer.opacity = 1.0
        }, completion: { finished in
            self.placeholderLabelStatus = 0
        })
    }
    
    private func setupMagnifiedPlaceholder() {
        layer.opacity = 0.5
        magnifiedPlaceholderLabel.text = placeholderText
        magnifiedPlaceholderLabel.font = UIFont(name: "NotoSans-Regular", size: 24.0)
        magnifiedPlaceholderLabel.frame = CGRect(x: 15.0, y: 20.0, width: magnifiedPlaceholderLabel.intrinsicContentSize.width, height: magnifiedPlaceholderLabel.intrinsicContentSize.height)
        placeholderLabel.font = magnifiedPlaceholderLabel.font
        placeholderLabel.frame = magnifiedPlaceholderLabel.frame
        placeholderLabelStatus = 1
    }
    
    private func setupMinifiedPlaceholder() {
        layer.opacity = 1.0
        minifiedPlaceholderLabel.text = placeholderText
        minifiedPlaceholderLabel.font = UIFont(name: "NotoSans-Bold", size: 12.0)
        minifiedPlaceholderLabel.frame = CGRect(x: 15.0, y: 10.0, width: minifiedPlaceholderLabel.intrinsicContentSize.width, height: minifiedPlaceholderLabel.intrinsicContentSize.height)
        placeholderLabel.font = minifiedPlaceholderLabel.font
        placeholderLabel.frame = minifiedPlaceholderLabel.frame
        placeholderLabelStatus = 0
    }
    
    private func setupFullBorders() {
        layer.borderWidth = bordersWidth
        underlineView.frame = CGRect(x: bordersWidth*2, y: self.frame.height-bordersWidth, width: self.frame.width-bordersWidth*4, height: bordersWidth)
        upperlineView.frame = CGRect(x: bordersWidth*2, y: 0, width: self.frame.width-bordersWidth*4, height: bordersWidth)
        leftlineView.frame = CGRect(x: 0, y: bordersWidth*2, width: bordersWidth, height: self.frame.height-bordersWidth*4)
        rightlineView.frame = CGRect(x: self.frame.width-bordersWidth, y: bordersWidth*2, width: bordersWidth, height: self.frame.height-bordersWidth*4)
        borderStatus = 1
    }
    
    private func setupHalfBorders() {
        underlineView.frame = CGRect(x: 0.0, y: self.frame.height-bordersWidth, width: self.frame.width, height: bordersWidth)
        upperlineView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: bordersWidth)
        leftlineView.frame = CGRect(x: 0.0, y: 0.0, width: bordersWidth, height: self.frame.height)
        rightlineView.frame = CGRect(x: self.frame.width-bordersWidth, y: 0.0, width: bordersWidth, height: self.frame.height)
    }
    
    private func setupUnderlineBorder() {
        layer.borderWidth = 0.0
        underlineView.frame = CGRect(x: 0.0, y: self.frame.height-bordersWidth*1.5, width: self.frame.width, height: bordersWidth*1.5)
        upperlineView.frame = underlineView.frame
        leftlineView.frame = CGRect(x: 0.0, y: self.frame.height-self.bordersWidth, width: self.bordersWidth, height: self.bordersWidth)
        rightlineView.frame = CGRect(x: self.frame.width-self.bordersWidth, y: self.frame.height-self.bordersWidth, width: self.bordersWidth, height: self.bordersWidth)
        borderStatus = 0
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        if scaleX > 1.0 {
            return CGAffineTransform(scaleX: scaleX, y: scaleY)
        } else {
            return CGAffineTransform(scaleX: scaleX*2.0, y: scaleY*2.0)
        }
    }
    
    private func translateTransform(from: CGPoint, to: CGPoint) -> CGAffineTransform {
        let translateX = to.x - from.x
        let translateY = to.y - from.y
        if translateY > 1.0 {
            return CGAffineTransform(translationX: translateX, y: translateY)
        } else {
            return CGAffineTransform(translationX: translateX*0.25, y: translateY*0.25)
        }
    }
    
    
    
    // MARK: Action Methods for Text Field
    
    @objc func tapped() {
        mainTextField.becomeFirstResponder()
        updateTextFieldStatus()
    }
    
    @objc func textFieldTap(_ textField: UITextField) {
        mainTextField.becomeFirstResponder()
        updateTextFieldStatus()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateTextFieldStatus()
    }
    
    @objc func textFieldCancel(_ textField: UITextField) {
        updateTextFieldStatus()
    }
}
