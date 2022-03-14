//
//  MyAlert.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 23.11.2021.
//

import Foundation
import UIKit
import SnapKit

/// Custom alert to  show the rules
class RulesAlert {
    
    // MARK: - Properties
    
    private var myTargetView: UIView?
    private weak var myVc: SceneViewController?
    
    // MARK: - UI
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .systemBackground
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        alert.layer.borderWidth = 1
        alert.layer.borderColor = UIColor.label.cgColor
        return alert
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Начать", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    // MARK: - Show alert method
    
    func showAlert(with title: String, message: String, on viewController: UIViewController) {
        
        guard let targetView = viewController.view,
              let vc = viewController as? SceneViewController else {
                  return
              }
        
        myTargetView = targetView
        myVc = vc
        myVc?.prepareToShowAlert()
        
        createAlert(with: title, message: message, on: targetView)
        
        UIView.animate(withDuration: Constants.Animation.alertDuration) {
            self.backgroundView.alpha = 0.6
        } completion: { done in
            if done {
                UIView.animate(withDuration: Constants.Animation.alertDuration) {
                    self.alertView.center = targetView.center
                }
            }
        }
    }
    
    // MARK: - Dismiss alert
    
    @objc func dismissAlert() {
        guard let targetView = myTargetView else {
            return
        }
        
        let alertViewWidth = targetView.frame.size.width - Constants.RulesAlert.widthSpace
        UIView.animate(withDuration: Constants.Animation.alertDuration) {
            self.alertView.frame = CGRect(x: targetView.center.x - alertViewWidth/2,
                                          y: targetView.frame.size.height,
                                          width: alertViewWidth,
                                          height: Constants.RulesAlert.height)
        } completion: { done in
            if done {
                UIView.animate(withDuration: Constants.Animation.alertDuration) {
                    self.backgroundView.alpha = 0
                } completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                }
            }
        }
        
        myVc?.start()
    }
    
    // MARK: - Create alert
    
    func createAlert(with title: String, message: String, on targetView: UIView) {
        backgroundView.frame = targetView.bounds
        
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        
        let alertViewWidth = targetView.frame.size.width - Constants.RulesAlert.widthSpace
        
        self.alertView.frame = CGRect(x: targetView.center.x - alertViewWidth/2,
                                      y: -Constants.RulesAlert.height,
                                      width: alertViewWidth,
                                      height: Constants.RulesAlert.height)
        
        alertView.addSubview(titleLabel)
        titleLabel.text = title
        
        titleLabel.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(Constants.RulesAlert.titleHeight)
        }
        
        alertView.addSubview(messageLabel)
        messageLabel.text = message
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(Constants.RulesAlert.spacing)
            make.height.equalTo(Constants.RulesAlert.messageHeight)
            make.width.equalToSuperview()
        }
        
        alertView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).inset(Constants.RulesAlert.spacing)
            make.bottom.width.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
    
}
