//
//  SaintOfTheDay.swift
//  BU Newman House
//
//  Created by Luke Redmore on 8/15/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import Foundation
import SwiftSoup

class SaintOfTheDay {
    
    
    static func get(completion : @escaping (String, String, String) -> Void) {
        if let url = URL(string: "https://www.catholic.org/saints/sofd.php") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if response as? HTTPURLResponse != nil && data != nil {
                    let htmlString = String(data: data!, encoding: .ascii)
                    if let html = try? SwiftSoup.parse(htmlString!) {
                        parseForSaintLink(fromHTML: html, completion: completion)
                    }
                } else if error != nil {
                    print("Error on request to Breeze: ")
                    print(error!)
                }
            }
            task.resume()
        } else { print("Bad Catholic homepage URL") }
    }
    
    static func parseForSaintLink(fromHTML htmlDoc : Document, completion : @escaping (String, String, String) -> Void) {
        guard let saintInfo = try? htmlDoc.select("div #saintsSofd a").array()[1] else { return }
        if let saintLink = try? saintInfo.attr("href"), let url = URL(string: "https://www.catholic.org\(saintLink)") {
            getSaint(fromURL: url, completion: completion)
        } else {
            print("link couldn't be followed")
        }
        
    }
    
    static func getSaint(fromURL url : URL, completion : @escaping (String, String, String) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if response != nil && data != nil {
                let htmlString = String(data: data!, encoding: .ascii)
                if let html = try? SwiftSoup.parse(htmlString!) {
                    parseForSaint(fromHTML: html, completion: completion)
                }
            } else if error != nil {
                print("Error on request to Saint URL \(url.absoluteString): ")
                print(error!)
            }
        }
        task.resume()
    }
    
    static func parseForSaint(fromHTML htmlDoc : Document, completion : @escaping (String, String, String) -> Void) {
        let saintName = (try? htmlDoc.select("#content .page-title").first()?.text()) ?? ""
        let saintDescription = (try? htmlDoc.select("#saintContent p").first()?.text()) ?? ""
        let optionalLink = try? htmlDoc.select("#saintFacts img").first()?.attr("data-src")
        let pictureLink = optionalLink != nil ? "https://www.catholic.org\(optionalLink!)" : ""
        DispatchQueue.main.async {
            print("Saint of the Day loaded with the following parameters:")
            print("saintName: \(saintName)")
            print("saintDescription: \(saintDescription.substring(to: String.Index(utf16Offset: 50, in: saintDescription)))...")
            print("pictureLink: \(pictureLink)")
            completion(saintName, saintDescription, pictureLink)
        }
    }
    
}
