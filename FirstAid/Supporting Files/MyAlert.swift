//
//  MyAlert.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 23.11.2021.
//

import Foundation
import UIKit

/// Custom alert to  show the rules
class MyAlert {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var myTargetView: UIView?
    private weak var myVc: SceneViewController?
    
    func showAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targerView = viewController.view,
              let vc = viewController as? SceneViewController else {
                  return
              }
        
        myTargetView = targerView
        myVc = vc
        myVc?.hideButtons(true)
        myVc?.restartButton.isEnabled = false
        myVc?.sceneLabel.isHidden = true
        
        backgroundView.frame = targerView.bounds
        targerView.addSubview(backgroundView)
        
        targerView.addSubview(alertView)
        alertView.frame = CGRect(x: 40,
                                 y: -30,
                                 width: targerView.frame.size.width - 80,
                                 height: 250)
        
        let titleLabel = UILabel(frame: CGRect(x: 0,
                                               y: 0,
                                               width: alertView.frame.size.width,
                                               height: 80))
        titleLabel.text = title
        titleLabel.font = titleLabel.font.withSize(25)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 60,
                                                 width: alertView.frame.size.width,
                                                 height: 130))
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        alertView.addSubview(messageLabel)
        
        let button = UIButton(frame: CGRect(x: 0,
                                            y: alertView.frame.size.height - 50,
                                            width: alertView.frame.size.width,
                                            height: 50))
        
        button.setTitle("Начать", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self,
                         action: #selector(dismissAlert),
                         for: .touchUpInside)
        alertView.addSubview(button)
        
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.25) {
                    self.alertView.center = targerView.center
                }
            }
        }
        
    }
    
    @objc func dismissAlert() {
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.size.height,
                                          width: targetView.frame.size.width - 80,
                                          height: 300)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.25) {
                    self.backgroundView.alpha = 0
                } completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                }
            }
        }
        
        myVc?.setFirstScene()
        myVc?.hideButtons(false)
        myVc?.sceneLabel.isHidden = false
    }
    
}
