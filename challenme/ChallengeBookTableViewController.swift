//
//  ChallengeBookTableViewController.swift
//  challenme
//
//  Created by Fangyi Chen on 4/26/15.
//  Copyright (c) 2015 Fangyi Chen. All rights reserved.
//

import UIKit
import CoreData

class ChallengeBookTableViewController: UITableViewController {

    var moc:NSManagedObjectContext!
    var challengebookArray = [ChallengeBook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "waiting for iCloud"
        //self.navigationItem.title = "iCloud is ready"
        self.navigationItem.rightBarButtonItem?.enabled = false
        
     }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        if let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext{
            moc = context
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidChange", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveICloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
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
        self.navigationItem.title = "Changes in progress"
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
    
    @IBAction func addChallengeBook(sender: AnyObject) {
        
        let addChallengeBookAlert = UIAlertController(title: "New ChallengeBook", message:"Enter ChallengeBook title", preferredStyle: UIAlertControllerStyle.Alert)
        addChallengeBookAlert.addTextFieldWithConfigurationHandler(nil)
        addChallengeBookAlert.addAction(UIAlertAction(title: "Save ChallengeBook", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction!) -> Void in
            let textField = addChallengeBookAlert.textFields?.last as! UITextField
            
            if textField.text != "" {
                let challengebook = CoreDataHelper.insertManagedObject(NSStringFromClass(ChallengeBook), managedObjectContext: self.moc) as! ChallengeBook
                challengebook.title = textField.text
                challengebook.creationTime = NSDate()
                self.moc.save(nil)
                self.loadData()
            }
            
        }))
        
        addChallengeBookAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(addChallengeBookAlert, animated: true, completion: nil)
    }

    func loadData() {
        challengebookArray = [ChallengeBook]()
        challengebookArray = CoreDataHelper.fetchEntities(NSStringFromClass(ChallengeBook), managedObjectContext: moc, predicate: nil) as! [ChallengeBook]
        self.tableView.reloadData()
        
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
        return challengebookArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = challengebookArray[indexPath.row].title
        
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
        if segue.identifier == "showChallenges" {
            let challengeOverviewVC = segue.destinationViewController as! ChallengeOverviewTableViewController
            
            if let index = self.tableView.indexPathForSelectedRow(){
                challengeOverviewVC.selectedChallengeBook = challengebookArray[index.row]
            }
            
        }
    }
    

}
