//
//  ChallengeViewController.swift
//  challenme
//
//  Created by Fangyi Chen on 4/26/15.
//  Copyright (c) 2015 Fangyi Chen. All rights reserved.
//

import UIKit
import CoreData

class ChallengeViewController: UIViewController {
    
    var selectedChallenge: Challenge!
    var titleTextField: UITextField!

    var moc:NSManagedObjectContext!
    
    @IBOutlet weak var contextView: UITextView!
   // @IBOutlet weak var a: UITextField!
   // @IBOutlet weak var contentTextView: UITextView!
    //@IBOutlet weak var contentTextView: UITextView!
    //@IBOutlet var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext{
            moc = context
        }
        
        titleTextField = UITextField(frame: CGRectMake(0, 0, 200, 22))
        titleTextField.font = UIFont.boldSystemFontOfSize(19)
        titleTextField.textAlignment = NSTextAlignment.Center
        
        self.navigationItem.titleView = titleTextField
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissVC")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveChallenge")
        
        if let challengeTitle = selectedChallenge.title {
            titleTextField.text = challengeTitle
        }else{
            titleTextField.text = "Please Enter Title"
        }
//        if let challengeDuration = selectedChallenge.duration {
//            a.text = challengeDuration
//        }else{
//            a.text = "Please Enter Duration"
//        }
        
        if let challengeContent = selectedChallenge.content{
            contextView.text = challengeContent
        }else{
            contextView.text = "ddd"
        }
    }
    
    func dismissVC (){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveChallenge(){
        selectedChallenge.title = titleTextField.text
        selectedChallenge.content = contextView.text
        //selectedChallenge.duration = a.text
        moc.save(nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
