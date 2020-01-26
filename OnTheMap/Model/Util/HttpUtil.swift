//
//  HttpUtil.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

class HttpUtil {
    
    static let skipSize = 5
    
    // MARK: Helper Methods
    class func taskForHttpRequest<Request: Encodable, Response: Decodable>(
        url: URL,
        method: HttpMethodType,
        headers: [String: String]?,
        body: Request?,
        responseType: Response.Type,
        completion: @escaping (Response?, Error?) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        // setting the headers if any
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // setting the body if any
        if let body = body {
            urlRequest.httpBody = try! JSONEncoder().encode(body)
        }
        
        // create the task for the request
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                // for udacity API, we need to skip first 5 characters from the response
                let range = skipSize..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(Response.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                /*
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {*/
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                //}
            }
        }
        
        // sending
        task.resume()
    }
    
    class func getXsrfCookie() -> HTTPCookie? {
        var xsrfCookie: HTTPCookie?
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        return xsrfCookie
    }
}
