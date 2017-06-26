import Vapor
import VaporAPNS
import Foundation
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
func push(_ token: String , _ msg: String) {
    background {
        guard var opt = try? Options(topic: "com.Sunny.walking", certPath: "/Users/yzjtest/Desktop/VaporAPNS/Public/pem/crt.pem", keyPath: "/Users/yzjtest/Desktop/VaporAPNS/Public/pem/key-noenc.pem"), let vaporAPNS = try? VaporAPNS(options: opt) else {
            print("失败了")
            return
        }
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
}
background {
    while true {
        func monthDayTimeStr() -> String {
            let format = DateFormatter()
            format.dateFormat = "HH"
            return format.string(from: Date())
        }
        let url = "http://jisutqybmf.market.alicloudapi.com/weather/query?citycode=101010100"
        if monthDayTimeStr() == "08" {
            //            let req = try drop.client.post(url+"users",["Authorization":"Bearer \(access_token)"],users.makeBody())
            
            do {
                let req = try drop.client.get(url, ["Authorization":"APPCODE 824edf8360514cae9315949d81650998"])
                if req.status.statusCode == 200 {
                    if let dic = req.data["result"] {
                        let str = "北京 \(dic["date"]?.string ?? "") \(dic["week"]?.string ?? "")：\(dic["weather"]?.string ?? ""),最高气温:\(dic["temphigh"]?.string ?? ""),最低气温\(dic["templow"]?.string ?? ""),\(dic["winddirect"]?.string ?? "")\(dic["windpower"]?.string ?? "")"
                        
                        push("80e555c83f362111fb04e8e7d82be21f06cf113f90671d0cdf5d0e88e9fc848d", str)
                        push("1df391265638af7684b4e9a600895a730d57242ea098cd227fff876a15e8df40", str)
                    }
                }
            } catch {
                
            }
        }
        drop.console.wait(seconds: 60*60)
    }
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
    push(token, msg)
    print("token-\(token)")
    print("msg-\(msg)")
    return try JSON(node: [
        "code": 0,
        "msg" : "success",
        ])
}
try drop.run()
