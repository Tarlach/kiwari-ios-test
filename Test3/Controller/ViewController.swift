//
//  ViewController.swift
//  Test3
//
//  Created by Ivan Riyanto on 11/11/19.
//  Copyright © 2019 Ivan Riyanto. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    var myTable = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewMessage))
        DispatchQueue.main.async {
            self.userIsLoggedIn()
        }
//        var ref: DatabaseReference?
//        ref = Database.database().reference(fromURL: "https://real-time-messaging-ebc44.firebaseio.com/")
//        ref?.updateChildValues(["someValues": 123123])
//
        
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navViewController = UINavigationController(rootViewController: newMessageController)
        present(navViewController, animated: true, completion: nil)
    }
    
    func userIsLoggedIn() {
        FirebaseApp.configure()
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, with: 1)
        } else {
            
            Database.database().reference().child("users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value  as? [String:AnyObject]{
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
        }
    }

    @objc func handleLogout() {
        do{
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
 
        let loginController = LoginController()
        present(loginController, animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController: UITableViewDelegate{
    
}
