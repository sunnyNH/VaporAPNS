import Vapor
import VaporAPNS
/// We have isolated all of our App's logic into
/// the App module because it makes our app
/// more testable.
///
/// In general, the executable portion of our App
/// shouldn't include much more code than is presented
/// here.
///
/// We simply initialize our Droplet, optionally
/// passing in values if necessary
/// Then, we pass it to our App's setup function
/// this should setup all the routes and special
/// features of our app
///
/// .run() runs the Droplet's commands,
/// if no command is given, it will default to "serve"
let config = try Config()
try config.setup()

let drop = try Droplet(config)
drop.database?.log = { query in
    print(query)
}
drop.post("v1","push") { (request) -> ResponseRepresentable in
//    
//    let users = try User.makeQuery().join(Dog.self).filter(Dog.self, "name", "小白").all()
//    let dog = try Dog.makeQuery().all()
    guard let token = request.data["token"]?.string,let msg = request.data["msg"]?.string else{
            return try JSON(node: [
            "code": 1,
            "msg" : "缺少参数",
            ])
    }
    guard var opt = try? Options(topic: "com.Sunny.walking", certPath: "/Users/yzjtest/Desktop/VaporAPNS/Public/pem/crt.pem", keyPath: "/Users/yzjtest/Desktop/VaporAPNS/Public/pem/key-noenc.pem"), let vaporAPNS = try? VaporAPNS(options: opt) else {
        return try JSON(node: [
            "code": 1,
            "msg" : "推送失败了",
            ])
    }
    print("token-\(token)")
    print("msg-\(msg)")
    background {
        opt.forceCurlInstall = true
        let payload = Payload(message: msg)
        payload.sound = "default"
        payload.badge = 1
        let pushMessage = ApplePushMessage(priority: .immediately, payload: payload, sandbox: true)
        let result = vaporAPNS.send(pushMessage, to: token)
        switch result {
        case .success(let messageID, _, _):
            print ("\(messageID)-推送出去了")
        case .error(_, _, let error):
            print ("\(error)")
        case .networkError(let error):
            print ("\(error)")
        }
    }
    return try JSON(node: [
        "code": 0,
        "msg" : "success",
        ])
}

try drop.run()
