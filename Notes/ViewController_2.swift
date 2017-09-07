//
//  ViewController_2.swift
//  Notes
//
//  Created by Moataz on 8/28/17.
//  Copyright © 2017 Moataz. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController_2: UIViewController {

    @IBOutlet weak var emailTx: UITextField!
    @IBOutlet weak var passwordTx: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var btnOutlet: UIButton!
    @IBAction func loginBtn(_ sender: Any) {
        if emailTx.text != "" && passwordTx.text != "" {
            if segControl.selectedSegmentIndex  == 0 //Login
            {
            Auth.auth().signIn(withEmail: emailTx.text!, password: passwordTx.text!, completion: { (user, error) in
                if user != nil{
                    //Successful Login
                    self.performSegue(withIdentifier: "segue", sender: self)
                
                }
                else{
                    //Failed Login
                    if let myError = error?.localizedDescription{
                    print(myError)}
                    else{
                    print ("Error")}
                }
            })
            }
            else //Signup
            {
             Auth.auth().createUser(withEmail: emailTx.text!, password: passwordTx.text!, completion: { (user, error) in
                if user != nil {
                    //Successful SignUp
                    self.performSegue(withIdentifier: "segue", sender: self)

                }
                else {
                    if let myError = error?.localizedDescription{
                        print(myError)}
                    else{
                        print ("Error")}
                    
                }
             })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
