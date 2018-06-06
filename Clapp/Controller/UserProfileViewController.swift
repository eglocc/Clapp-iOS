//
//  UserProfileViewController.swift
//  Clapp
//
//  Created by Ergiz Work on 23/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class UserProfileViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var handle : AuthStateDidChangeListenerHandle?
    var userInfoDictionary : [String : String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.title = "User Profile"
        GIDSignIn.sharedInstance().uiDelegate = self
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user == nil {
                self.performSegue(withIdentifier: "forceLogin", sender: nil)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.setRightBarButton(UIBarButtonItem.init(title: "Sign Out", style: .plain, target: self, action: #selector(UserProfileViewController.userDidSignOut)), animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.setRightBarButton(nil, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func userDidSignOut() {
        GIDSignIn.sharedInstance().signOut()
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

extension UserProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dictionary = userInfoDictionary { return dictionary.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! UserInfoTableViewCell
        
        return reusableCell
    }
}
