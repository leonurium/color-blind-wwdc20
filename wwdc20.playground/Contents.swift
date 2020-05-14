import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        let txt_field = UITextField(frame: CGRect(x: 150, y: 200, width: 200, height: 20))
        txt_field.backgroundColor = UIColor.black
        view.addSubview(txt_field)
//        view.addSubview(label)
        self.view = view
    }
}

PlaygroundPage.current.liveView = MyViewController()
