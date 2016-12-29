# Network Example
This is sample code that utilizes REST API calls and JSON parsing. It mimics a social network design. It utilizes dummy data and API endpoints from [JSON Placeholder](http://jsonplaceholder.typicode.com/)

## Notes
* This is for code purposes - the user interface is not optimized.
* Check fetch methods for endpoint names
* Coded in Swift 3.0 on XCode 8.1
* This is migrated from a private Bitbucket repo

## Main View Controller 
* This view controller is nested in a navigation controller. 
* The main screen is a list of post titles and corresponding authors and usernames. 
* On ViewDidLoad(), it first calls fetchUsers(). It serializes JSONSerialization and extracts data into a User object. It is chained to fetchPosts() methods. This is similarly parsed and data is extracted into a Post object. The tableview is then reloaded 
* Each post includes a user ID
* For tableView(cellForRowAt indexPath:), it accesses the post at indexpath.row, and then crossreferences the User ID with the User Array to get User.name and User.username.
* For tableView(didSelectRowAt indexPath:), the postID is extracted, and passed to the DetailViewController through prepareForSegue() method. In addition, postTitle, postBody and user data is passed. 

## Detail View Controller
* On ViewDidLoad(), it calls fetchComments(), which extracts comments for the corresponding post in an endpoint. The JSON data is parsed, and extracted into a Comment object.
* Post body is displayed first, with title and username being at the top.
* There is a segmentedController that, when pressed, shows comments from the Comments array on the UITableView in this view controller.
* A user goes back by pressing the back arrow on top left




