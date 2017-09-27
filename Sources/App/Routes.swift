import Vapor
import Foundation
import PubNub

var client: PubNub!



let configuration = PNConfiguration(publishKey: "pub-c-b6db3020-95a8-4c60-8d16-13345aaf8709", subscribeKey: "sub-c-05dce56c-3c2e-11e7-847e-02ee2ddab7fe")


func set()
{
    client = PubNub.clientWithConfiguration(configuration)
    //client.addListener(self as! PNObjectEventListener)
    client.subscribeToChannels(["hello_world"], withPresence: true)
    
}

func publish(message: String)
{
    client.publish("Hello", toChannel: "hello_world", withCompletion: nil)
}



func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
    
    // Handle new message stored in message.data.message
    if message.data.channel != message.data.subscription {
        
        // Message has been received on channel group stored in message.data.subscription.
    }
    else {
        
        // Message has been received on channel stored in message.data.channel.
    }
    
    print("Received message: \(message.data.message!) on channel \(message.data.channel) " +
       "at \(message.data.timetoken)")
    
    
}

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("pubnub") { req in
            set()
            publish(message: "Hello")
            return "hello"
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
