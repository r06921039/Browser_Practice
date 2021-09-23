//
//  URLExtension.swift
//  Browser_Practice
//
//  Created by Jeff on 2021/9/22.
//

import Foundation

extension URL {
    static func parseString(withString string: String) -> URL? {
        let urlString: String
        
        if (string.starts(with: "http://") || string.starts(with: "https://")) {
            urlString = string
        } else {
            urlString = "http://" + string
        }
        
        return URL(string: urlString)
    }
}
