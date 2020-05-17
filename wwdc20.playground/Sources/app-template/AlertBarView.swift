import UIKit

public class AlertBarView: UIView {
    public var text: String? {
        get {
            return contentLabel.text
        }
        set {
            return contentLabel.text = newValue
        }
    }
    
    public var answer: Answer = .correct {
        didSet {
            switch answer {
            case .correct: self.backgroundColor = UIColor.green.darker(by: 30)
            case .incorrect: self.backgroundColor = UIColor.red.withAlphaComponent(0.60)
            }
        }
    }
    
    private lazy var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.text = "text content"
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        self.addSubview(contentLabel)
        self.backgroundColor = UIColor.red.withAlphaComponent(0.60)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            contentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
}

public enum Answer {
    case correct, incorrect
}
