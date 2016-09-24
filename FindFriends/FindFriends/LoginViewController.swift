//
//  LoginViewController.swift
//  DejaFashion
//
//  Created by DanyChen on 3/3/16.
//  Copyright © 2016 Mozat. All rights reserved.
//

import UIKit

private var lastSendOtpTime : UInt64 = 0
private let countDownSeconds  :UInt64 = 60
private var lastMobileNumber : String? = nil

class LoginViewController : BasicViewController{
    var countryCode = ""
    let phoneNumTextField = UITextField()
    let otpTextField = UITextField()
    let countryCodeLabel = UILabel()
    var sessionId : String?
    let sendOtpButton = UIButton()
    let tipLabel = UILabel()
    let loginButton = DJButton()
    let scrollView = UIScrollView()
    
    var countingTimer : NSTimer?
    var counting : Int = Int(countDownSeconds)
    
    let keyboardMonitor = KeyboardMonitor()
    var tipContent = ""
    var legalLength = (0, 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addTapGestureTarget(self, action: #selector(LoginViewController.hideKeyboard))
        
        scrollView.frame = view.bounds
        guard let image = UIImage(named: "LoginPageHeaderLogo") else {
            return
        }
        
        let logoImageView = UIImageView(image: image)
        var oy : CGFloat = 70
        
        if view.frame.size.width < 375 {
            oy = 15
        }
        
        logoImageView.frame = CGRect(x: view.frame.width / 2 - image.size.width / 2, y: oy, width: image.size.width, height: image.size.height)
        
        var oyInput : CGFloat = 47
        if view.frame.size.width < 375 {
            oyInput = 35
        }
        let inputAreaView = UIView(frame: CGRect(x: 50, y: logoImageView.frame.maxY + oyInput, width: view.frame.width - 100, height: 88 + 44))
        
        countryCodeLabel.frame = CGRect(x: 0, y: 0, width: 41, height: 44)
        if let cCode = ConfigDataContainer.sharedInstance.getCurrentCountryCallingCode(){
            countryCode = cCode
        }else{
            countryCode = "65"
        }
        legalLength = ConfigDataContainer.sharedInstance.getLengthOfPhoneNumByCountryCode(countryCode)
        let full = "+\(countryCode)"
        
        countryCodeLabel.text = full
        countryCodeLabel.textColor = UIColor.defaultBlack()
        countryCodeLabel.font = UIFont.regularFont(16)
        countryCodeLabel.addTapGestureTarget(self, action: #selector(LoginViewController.codeTextViewDidTapped))
        
        phoneNumTextField.frame = CGRect(x: countryCodeLabel.frame.maxX, y: 0, width: inputAreaView.frame.width - 60, height: 44)
        phoneNumTextField.placeholder = "Phone Number"
        phoneNumTextField.textColor = UIColor.defaultBlack()
        phoneNumTextField.font = UIFont.regularFont(16)
        phoneNumTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        phoneNumTextField.keyboardType = .PhonePad
        phoneNumTextField.text = lastMobileNumber
        addInputAccessoryViewToTextField(phoneNumTextField)
        
        let lineView1 = UIView(frame: CGRectMake(0, 43.5, inputAreaView.frame.size.width, 0.5))
        lineView1.backgroundColor = UIColor(fromHexString: "cecece")
        inputAreaView.addSubview(lineView1)
        
        otpTextField.frame = CGRect(x: 0, y: countryCodeLabel.frame.maxY, width: inputAreaView.frame.width - 80, height: 44)
        otpTextField.textColor = UIColor.defaultBlack()
        otpTextField.font = UIFont.regularFont(16)
        otpTextField.placeholder = "OTP"
        otpTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        otpTextField.keyboardType = .PhonePad
        addInputAccessoryViewToTextField(otpTextField)
        
        sendOtpButton.frame = CGRect(x: inputAreaView.frame.width - 100, y: otpTextField.frame.origin.y, width: 100, height: 44)
        sendOtpButton.contentHorizontalAlignment = .Right
        sendOtpButton.withFontHeletica(15).withTitle("Send OTP")
        sendOtpButton.addTarget(self, action: #selector(LoginViewController.sendOTP), forControlEvents: .TouchUpInside)
        setSendOTPButtonEnabled(false)
        
        let lineView2 = UIView(frame: CGRectMake(0, 87.5, inputAreaView.frame.size.width, 0.5))
        lineView2.backgroundColor = UIColor(fromHexString: "cecece")
        inputAreaView.addSubview(lineView2)
        
        tipLabel.frame = CGRect(x: 0, y: otpTextField.frame.maxY, width: view.frame.width - 100, height: 60)
        resetTipLabel()
        tipLabel.numberOfLines = 2
        inputAreaView.addSubviews(countryCodeLabel, phoneNumTextField, otpTextField, sendOtpButton, tipLabel)
        
        loginButton.frame =  CGRect(x: 50, y: inputAreaView.frame.maxY + 15, width: view.frame.width - 100, height: 40)
        
        let fbIconView = UIImageView(image: UIImage(named: "LoginFBIcon"))
        fbIconView.frame = CGRect(x: view.frame.width / 2 - 70, y: scrollView.frame.height - 110 + 2 - 15, width: 11, height: 11)
        scrollView.addSubview(fbIconView)
        
        loginButton.addTarget(self, action: #selector(login), forControlEvents: .TouchUpInside)
        
        
        loginButton.withTitle(("LOG IN"))
        loginButton.blackTitleWhiteStyle()
        setLoginButtonEnabled(false)
        
        scrollView.addSubviews(logoImageView,inputAreaView,loginButton)
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize = scrollView.frame.size
        view.addSubview(scrollView)
    }
    
    
    
    func addInputAccessoryViewToTextField(textField : UITextField) {
        let space1 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let space2 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target:textField, action: #selector(UIResponder.resignFirstResponder))
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.width, 44))
        toolbar.items = [space1, space2, barButton]
        textField.keyboardAppearance = .Dark
        textField.inputAccessoryView = toolbar;
    }
    
    func sendOTP(){
        tipContent = ("We'll send an OTP to login. You can resend it after 60 seconds.")
        resetTipLabel()
        
        //        let smsNT = SMSCodeNetTask()
        //        if let text = phoneNumTextField.text {
        //            lastSendOtpTime = NSDate.currentTimeMillis()
        //            let pStr = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        //            smsNT.photoNumber = "\(countryCode)\(pStr)"
        //            MONetTaskQueue.instance().addTaskDelegate(self, uri: smsNT.uri())
        //            MONetTaskQueue.instance().addTask(smsNT)
        //
        //            counting = Int(countDownSeconds)
        //            sendOtpButton.withTitleColor(UIColor(fromHexString: "cecece"))
        //            sendOtpButton.withTitle("\(counting)s")
        //            countingTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LoginViewController.updateCounting), userInfo: nil, repeats: true)
        //            setSendOTPButtonEnabled(false)
        //        }
    }
    
    func login(){
        presentViewController(ProfileEditViewController(), animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardMonitor.start()
        keyboardMonitor.delegate = self
        if self.navigationController != nil {
            self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
            self.navigationController!.navigationBar.barStyle = .Default
            //  self.backButton.setImage(UIImage(named: "BackIconNormal"), forState: .Normal)
        }
        
        setTimerIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardMonitor.end()
        
        if self.navigationController != nil {
            self.navigationController!.navigationBar.barTintColor = UIColor.defaultBlack()
            self.navigationController!.navigationBar.barStyle = .Black
            // self.backButton.setImage(UIImage(named: "WhiteBackIconNormal"), forState: .Normal)
        }
        
        countingTimer?.invalidate()
        countingTimer = nil
        lastMobileNumber = phoneNumTextField.text
        
    }
}

extension LoginViewController : KeyboardMonitorDelegate, ScollSelectorViewDelegate{
    func setSendOTPButtonEnabled(enable : Bool){
        if enable {
            sendOtpButton.withTitleColor(UIColor.defaultBlack())
        }else{
            sendOtpButton.withTitleColor(UIColor(fromHexString: "cecece"))
        }
        sendOtpButton.enabled = enable
    }
    
    func setLoginButtonEnabled(enable : Bool){
        if enable {
            loginButton.layer.borderColor = UIColor.defaultBlack().CGColor
            loginButton.withTitleColor(UIColor.defaultBlack())
            
        }else{
            loginButton.layer.borderColor = UIColor(fromHexString: "cecece").CGColor
            loginButton.withTitleColor(UIColor(fromHexString: "cecece"))
        }
        loginButton.enabled = enable
    }
    
    func setTimerIfNeeded() {
        let currentMills = NSDate.currentTimeMillis()
        let interval = currentMills - lastSendOtpTime
        if  interval < countDownSeconds * 1000{
            let seconds = countDownSeconds - interval / 1000
            if seconds > 0 {
                counting = Int(seconds)
                sendOtpButton.withTitle("\(counting)s")
                countingTimer?.invalidate()
                countingTimer = nil
                countingTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LoginViewController.updateCounting), userInfo: nil, repeats: true)
                setSendOTPButtonEnabled(false)
            }
        }else {
            sendOtpButton.withTitle("Send OTP")
            checkPhoneNumberLength()
        }
    }
    
    func updateCounting(){
        counting -= 1
        
        if counting < 0 {
            resetSendOtpButton()
        }else{
            sendOtpButton.withTitle("\(counting)s")
        }
    }
    
    func resetSendOtpButton(){
        sendOtpButton.withTitle("Resend")
        setSendOTPButtonEnabled(true)
        countingTimer?.invalidate()
        countingTimer = nil
    }
    
    func resetTipLabel(){
        tipLabel.text = tipContent
        tipLabel.withTextColor(DJCommonStyle.ColorCE).withFontHeletica(14)
    }
    
    func tipLabelWarning(text : String){
        tipLabel.withText(text)
        tipLabel.withTextColor(UIColor.defaultRed())
    }
    
    func checkPhoneNumberLength(){
        var inputLength = 0
        if phoneNumTextField.text != nil {
            inputLength = (phoneNumTextField.text?.characters.count)!
        }
        let (small, big) = legalLength
        if inputLength > big || inputLength < small{
            setSendOTPButtonEnabled(false)
        }else{
            setSendOTPButtonEnabled(true)
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField == otpTextField{
            resetTipLabel()
        }else if textField == phoneNumTextField {
            var inputLength = 0
            if phoneNumTextField.text != nil {
                inputLength = (phoneNumTextField.text?.characters.count)!
            }
            let (_, big) = legalLength
            if inputLength > big{
                tipLabelWarning("Incorrect Phone number length\n")
            }else{
                resetTipLabel()
            }
            checkPhoneNumberLength()
        }
        
        var otpinputLength = 0
        if otpTextField.text != nil {2
            otpinputLength = (otpTextField.text?.characters.count)!
        }
        var phoneinputLength = 0
        if phoneNumTextField.text != nil {
            phoneinputLength = (phoneNumTextField.text?.characters.count)!
        }
        let (small, big) = legalLength
        if otpinputLength != 0 && (phoneinputLength >= small && phoneinputLength <= big){
            setLoginButtonEnabled(true)
        }else{
            setLoginButtonEnabled(false)
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(keyboardHeight : CGFloat, animationDuration : CGFloat) {
        let offset = keyboardHeight - (view.frame.height - loginButton.frame.maxY) + 10 - 44
        
        var more : CGFloat = 0
        if view.frame.size.width == 375 {
            more = 125
        }else if view.frame.size.width > 375 {
            more = 183
        }
        
        UIView.animateWithDuration(Double(animationDuration)) { () -> Void in
            self.scrollView.contentOffset = CGPoint(x: 0, y: offset + more)
        }
    }
    
    func keyboardWillHide(keyboardHeight : CGFloat, animationDuration : CGFloat) {
        UIView.animateWithDuration(Double(animationDuration)) { () -> Void in
            self.scrollView.contentOffset = CGPointZero
        }
    }
    
    func scollSelectorViewDidDone(scollSelectorView: ScollSelectorView, value: String) {
        countryCode = value
        countryCodeLabel.text = "+\(value)"
        legalLength = ConfigDataContainer.sharedInstance.getLengthOfPhoneNumByCountryCode(countryCode)
    }
    
    func codeTextViewDidTapped(){
        let picker = ScollSelectorView(frame : CGRectMake(0, view.frame.size.height, view.frame.size.width, 258))
        picker.delegate = self
        picker.setSelectedCountryCode(countryCode)
        view.addSubview(picker)
        UIView.animateWithDuration(0.3, animations: {
            picker.frame = CGRectMake(0, self.view.frame.size.height - 258, self.view.frame.size.width, 258)
        })
    }
}


