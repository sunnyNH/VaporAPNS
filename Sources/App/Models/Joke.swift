//
//  Joke.swift
//  VaporDBAPNS
//
//  Created by niuhui on 2017/6/30.
//
//
import Validation
import Crypto
import FluentProvider
import HTTP
final class Joke: Model {
    let storage = Storage()
    var hashId      : String    = ""
    var content     : String    = ""
    var unixtime    : Int       =  0
    var updatetime  : String    = ""
    init(row: Row) throws {
        hashId = try row.get("hashId")
        content   = try row.get("content")
        unixtime   = try row.get("unixtime")
        updatetime   = try row.get("updatetime")
    }
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("hashId", hashId)
        try row.set("content", content)
        try row.set("unixtime", unixtime)
        try row.set("updatetime", updatetime)
        return row
    }
}
extension Joke: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { users in
            users.id()
            users.string("updatetime")
            users.int("unixtime")
            users.string("content")
            users.string("hashId")
        }
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
