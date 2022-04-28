//
//  SceneViewController+SRCountdownTimerDelegate.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit
import SRCountdownTimer

extension SceneViewController: SRCountdownTimerDelegate {
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        UIView.animate(withDuration: Constants.Animation.sceneDuration) {
            self.showMainUI(false)
        } completion: { done in
            if done {
                self.viewModel?.setLastScene()
            }
        }
    }
}
