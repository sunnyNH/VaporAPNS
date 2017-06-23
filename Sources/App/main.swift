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
    guard var opt = try? Options(topic: "com.Sunny.walking", certPath: "/Users/yzjtest/Desktop/walkingLovePem/crt.pem", keyPath: "/Users/yzjtest/Desktop/walkingLovePem/key-noenc.pem"), let vaporAPNS = try? VaporAPNS(options: opt) else {
        return "推送失败"
    }
    opt.forceCurlInstall = true
    let payload = Payload(title: "hi", body: "baobao")
    let pushMessage = ApplePushMessage(priority: .immediately, payload: payload, sandbox: true)
    let result = vaporAPNS.send(pushMessage, to: "cfc2d34ad1aff99bbac69259feb1da3480503ed4fa9414dddaf24c27d209bf0b")
    switch result {
    case .success(let messageID, _, _):
        return "\(messageID)"
    case .error(_, _, let error):
        return "\(error)"
    case .networkError(let error):
        return "\(error)"
    }
}

try drop.run()
