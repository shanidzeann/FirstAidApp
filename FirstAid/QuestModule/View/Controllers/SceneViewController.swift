//
//  SceneViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 25.10.2021.
//

import UIKit
import SRCountdownTimer

class SceneViewController: UIViewController {
    
    // MARK: - Properties
    
    let rulesAlert = RulesAlert()
    
    @IBOutlet weak var countdownTimer: SRCountdownTimer!
    @IBOutlet weak var sceneLabel: UILabel!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var pauseButton: UIBarButtonItem!
    var restartButton: UIBarButtonItem!
    
    var viewModel: SceneViewModel?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        configureNavigationBar()
        configureTimer()
        showAlert()
        setUpBindings()
    }
    
    // MARK: - Quest start
    
    private func setFirstScene() {
        tabBarController?.tabBar.isHidden = true
        viewModel?.setFirstScene()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLabel()
        configureButton(topButton)
        configureButton(middleButton)
        configureButton(bottomButton)
    }
    
    // MARK: - Update UI
    
    private func updateUI() {
        sceneLabel.text = viewModel?.text
        guard let scene = viewModel?.scene else {
            return
        }
        
        guard viewModel?.choices?.count == 3 else {
            countdownTimer.pause()
            hideButtons(true)
            navigationItem.leftBarButtonItem?.isEnabled = true
            viewModel?.saveEnding(isFinished: true, isSuccess: scene.value?.isHappyEnd ?? false)
            UIView.animate(withDuration: Constants.Animation.sceneDuration) {
                self.sceneLabel.alpha = 1
            }
            return
        }
        
        topButton.setTitle(viewModel?.choiceText(0), for: .normal)
        middleButton.setTitle(viewModel?.choiceText(1), for: .normal)
        bottomButton.setTitle(viewModel?.choiceText(2), for: .normal)
        hideButtons(false)
        
        countdownTimer.start(beginingValue: Constants.Timer.beginingValue, interval: Constants.Timer.interval)
        UIView.animate(withDuration: Constants.Animation.sceneDuration) {
            self.showMainUI(true)
        }

    }
    
    private func showMainUI(_ bool: Bool) {
        sceneLabel.alpha = bool ? 1 : 0
        topButton.alpha = bool ? 1 : 0
        middleButton.alpha = bool ? 1 : 0
        bottomButton.alpha = bool ? 1 : 0
        countdownTimer.alpha = bool ? 1 : 0
    }
    
    private func showAlert() {
        rulesAlert.showAlert(on: self)
    }
    
    private func hideButtons(_ bool: Bool) {
        pauseButton.isEnabled = !bool
        restartButton.isEnabled = bool
        navigationItem.leftBarButtonItem?.isEnabled = !bool
    }
    
    private func configureLabel() {
        sceneLabel.adjustsFontSizeToFitWidth = true
        sceneLabel.minimumScaleFactor = 0.5
        sceneLabel.backgroundColor = .systemBackground
        sceneLabel.layer.shadowPath = UIBezierPath(rect: sceneLabel.bounds).cgPath
        sceneLabel.layer.shadowColor = UIColor.systemRed.cgColor
        sceneLabel.layer.shadowOpacity = 1
        sceneLabel.layer.shadowRadius = 5
        sceneLabel.layer.shadowOffset = .zero
    }
    
    private func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.titleLabel?.textAlignment = .center
    }
    
    private func configureNavigationBar() {
        pauseButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.Images.BarButtonItems.pause),
            style: .plain,
            target: self,
            action: #selector(didTapPause))
        restartButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.Images.BarButtonItems.restart),
            style: .plain,
            target: self,
            action: #selector(didTapRestart))
        
        navigationItem.rightBarButtonItems = [restartButton, pauseButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.Images.BarButtonItems.back),
            style: .plain,
            target: self,
            action: #selector(didTapCancel))
    }
    
    private func configureTimer() {
        countdownTimer.delegate = self
        countdownTimer.lineColor = .red
        countdownTimer.timerFinishingText = "End"
        countdownTimer.lineWidth = 4
    }
    
    func prepareToShowAlert() {
        hideButtons(true)
        showMainUI(false)
        restartButton.isEnabled = false
    }
    
    func start() {
        setFirstScene()
    }
    
    // MARK: - User actions
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: Constants.Animation.sceneDuration) {
            self.showMainUI(false)
        } completion: { done in
            if done {
                self.viewModel?.setNextScene(sender.tag)
            }
        }
    }
    
    @objc private func didTapPause() {
        countdownTimer.pause()
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let vc = UIAlertController(
            title: "Квест приостановлен",
            message: "Продолжить квест?\nЕсли Вы покинете игру, прогресс будет потерян",
            preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { [weak self] _ in
            self?.countdownTimer.resume()
            self?.hideButtons(false)
            UIView.animate(withDuration: Constants.Animation.sceneDuration) {
                self?.showMainUI(true)
            }
        }))
        
        vc.addAction(UIAlertAction(title: "Начать заново", style: .destructive, handler: { [weak self] _ in
            self?.didTapRestart()
        }))
        
        vc.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { [weak self] _ in
            self?.exit()
        }))
        
        hideButtons(true)
        UIView.animate(withDuration: Constants.Animation.sceneDuration) {
            self.showMainUI(false)
        } completion: { done in
            self.present(vc, animated: true)
        }
    }
    
    @objc private func didTapRestart() {
        viewModel?.saveEnding(isFinished: false, isSuccess: false)
        UIView.animate(withDuration: Constants.Animation.sceneDuration) {
            self.showMainUI(false)
        } completion: { done in
            if done {
                self.setFirstScene()
            }
        }
    }
    
    @objc private func didTapCancel() {
        if viewModel!.questIsFinished() {
            exit()
        } else {
            didTapPause()
        }
    }
    
    private func exit() {
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Hepler Methods
    
    private func setUpBindings() {
        viewModel?.scene.bind({ [weak self] _ in
            self?.updateUI()
        })
    }
    
}


// MARK: - Timer delegate

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
