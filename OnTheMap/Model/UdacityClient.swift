//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Cristhian Recalde on 1/26/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import Foundation

class UdacityClient {

    // MARK: Properties
    static let skipSize = 5

    struct Auth {
        static var accountId = ""
        static var sessionId = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    // MARK: Endpoints
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case userData(userId: String)
        case studentLocations(orderBy: String, limitSize: Int)
        case studentLocation(userId: String)
        case addStudentLocation
        case updateStudentLocation(objectId: String)
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .userData(let userId):
                return Endpoints.base + "/users/\(userId)"
            case .studentLocations(let orderBy, let limitSize):
                return Endpoints.base + "/StudentLocation?order=\(orderBy)&limit=\(limitSize)"
            case .studentLocation(let userId):
                return Endpoints.base + "/StudentLocation?uniqueKey=\(userId)&limit=1"
            case .addStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId):
                return Endpoints.base + "/StudentLocation/\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Client functions
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: LoginData(username: username, password: password))
        let headers: [String: String] = [HttpKeys.acceptHeader.value: HttpKeys.json.value,
                                         HttpKeys.contentTypeHeader.value: HttpKeys.json.value]

        HttpUtil.taskForHttpRequest(url: Endpoints.session.url, method: .POST, headers: headers, body: body, responseType: SessionResponse.self, skipSize: skipSize) { (response, error) in
                            
            guard let responseObject = response else {
                completion(false, error)
                return
            }

            Auth.accountId = responseObject.account.key
            Auth.sessionId = responseObject.session.id
            completion(responseObject.account.registered, nil)
        }
    }
    
    class func logout(completion: @escaping (Error?) -> Void) {
        let xsrfCookie: HTTPCookie? = HttpUtil.getXsrfCookie()
        var headers: [String: String] = [:]
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        let body: EmptyBody? = nil
        
        HttpUtil.taskForHttpRequest(url: Endpoints.session.url, method: .DELETE, headers: headers, body: body, responseType: LogoutResponse.self, skipSize: skipSize) { (response, error) in
                            
            guard let _ = response else {
                completion(error)
                return
            }

            setAuthData(accountId: nil, sessionId: nil, firstName: nil, lastName: nil)
            completion(nil)
        }
    }
    
    // get the accountId
    class func getUserData(completion: @escaping (UserData?, Error?) -> Void) {
        let body: EmptyBody? = nil

        HttpUtil.taskForHttpRequest(url: Endpoints.userData(userId: Auth.accountId).url, method: .GET, headers: nil, body: body, responseType: UserData.self, skipSize: skipSize) { (response, error) in
                            
            guard let responseObject = response else {
                completion(nil, error)
                return
            }
            
            Auth.firstName = responseObject.firstName
            Auth.lastName = responseObject.lastName
            
            completion(responseObject, nil)
        }
    }
    
    // get lasts locations
    class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        let body: EmptyBody? = nil
        HttpUtil.taskForHttpRequest(url: Endpoints.studentLocations(orderBy: "-updatedAt", limitSize: 100).url,
                                    method: .GET, headers: nil, body: body, responseType: StudentLocations.self,
                                    skipSize: nil) { (response, error) in
            guard let responseObject = response else {
                completion([], error)
                return
            }
                                        
            completion(responseObject.results, nil)
        }
    }
    
    // get location added by the user
    class func getStudentLocationById(completion: @escaping (StudentInformation?, Error?) -> Void) {
        let body: EmptyBody? = nil
        HttpUtil.taskForHttpRequest(url: Endpoints.studentLocation(userId: Auth.accountId).url,
                                    method: .GET, headers: nil, body: body,
                                    responseType: StudentLocations.self, skipSize: nil) { (response, error) in
            guard let responseObject = response else {
                completion(nil, error)
                return
            }
            if responseObject.results.count == 0 {
                completion(nil, nil)
            }
                                        
            completion(responseObject.results[0], nil)
        }
    }
    
    // add location for the user
    class func addStudentLocation(request: RequestDto, completion: @escaping (ErrorResponse?) -> Void) {
        let headers: [String: String] = [HttpKeys.contentTypeHeader.value: HttpKeys.json.value]
        let studentLocation = StudentLocationRequest(firstName: Auth.firstName, lastName: Auth.lastName,
                                                     latitude: request.latitude, longitude: request.longitude,
                                                     mapString: request.locationMap, mediaURL: request.mediaURL,
                                                     uniqueKey: Auth.accountId)
        HttpUtil.taskForHttpRequest(url: Endpoints.addStudentLocation.url, method: .POST, headers: headers, body: studentLocation, responseType: AddStudentResponse.self, skipSize: nil) { (response, error) in
                                       
            guard let responseObject = response else {
                completion(ErrorResponse(status: -2, error: error?.localizedDescription ?? "Something wrong happened"))
               return
            }
            
            if responseObject.objectId.count == 0 {
                completion(ErrorResponse(status: -1, error: "Object not created"))
                return
            }
            
            completion(nil)
        }
    }
    
    // update location for the user
    class func updateStudentLocation(request: RequestDto, completion: @escaping (ErrorResponse?) -> Void) {
        
        let headers: [String: String] = [HttpKeys.contentTypeHeader.value: HttpKeys.json.value]

        let studentLocation = StudentLocationRequest(firstName: Auth.firstName, lastName: Auth.lastName,
                                                     latitude: request.latitude, longitude: request.longitude,
                                                     mapString: request.locationMap, mediaURL: request.mediaURL,
                                                     uniqueKey: Auth.accountId)
        
        HttpUtil.taskForHttpRequest(url: Endpoints.updateStudentLocation(objectId: request.objectId!).url,
                                    method: .PUT, headers: headers, body: studentLocation,
                                    responseType: UpdateStudentResponse.self, skipSize: nil) {(response, error) in
                                       
           guard let responseObject = response else {
               completion(ErrorResponse(status: -2, error: error?.localizedDescription ?? "Something wrong happened"))
               return
           }
    
           if responseObject.updatedAt.count == 0 {
               completion(ErrorResponse(status: -1, error: "Object not updated"))
               return
           }
                       
           completion(nil)
       }
    }
    
    class func setAuthData(accountId: String?, sessionId: String?, firstName: String?, lastName: String?) {
        Auth.accountId = accountId ?? ""
        Auth.sessionId = sessionId ?? ""
        Auth.firstName = firstName ?? ""
        Auth.lastName = lastName ?? ""
    }
}
