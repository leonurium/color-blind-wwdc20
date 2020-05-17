/*:
# Blind Color
# WWDC20
# by Rangga Leo

Hi! My name is Rangga Leo,

\- Rangga Leo
*/
import PlaygroundSupport
import UIKit

public class MainControllerView: UIViewController {
    
    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 8
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var scoreButton: UIBarButtonItem = {
        let b = UIBarButtonItem(title: "Score: 0", style: .plain, target: nil, action: nil)
        return b
    }()
    
    private lazy var levelButton: UIBarButtonItem = {
        let b = UIBarButtonItem(title: "Level: 0", style: .plain, target: nil, action: nil)
        return b
    }()
    
    private lazy var alertStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 0
        sv.distribution = .fill
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var alertView: AlertBarView = AlertBarView()
    
    var score: Int = 0 {
        didSet {
            self.scoreButton.title = "Score: \(self.score)"
        }
    }
    var level: Int = 2 {
        didSet {
            self.levelButton.title = "Level: \(self.level - 1)"
        }
    }
    
    var correctAnswer: Int = 0
    var lastIncrement: Int = 0
    var tmpStackView: [UIStackView] = []
    var boxs: [Int] {
        get {
            let total = level * level
            return Array(1...total)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        generateBoxs(level: level)
    }
    
    private func setupViews() {
        title = "Blind Color"
        view.backgroundColor = UIColor.white
        setupStackView()
        setupAlertStackView()
        setupBarView()
    }
    
    private func setupStackView() {
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            mainStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            mainStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    private func setupAlertStackView() {
        let v = UIView()
        view.addSubview(alertStackView)
        view.bringSubviewToFront(alertStackView)
        NSLayoutConstraint.activate([
            alertStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            alertStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            alertStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        alertStackView.addArrangedSubview(v)
        alertStackView.addArrangedSubview(alertView)
        alertView.isHidden = true
    }
    
    private func setupBarView() {
        navigationItem.rightBarButtonItem = scoreButton
        navigationItem.leftBarButtonItem = levelButton
        level = 2
    }
    
    private func generateBoxs(level: Int) {
        let data = Array(1...level)
        let (correctAnswer, color) = getCorrectAnswer()
        self.correctAnswer = correctAnswer
        for row in data {
            let stackView = UIStackView()
            stackView.spacing = 8
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            for column in data {
                let buttonSize = mainStackView.bounds.height / CGFloat(level)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
                var tag = lastIncrement == 0 ? column : column + lastIncrement
                if tag == correctAnswer {
                    let levelColor: CGFloat = 10.0
                    button.backgroundColor = (tag % 2) == 0 ? color.lighter(by: levelColor) : color.darker(by: levelColor)
                } else {
                    button.backgroundColor = color
                }
                button.tag = tag
                button.layer.cornerRadius = button.bounds.height / 2
                button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
                
                lastIncrement = column == data.endIndex ? data.endIndex * row : lastIncrement
            }
            tmpStackView.append(stackView)
            UIView.animate(withDuration: 0.5) {
                self.mainStackView.addArrangedSubview(stackView)
            }
        }
    }
    
    private func getCorrectAnswer() -> (Int, UIColor) {
        return (boxs.randomElement()!, UIColor.random())
    }
    
    private func showAlert(message: String, answer: Answer) {
        alertView.answer = answer
        alertView.text = message
        UIView.animate(withDuration: 1) {
            self.alertView.isHidden = false
        }
    }
    
    private func dismissAlert() {
        UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
            self.alertView.isHidden = true
        }, completion: nil)
    }
    
    private func resetDefaultValue() {
        correctAnswer = 0
        lastIncrement = 0
    }
    
    @objc
    func handleTap(_ sender: UIButton) {
        let notif = UINotificationFeedbackGenerator()
        if sender.tag == correctAnswer {
            showAlert(message: "Correct! you got 1 Score!", answer: .correct)
            notif.notificationOccurred(.success)
            resetDefaultValue()
            score += 1
            if score % 10 == 0 {
                level += 1
            }
            tmpStackView.forEach { (stackView) in
                UIView.animate(withDuration: 0.5, animations: {
                    stackView.isHidden = true
                }) { (complete) in
                    if complete {
                        stackView.removeFromSuperview()
                    }
                }
            }
            tmpStackView.removeAll()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.generateBoxs(level: self.level)
            }) { (s) in
                if s {
                    self.dismissAlert()
                }
            }

        } else {
            notif.notificationOccurred(.error)
            showAlert(message: "Incorrect! Your Answer is wrong!, deducted 1 score", answer: .incorrect)
            if score > 0 {
                score -= 1
            }
        }
    }
}

final public class BlindColor {
    public static var shared: BlindColor = BlindColor()
    let view: UINavigationController?
    
    init() {
        let vc = MainControllerView()
        let nav = UINavigationController(rootViewController: vc)
        self.view = nav
    }
    
    public func run() {
        guard let view = self.view else { return }
        PlaygroundPage.current.liveView = view
    }
}

BlindColor.shared.run()
