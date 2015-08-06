//
//  ChallengeOverviewTableViewController.swift
//  challenme
//
//  Created by Fangyi Chen on 4/26/15.
//  Copyright (c) 2015 Fangyi Chen. All rights reserved.
//

import UIKit
import CoreData

class ChallengeOverviewTableViewController: UITableViewController {
    
    var moc:NSManagedObjectContext!
    
    var selectedChallengeBook:ChallengeBook!
    
    var challengesArray = [Challenge]()
    
    var newChallenge:Challenge? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissVC")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addChallenge")
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        if let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext{
            moc = context
        }
        
        newChallenge = nil
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidChange", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreWillChange", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveICloudChanges", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
        
        loadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
    }
    
    func persistentStoreDidChange (){
        //reenable UI and fetch data
        self.navigationItem.title = "iCloud ready"
        self.navigationItem.rightBarButtonItem?.enabled = true
        
        loadData()
    }
    
    func persistentStoreWillChange (notification:NSNotification){
        self.navigationItem.title = "Change in progress"
        //disable the UI
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        moc.performBlock { () -> Void in
            if self.moc.hasChanges {
                var error:NSError? = nil
                self.moc.save(&error)
                if error != nil {
                    println("Save error: \(error)")
                }else{
                    //drop any managed object references
                    self.moc.reset()
                }
            }
            
        }
    }
    
    func recieveICloudChanges (notification:NSNotification){
        moc.performBlock { () -> Void in
            self.moc.mergeChangesFromContextDidSaveNotification(notification)
            self.loadData()
        }
    }

    func loadData() {
        challengesArray = [Challenge]()
        
        var unsortedChallenges = NSMutableArray()
        
        for singleChallenge in selectedChallengeBook.challenge{
            let loopChallenge = singleChallenge as! Challenge
            unsortedChallenges.addObject(loopChallenge)
        }
        
        let sortDescriptor = NSSortDescriptor(key: "creationTime", ascending: true)
        
        challengesArray = unsortedChallenges.sortedArrayUsingDescriptors([sortDescriptor]) as! [Challenge]
        
        self.tableView.reloadData()
    }
    
    func addChallenge() {
        let challenge = CoreDataHelper.insertManagedObject(NSStringFromClass(Challenge), managedObjectContext: moc) as! Challenge
        
        challenge.creationTime = NSDate()
        
        selectedChallengeBook.addChallengeObject(challenge)
        
        newChallenge = challenge
        
        moc.save(nil)
        
        self.performSegueWithIdentifier("showSingleChallenge", sender:self)
    }
    
    func dismissVC () {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return challengesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = challengesArray[indexPath.row].title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSingleChallenge" {
            let challengeVC = segue.destinationViewController as! ChallengeViewController
            
            if let segueChallenge = newChallenge {
                challengeVC.selectedChallenge = segueChallenge
            }else{
                if let index = self.tableView.indexPathForSelectedRow(){
                    challengeVC.selectedChallenge = challengesArray[index.row]
                }
            }
            
        }

    }
    

}
