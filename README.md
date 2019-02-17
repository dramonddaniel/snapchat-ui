## Snapchat UI

<p align="center">
  <img src="https://user-images.githubusercontent.com/19694636/44957769-ae43ae80-aecd-11e8-8c89-00bce6d3f3e2.gif" width="24%" />
  <img src="https://user-images.githubusercontent.com/19694636/44957448-b64e1f00-aeca-11e8-8de7-7e06745ad22b.PNG" width="24%" /> 
  <img src="https://user-images.githubusercontent.com/19694636/44957438-97e82380-aeca-11e8-8577-df6e3a163d4c.gif" width="24%" />
  <img src="https://user-images.githubusercontent.com/19694636/44957587-6b80d700-aecb-11e8-8f82-92df77319ed1.gif" width="24%" />
</p>

---

<i>How did you manage to pull the news articles in the stories view?</i>
- I actually used the **News API** (https://newsapi.org/) and got a hold of the JSON they provide for their latest MTV articles; using the MVC pattern.

<i>How did you manage to load the snaps?</i>
- I actually wrote up a simple **node.js** server that I've hosted up on Heroku (https://snapchat-nodejs.herokuapp.com/posts) and again I used the MVC pattern to fetch and display those snaps. Here's an example of my Snap Object:

```swift

class Snap: NSObject {
    var username: String?
    var timestamp: NSNumber?
    var type: String?
    var bitmoji: String?
    var isRead: Bool?
    var content: String?
    
    init(username: String?, timestamp: NSNumber?, type: String?, bitmoji: String?, isRead: Bool?, content: String?) {
        self.username = username
        self.timestamp = timestamp
        self.type = type
        self.bitmoji = bitmoji
        self.isRead = isRead
        self.content = content
    }
}
```

---

## Contributors 
- Daniel Dramond <dramonddaniel@gmail.com>

## License & Copyright

© Daniel Dramond
