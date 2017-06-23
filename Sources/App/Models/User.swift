//
//  User.swift
//  vaporDB
//
//  Created by niuhui on 2017/6/21.
//
//

import Cocoa
import Validation
import Crypto
import FluentProvider
import HTTP
final class User: Model {
    let storage = Storage()
    var phone   : String = ""
    var name    : String = ""
    var dog     : Dog?
    
    init(row: Row) throws {
        phone = try row.get("phone")
        name   = try row.get("name")
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("phone", phone)
        try row.set("name", name)
        return row
    }
}
extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { users in
            users.id()
            users.string("phone")
            users.string("name")
        }
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
