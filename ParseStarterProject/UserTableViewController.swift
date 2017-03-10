
import UIKit
import Parse

class UserTableViewController: UITableViewController {

    
    var username = [String]()
    var userIDs = [String]()
    var isFollowing = [" " : false]
    var refresher :UIRefreshControl!
    
 
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "toMainLogOut", sender: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
                return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return username.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = username[indexPath.row]
        
        if isFollowing[userIDs[indexPath.row]]!{
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if isFollowing[userIDs[indexPath.row]]!{
            
            isFollowing[userIDs[indexPath.row]] = false
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let query = PFQuery(className: "Followers")
            query.whereKey("Follower", equalTo: PFUser.current()?.objectId)
            query.whereKey("Following", equalTo: userIDs[indexPath.row])
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let objects = objects{
                    
                    for object in objects{
                        object.deleteInBackground()
                    }
                }
            })
            
            
            
            
        }else{
            
            isFollowing[userIDs[indexPath.row]] = true
            
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            let following = PFObject(className: "Followers")
            following["Follower"] = PFUser.current()?.objectId
            following["Following"] = userIDs[indexPath.row]
            
            following.saveInBackground()
        }
        
        
        
        
       
        
       
        
        
        
    }
    
    func refresh(){
        
        let query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, error) in
            
            
            self.isFollowing.removeAll()
            
            if error != nil{
                print(error!)
            }else if let users = objects {
                for object in users{
                    
                    if let user = object as? PFUser{
                        
                        if user.objectId != PFUser.current()?.objectId{
                            
                            self.username.append(user.username!)
                            self.userIDs.append(user.objectId!)
                            
                            let query = PFQuery(className: "Followers")
                            
                            query.whereKey("Follower", equalTo: PFUser.current()?.objectId as Any)
                            query.whereKey("Following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let objects = objects{
                                    
                                    if objects.count > 0{
                                        
                                        self.isFollowing[user.objectId!] = true
                                        
                                    }else{
                                        self.isFollowing[user.objectId!] = false
                                    }
                                    
                                    if self.isFollowing.count == self.username.count{
                                        
                                        self.tableView.reloadData()
                                        self.refresher.endRefreshing()
                                        
                                    }
                                }
                                
                            })
                        }
                    }
                }
                
            }
            
            
        })
        
        
    }
    
}
 
