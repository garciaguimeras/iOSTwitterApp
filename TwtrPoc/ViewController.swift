//
//  ViewController.swift
//  TwtrPoc
//
//  Created by Noel on 6/7/17.
//  Copyright © 2017 Noel. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = TWTRLogInButton(logInCompletion: { session, error in
            if session != nil {
                print("Signed in")
            }
            else {
                print("Error signing in: \(error?.localizedDescription)")
            }
        })
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
        let client = TWTRAPIClient()
        client.loadTweet(withID: "20", completion: { tweet, error in
            if let t = tweet {
                print("Tweet: \(t.text)")
            }
            else {
                print("Failed to load tweet: \(error?.localizedDescription)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func share(sender: Any) {
        print("Share!")
        
        if Twitter.sharedInstance().sessionStore.session() != nil {
            let userId = Twitter.sharedInstance().sessionStore.session()!.userID
            let composer = TWTRComposerViewController(userID: userId)
            self.present(composer, animated: true, completion: nil)
        }
        else {
            Twitter.sharedInstance().logIn(with: self, methods: .all, completion: { session, error in
                if session != nil {
                    let userId = Twitter.sharedInstance().sessionStore.session()!.userID
                    let composer = TWTRComposerViewController(userID: userId)
                    self.present(composer, animated: true, completion: nil)
                }
                else {
                    print("\(error?.localizedDescription)")
                }
            })
        }
    }

}

