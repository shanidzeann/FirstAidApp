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
    
    let myAlert = MyAlert()
    
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
        
        configureNavigationBar()
        configureLabel()
        configureButton(topButton)
        configureButton(middleButton)
        configureButton(bottomButton)
        configureTimer()
        showAlert()
        setUpBindings()
    }
    
    // MARK: - Quest start
    
    func setFirstScene() {
        tabBarController?.tabBar.isHidden = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        viewModel?.setFirstScene()
        
        countdownTimer.isHidden = false
    }
    
    // MARK: - Update UI
    
    func updateUI() {
        
        countdownTimer.start(beginingValue: 15, interval: 1)
        guard let scene = viewModel?.scene else {
            return
        }
        sceneLabel.text = viewModel?.text
        
        guard viewModel?.choices?.count == 3 else {
            countdownTimer.pause()
            hideButtons(true)
            viewModel?.delegate?.endReceived(situation: viewModel!.situation, isFinished: true, isSuccess: scene.value?.isHappyEnd ?? false)
            return
        }
        
        hideButtons(false)
        topButton.setTitle(viewModel?.choiceText(0), for: .normal)
        middleButton.setTitle(viewModel?.choiceText(1), for: .normal)
        bottomButton.setTitle(viewModel?.choiceText(2), for: .normal)
    }
    
    func showAlert() {
        guard let viewModel = viewModel else { return }
        myAlert.showAlert(with: viewModel.alert.title, message: viewModel.alert.text, on: self)
    }
    
    // MARK: - User actions
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        viewModel?.setNextScene(sender.tag)
    }
    
    @objc private func didTapPause() {
        countdownTimer.pause()
        
        hideButtons(true)
        sceneLabel.isHidden = true
        
        let vc = UIAlertController(
            title: "Квест приостановлен",
            message: "Продолжить квест?\nЕсли Вы покинете игру, прогресс будет потерян",
            preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Выйти", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
            self?.tabBarController?.tabBar.isHidden = false
        }))
        
        vc.addAction(UIAlertAction(title: "Продолжить", style: .destructive, handler: { [weak self] _ in
            self?.countdownTimer.resume()
            self?.hideButtons(false)
            self?.sceneLabel.isHidden = false
        }))
        
        vc.addAction(UIAlertAction(title: "Начать заново", style: .destructive, handler: { [weak self] _ in
            self?.didTapRestart()
        }))
        present(vc, animated: true)
    }
    
    @objc private func didTapRestart() {
        setFirstScene()
        sceneLabel.isHidden = false
        viewModel?.delegate?.endReceived(situation: viewModel!.situation, isFinished: false, isSuccess: false)
    }
    
    @objc private func didTapCancel() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    // MARK: - Hepler Methods
    
    func setUpBindings() {
        viewModel?.scene.bind({ [weak self] _ in
            self?.updateUI()
        })
    }
    
    func hideButtons(_ bool: Bool) {
        topButton.isHidden = bool
        middleButton.isHidden = bool
        bottomButton.isHidden = bool
        countdownTimer.isHidden = bool
        
        pauseButton.isEnabled = !bool
        restartButton.isEnabled = bool
        navigationItem.leftBarButtonItem?.isEnabled = bool
    }
    
    func configureLabel() {
        sceneLabel.adjustsFontSizeToFitWidth = true
        sceneLabel.minimumScaleFactor = 0.5
    }
    
    func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakStrategy = .hangulWordPriority
    }
    
    func configureNavigationBar() {
        pauseButton = UIBarButtonItem(
            image: UIImage(systemName: "pause.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapPause))
        restartButton = UIBarButtonItem(
            image: UIImage(systemName: "gobackward"),
            style: .plain,
            target: self,
            action: #selector(didTapRestart))
        
        navigationItem.rightBarButtonItems = [restartButton, pauseButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapCancel))
    }
    
    func configureTimer() {
        countdownTimer.delegate = self
        countdownTimer.lineColor = .red
        countdownTimer.timerFinishingText = "End"
        countdownTimer.lineWidth = 4
    }
    
}


// MARK: - Timer delegate

extension SceneViewController: SRCountdownTimerDelegate {
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        viewModel?.setLastScene()
        sender.isHidden = true
    }
}
