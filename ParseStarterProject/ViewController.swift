import UIKit
import Parse

class ViewController: UIViewController {

    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func girisBtn(_ sender: Any) {
        
    
        if userTextField.text == "" || passField.text == ""{
            
           
            self.createAlert(title: "Hata", message: "Kullanıcı adı ve şifre giriniz")
            
            
        }else{
        
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        PFUser.logInWithUsername(inBackground: userTextField.text!, password: passField.text!) { (user, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            self.userTextField.text = ""
            self.passField.text = ""
        
        if error != nil{
            
            self.createAlert(title: "Giriş hatası", message: "email veya şifre yanlış")
            
        }else{
            
            print("logged in")
            self.performSegue(withIdentifier: "toUsers", sender: self)
            
            }
        
        }
        
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "toUsers", sender: self)
            
        }
        
        navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loginBtn.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
