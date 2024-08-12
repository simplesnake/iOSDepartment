//
//  BaseViewController.swift
//  iOSDepartment
//
//  Created by Александр Строев on 26.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BaseViewInput, NavigationProtocol, LoaderProtocol, ToastProtocol, DialogProtocol{
    
    
    
    internal var loader: LoaderViewProtocol = ExampleLoader()
    
    var firstTime: Bool = true
    var keyboardSensitiveConstraints: KeyboardSensitiveConstraints!
    var keyboardService: KeyboardService = KeyboardService()
    
    
    var backBySwipe: Bool = false {
        didSet {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = backBySwipe;
        }
    }
    
    var dismissKeyboardOnTapAround: Bool = true {
        didSet{
            hideKeyboardWhenTappedAround(hide: dismissKeyboardOnTapAround)
        }
    }
    
    var appearance: Appearance = Appearance.sharedInstance
    var grayCover: UIView?
    var fakeCover: UIView?
    var fakeCoverTap: ((BaseViewController) -> ())?
    lazy var header: HeaderViewController = HeaderViewController()
    var pushAnimation: UIViewControllerAnimatedTransitioning?
    var popAnimation: UIViewControllerAnimatedTransitioning?
    let defaultNavigationBarHeight:CGFloat = 44
    var tapToDismissKeyboard: UITapGestureRecognizer!
    
    var toast: BaseToastView!

    override func viewDidLoad() {
        super.viewDidLoad()
        backBySwipe = false
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        view.backgroundColor = appearance.colors.light_gray
        setupDismissRecognizer()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
        keyboardSensitiveConstraints = KeyboardSensitiveConstraints(view: self.view)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        firstTime = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func setupNavigationBar(){
        view.insertSubview(header, at: 10000)
        header.height = defaultNavigationBarHeight
        header.titleLabel.textColor = appearance.colors.dark_main
        header.titleLabel.font = appearance.fonts.bigLabelFontExample
        header.backgroundColor = appearance.colors.light_gray
        header.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1) .cgColor
        header.layer.shadowRadius = 2
        header.layer.shadowOpacity = 1
        header.layer.shadowOffset = CGSize(width: 0,height: 2)
        header.title = "sadfsd"
    }
    
    func setupDismissRecognizer(){
        tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        dismissKeyboardOnTapAround = true
    }
    
    func removeToast(){
        if toast == nil {
            return
        }
        UIView.animate(withDuration: TimeInterval(integerLiteral: BaseToastView.Timings.exit),
            animations: {
                
                self.toast.alpha = 0
                self.toast.snp.remakeConstraints{ make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(self.header.snp.top)
                    make.height.equalTo(0)
                    
                }
                
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
            },
            completion: {
                _ in
                if self.toast == nil {
                    return
                }
                self.toast.removeFromSuperview()
                self.toast = nil
            })
    }
    
    func showGrayCover() {
        guard !self.view.isHidden && self.view.window != nil else {
            return
        }
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 1
        
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.view.frame.width, height: self.view.frame.height)
        let superView = self.view
        self.view.addSubview(view)
        
        view.alpha = 0.0
        superView?.layoutIfNeeded()
        superView?.layoutSubviews()
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: BaseToastView.Timings.enter) {
            view.alpha = 1
            superView?.layoutIfNeeded()
            superView?.layoutSubviews()
        }
        grayCover = view
    }
    
    func removeGrayCover() {
        UIView.animate(withDuration: TimeInterval(integerLiteral: 0.5), delay: 0,
        animations: {
            self.grayCover?.alpha = 0.0
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        },
        completion: {
            _ in
            self.grayCover?.removeFromSuperview()
        })
    }
    
    func showFakeCover(parent: UIView? = nil, onTap: ((BaseViewController) -> ())?) {
        guard !self.view.isHidden && self.view.window != nil else {
            return
        }
        
        let view = UIView()
        view.backgroundColor = .clear
        
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.view.frame.width, height: self.view.frame.height)
        let superView = self.view
        if let parent = parent {
            parent.addSubview(view)
        } else {
            self.view.addSubview(view)
        }
        
        superView?.layoutIfNeeded()
        superView?.layoutSubviews()
        view.layoutIfNeeded()
        
        fakeCover = view
        
        fakeCoverTap = onTap
        let gesture = UITapGestureRecognizer(target: self, action: #selector(fakeCoverTapHandler))
        fakeCover?.addGestureRecognizer(gesture)
    }
    
    func removeFakeCover() {
        fakeCover?.removeFromSuperview()
    }
    
    @objc func fakeCoverTapHandler() {
        fakeCoverTap?(self)
    }
    
    
    func appToBackground(){}
    func appFromBackground(){}
    
}


extension BaseViewController: UIGestureRecognizerDelegate {
    //Распознавание жестов для возврата на предыдущий экран свайпом
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension BaseViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return pushAnimation ?? .none
        case .pop:
            return popAnimation ?? .none
        default: return .none
        }
    }
}

extension BaseViewController {
    func hideKeyboardWhenTappedAround(hide: Bool = true) {
        if hide {
            tapToDismissKeyboard.cancelsTouchesInView = false
            view.addGestureRecognizer(tapToDismissKeyboard)
        } else {
            view.removeGestureRecognizer(tapToDismissKeyboard)
        }
    }
}
