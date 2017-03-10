import UIKit
import Parse


class registerController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var kaydolBtn: UIButton!
    
    @IBAction func kaydolBtn(_ sender: Any) {
        
        if userField.text == "" || passField.text == ""{
            
            createAlert(title: "Eksik birşey var", message: "Kullanıcı adı veya şifre eksik")
        
        }else{
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
           
             let user = PFUser()
            
            user.username = userField.text
            user.password = passField.text
            
            user.signUpInBackground(block: { (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                self.userField.text = ""
                self.passField.text = ""
                
                if error != nil{
                  
                    self.createAlert(title: "Error in form", message: "Email adresi daha önce alışmış")
                    
                }else{
                    print("User signed up")
                    
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
                
            })
            
            
            
        }
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kaydolBtn.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
           alert.dismiss(animated: true, completion: nil)
        
        }))
     
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
