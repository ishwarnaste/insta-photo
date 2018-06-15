//
//  ViewController.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/12/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit


class ViewController: UIViewController,InstaAuthrizationDelegate, LoginDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onTapLoginToInsta(_ sender: Any) {
        performSegue(withIdentifier: "InstaLoginIdentifier", sender: nil)
    }
    
    func didReceiveAuthrizationCode(code: String) {
        self.loginBtn?.isHidden = true
        self.navigationController?.popViewController(animated: true)
//        self.loginBtn.isUserInteractionEnabled = false
//        self.loginBtn.setTitle("Validating Authentication",for: .normal)
        self.statusLabel.text = "Validating Authentication"
        let fetchToken = LoginModel()
        fetchToken.getToken(authCode: code, delegate: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InstaLoginIdentifier"{
            if let destination = segue.destination as? InstaLoginViewController {
                destination.delegate = self
            }
        }
    }
    
    func didLoginSuccessfully() {
        performSegue(withIdentifier: "LandingPageIdentifier", sender: nil)
    }
    
    func didFailToLogin() {
        //Handle Failure
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

