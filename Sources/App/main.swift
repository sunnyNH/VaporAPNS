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
drop.get("dog") { (response) -> ResponseRepresentable in
    
    let users = try User.makeQuery().join(Dog.self).filter(Dog.self, "name", "小白").all()
    let dog = try Dog.makeQuery().all()
    guard var opt = try? Options(topic: "com.Sunny.walking", certPath: "/root/VaporAPNS/Public/pem/crt.pem", keyPath: "/root/VaporAPNS/Public/pem/key-noenc.pem"), let vaporAPNS = try? VaporAPNS(options: opt) else {
        return "推送失败"
    }
    opt.forceCurlInstall = true
    let payload = Payload(title: "hi", body: "baobao")
    let pushMessage = ApplePushMessage(priority: .immediately, payload: payload, sandbox: true)
    let result = vaporAPNS.send(pushMessage, to: "1df391265638af7684b4e9a600895a730d57242ea098cd227fff876a15e8df40")
    switch result {
    case .success(let messageID, _, _):
<<<<<<< HEAD
        return "\(messageID)-推送出去了"        
=======
        return "\(messageID)"
>>>>>>> dadf96c0a9a4b0873f78683d85120175dfb81623
    case .error(_, _, let error):
        return "\(error)"
    case .networkError(let error):
        return "\(error)"
    }
}

try drop.run()
