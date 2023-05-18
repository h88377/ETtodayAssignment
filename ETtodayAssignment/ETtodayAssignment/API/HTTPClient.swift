//
//  HTTPClient.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func dispatch(_ request: URLRequest, completion: @escaping (Result) -> Void)
}
