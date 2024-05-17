//
//  RecruitTech.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

struct RecruitTech: Codable {
    let phone, note: JSONNull?
    let id, firstName: String
    let linkedinURL: JSONNull?
    let isFavorite: Bool
    let email, lastName: String
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
