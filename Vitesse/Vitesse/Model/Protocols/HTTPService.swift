//
//  HTTPService.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

protocol HTTPService {
    func request(_ request : URLRequest) async throws -> (Data, HTTPURLResponse)
}
