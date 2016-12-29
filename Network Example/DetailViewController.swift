//
//  DetailViewController.swift
//  Network Example
//
//  Copyright © 2016 Elon Rubin. All rights reserved.
//

import Foundation
import UIKit


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    
    @IBOutlet weak var postBody: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedPost: Post = Post()
    
    var session = URLSession.shared
    var comments = [Comment]()
    var users = [User]()
    
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        initalizeController()
    }
    
    func initalizeController () {
        let user = users[selectedPost.userID]
        
        DispatchQueue.main.async(execute: {
        self.postTitle.text = self.selectedPost.title
        self.postAuthor.text = "By " + user.name
        self.postBody.text = self.selectedPost.body
             })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let comment = comments[indexPath.row]
        
        // This is logic to tell whether a place objcet is a sent or recieved item.
        
        cell.textLabel!.text = comment.title
        
        let user = users[comment.userID]
        
        cell.detailTextLabel?.text = user.username + "(\(user.name))"
        return cell
    }
    
    
    func fetchComments (forPost: Int) {
        let commentIDString = String(forPost)
        let url = NSURL(string: "http://jsonplaceholder.typicode.com/comments?postId=\(commentIDString)")!
        print(url)
        let request = NSMutableURLRequest(url: url as URL)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // Parse Data
            
            guard let data = data else {
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
            
            if let comments = parsedDataResult as? [[String:AnyObject]] {
                for comment: [String:AnyObject] in comments {
                    
                    let commentObject: Comment = Comment()
                    
                    // Note - I would ordinarliy structure this as an optional, but since the code is set, I am going to force unwrap
                    
                    
                    commentObject.title = comment["name"] as! String
                    commentObject.id = comment["id"] as! Int
                    commentObject.body = comment["body"] as! String
//                    commentObject.userID = comment["email"] as! String
                    self.comments.append(commentObject)
            
                }
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            } else {
                
            }
            
        }
        task.resume()
    }
    
    @IBAction func segmentControlDidChange(_ sender: Any) {
    
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            postBody.isHidden = false
            tableView.isHidden = true
        case 1:
            postBody.isHidden = false
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            })
        default:
            postBody.isHidden = false
            tableView.isHidden = true
        }
        
    }
    
    
}
