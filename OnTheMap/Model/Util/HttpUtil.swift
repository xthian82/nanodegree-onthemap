//
//  HttpUtil.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

class HttpUtil {
    
    // MARK: Helper Methods
    class func taskForHttpRequest<Request: Encodable, Response: Decodable>(
        url: URL,
        method: HttpMethodType,
        headers: [String: String]?,
        body: Request?,
        responseType: Response.Type,
        skipSize: Int?,
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
            
            // for udacity API, some endpoints need to skip first 'skipSize' characters
            // if present, we should skip it
            var newData: Data
            if let skipSize = skipSize {
                let range = skipSize..<data.count
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
            
            // parse the json received
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(Response.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                // error parsing, try to decode an error from the API
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    // cannot recover, we finish with general error
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
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
