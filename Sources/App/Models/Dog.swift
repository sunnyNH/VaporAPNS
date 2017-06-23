//
//  Dog.swift
//  vaporDB
//
//  Created by niuhui on 2017/6/21.
//
//

import Vapor
import Validation
import Crypto
import FluentProvider
import HTTP

final class Dog: Model  {
    let storage = Storage()
    var name    : String = ""
    var user_id : Int = 0
    init(row: Row) throws {
        name   = try row.get("name")
        user_id = try row.get("user_id")
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("user_id", user_id)
        return row
    }
}
extension Dog: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { users in
            users.id()
            users.string("name")
            users.foreignId(for: User.self)
        }
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
