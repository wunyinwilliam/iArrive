//
//  B1-1_PhotoDetectedViewController.swift
//  iArrive
//
//  Created by Will Lam on 4/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B1_1_PhotoDetectedViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet weak var upperLayerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var detectedNameLabel: UILabel!
    @IBOutlet weak var detectedJobTitleLabel: UILabel!
    @IBOutlet weak var checkInOutButton: UIButton!
    @IBOutlet weak var notMeButton: UIButton!
    
    
    // MARK: Local Variables
    let checkInColor = publicFunctions().hexStringToUIColor(hex: "#3BBF00")
    let checkOutColor = publicFunctions().hexStringToUIColor(hex: "#FF2C55")
    var currentColor: UIColor?
    var currentStatus: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Sample Staff for debugging (Delete after deployment)
//        if isLoadSampleStaff {
//            publicFunctions().loadSampleStaff()
//        }
        
        // Load Sample Detected Staff Member Infomation for debugging (Delete after deployment)
        if isLoadSampleDetectedData {
            loadSampleDetectedData()
        }
        
        // Determine the current detected staff need to check in or check out
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                currentColor = checkOutColor
                currentStatus = "Check Out"
            } else {
                currentColor = checkInColor
                currentStatus = "Check In"
            }
        } else {
            print("ERROR: There is no detected staff in the staffNameList.")
        }
        
        // Set up Background Image with Blur Effect
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = currentCheckingInOutPhoto
        imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        imageView.center = view.center
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set up Upper Layer View (with different colors for check in / out)
        upperLayerView.layer.borderWidth = 1
        upperLayerView.layer.borderColor = currentColor?.cgColor
        upperLayerView.layer.cornerRadius = 20
        upperLayerView.clipsToBounds = true
        
        // Set up Icon Image Vice (with circle border)
        iconImageView.image = UIImage(named: "Search") // To Be changed
        iconImageView.layer.borderWidth = 1.0
        iconImageView.layer.masksToBounds = false
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.clipsToBounds = true
        
        // Set up Detected Name and Detected Job Title Labels
        detectedNameLabel.text = currentCheckingInOutFirstName! + " " + currentCheckingInOutLastName!
        detectedJobTitleLabel.text = currentCheckingInOutJobTitle
        
        // Set up Check In / Out Button (with different labels, background colors, current time for check in / out)
        var labelText = """
        checkInOrOut
        currentTime
        """
        labelText = labelText.replacingOccurrences(of: "checkInOrOut", with: currentStatus!)
        labelText = labelText.replacingOccurrences(of: "currentTime", with: currentCheckingInOutTime!)
        let nameStringAttribute = [NSAttributedString.Key.font : UIFont(name: "NotoSans-Bold", size: 24)!, .foregroundColor : UIColor.white, ]
        let string = NSMutableAttributedString(string: labelText, attributes: nameStringAttribute)
        let textRange = string.mutableString.range(of: currentCheckingInOutTime!)
        string.addAttributes([.font: UIFont(name: "Montserrat-Medium", size: 56)!, .foregroundColor : UIColor.white], range: textRange)
        checkInOutButton.backgroundColor = currentColor
        checkInOutButton.titleLabel?.numberOfLines = 0
        checkInOutButton.titleLabel?.textAlignment = .center
        checkInOutButton.setAttributedTitle(string, for: .normal)
        
        // Set up Not Me Button
        notMeButton.layer.cornerRadius = 28
        
        // Rearrange the order of Different layers
        self.view.insertSubview(imageView, at: 0)
        self.view.insertSubview(blurEffectView, at: 1)
        self.view.insertSubview(upperLayerView, at: 2)
        upperLayerView.insertSubview(iconImageView, at: 3)
    }
    
    
    
    // MARK: Private Methods
    
    // Load Sample Detected Staff Member Infomation for debugging (Delete after deployment)
    private func loadSampleDetectedData() {
        currentCheckingInOutFirstName = "Samuel"
        currentCheckingInOutLastName = "Lee"
        currentCheckingInOutJobTitle = "Web Designer"
        if currentCheckingInOutTime == nil {
            currentCheckingInOutTime = "15:00"
        }
    }
    
    
    
    // MARK: Navigation
    
    // Back to Sign In Page when user presses Check In / Out Button with Check In / Out status updated
    @IBAction func pressedCheckInOutButton(_ sender: UIButton) {
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                staffNameList[index].isCheckedIn = false
                print(currentCheckingInOutFirstName ?? "", "Check out successfully")
            } else {
                staffNameList[index].isCheckedIn = true
                print(currentCheckingInOutFirstName ?? "", "Check in successfully")
            }
        } else {
            print("ERROR: There is no selected staff in the staffNameList.")
        }
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Back to Camera View when user presses Try Again Button
    @IBAction func pressedTryAgainButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}
