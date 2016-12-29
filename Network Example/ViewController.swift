//
//  ViewController.swift
//  Network Example

//  Copyright © 2016 Elon Rubin. All rights reserved.
//
import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // Variables for this ViewController
    var session = URLSession.shared
    var posts = [Post]()
    var users = [User]()
  
    // Variables passed detail view controller
    var selectedPost: Post = Post()
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // 1 - The fetchUser methods is called to parse the User endpoint and put each object into the Users array [endpoint 1 - users].
        // 2 - At the completion of this method, fetchPosts() methods [endpoint 2 - posts]
        fetchUsers()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // When someone taps on a tablecell, it calls this segue. This passes place information to map view controller
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! DetailViewController
            vc.users = users
            vc.selectedPost = selectedPost
            vc.fetchComments(forPost: selectedPost.id)
        }
    }
    
    //--------------------------------------
    // MARK: TableView Methods
    //--------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = posts[indexPath.row]
        
        
        cell.textLabel!.text = post.title
        
        let user = users[post.userID]
        
        cell.detailTextLabel?.text = user.username + "(\(user.name))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When you tap on a row, it takes the Post object at the indexpath and sets the variable selectedPost equal to the post. This is then passed to the DetailViewController in the prepare for segue method
     let post = posts[indexPath.row]
        selectedPost = post
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    //--------------------------------------
    // MARK: Fetch Data Methods
    //--------------------------------------
    
    func fetchUsers () {
        let url = NSURL(string: "http://jsonplaceholder.typicode.com/users")
        let request = NSMutableURLRequest(url: url as! URL)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
    
         // Parse Data
            
           guard let data = data else {
             // Note - I would add an UIAlertView message if there is an error in retriving the data
            return
            }
         
//            var parsedDataResult: [[String:AnyObject]]!
            var parsedDataResult: Any
            do {
                 parsedDataResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//              print (parsedDataResult)
            } catch {
                // Handle error here
        
                return
            }
            
            if let results = parsedDataResult as? [[String:AnyObject]] {
                for contact: [String:AnyObject] in results {
                    
                    let userObject: User = User()
                    
                    // Note - I would ordinarliy structure this as an optional, but since the code is set, I am going to force unwrap
                    userObject.name = contact["name"] as! String
                    userObject.email = contact["email"] as! String
                    userObject.userID = contact["id"] as! Int
                    userObject.username = contact["username"] as! String
                    self.users.append(userObject)
                    print(self.users.count)
                }
               self.fetchPosts()
                
            } else {
            
            }

        }
        task.resume()
    }
    
    func fetchPosts () {
        let url = NSURL(string: "http://jsonplaceholder.typicode.com/posts")
        let request = NSMutableURLRequest(url: url as! URL)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
          
            guard let data = data else {
                return
                // Note - I would add an UIAlertView message if there is an error in retriving the data
            }
            
            var parsedDataResult: Any
            do {
                parsedDataResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //              print (parsedDataResult)
            } catch {
                // Handle error here
                
                return
            }
            
            if let posts = parsedDataResult as? [[String:AnyObject]] {
                for post: [String:AnyObject] in posts {
                    
                    let postObject: Post = Post()
                    
                    // Note - I would ordinarliy structure this as an optional, but since the code is set, I am going to force unwrap
                    postObject.title = post["title"] as! String
                    postObject.id = post["id"] as! Int
                    postObject.body = post["body"] as! String
                    postObject.userID = post["userId"] as! Int
                    self.posts.append(postObject)
                    print(self.posts.count)
                }
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    })
                
            } else {
                
            }
            
        }
        task.resume()
    }

    
  }

