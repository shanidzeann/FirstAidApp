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
    
    var delegate: CanReceive?
    var id: Int?
    var situation: Situation?
    
    var scene: Scene? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        sceneLabel.adjustsFontSizeToFitWidth = true
        sceneLabel.minimumScaleFactor = 0.5
        
        configureButton(topButton)
        configureButton(middleButton)
        configureButton(bottomButton)
        
        configureTimer()

        myAlert.showAlert(with: "Правила", message: "Твоя задача - оказать первую помощь и спасти постравшего. Будь внимателен, время ответа ограничено.", on: self)
    }
    
    
    // MARK: - Quest start
    
    func setFirstScene() {
        tabBarController?.tabBar.isHidden = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        scene = situation?.scene[0]
        
        countdownTimer.isHidden = false
        countdownTimer.start(beginingValue: 15, interval: 1)
    }
    
    // MARK: - Update UI
    
    func updateUI() {
        
        countdownTimer.start(beginingValue: 15, interval: 1)
        guard let scene = scene else {
            return
        }
        
        sceneLabel.text = scene.text
        
        guard let choices = scene.choices else {
            countdownTimer.pause()
            hideButtons(true)
            delegate?.endReceived(id: id!, isFinished: true, isSuccess: scene.isHappyEnd)
            return
        }
        
        hideButtons(false)
        topButton.setTitle(choices[0].text, for: .normal)
        middleButton.setTitle(choices[1].text, for: .normal)
        bottomButton.setTitle(choices[2].text, for: .normal)
    }
    
    // MARK: - User actions
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        if let nextSceneID = scene?.choices?[sender.tag - 1].destination {
            scene = situation?.scene[nextSceneID]
        }
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
        delegate?.endReceived(id: id!, isFinished: false, isSuccess: false)
    }
    
    @objc private func didTapCancel() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    // MARK: - Hepler Methods
    
    func hideButtons(_ bool: Bool) {
        topButton.isHidden = bool
        middleButton.isHidden = bool
        bottomButton.isHidden = bool
        countdownTimer.isHidden = bool
        
        pauseButton.isEnabled = !bool
        restartButton.isEnabled = bool
        navigationItem.leftBarButtonItem?.isEnabled = bool
    }
    
    func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
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
        scene = situation?.scene.last
        sender.isHidden = true
    }
}
