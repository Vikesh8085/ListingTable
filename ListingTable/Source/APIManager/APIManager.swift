//
//  APIManager.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
   private let cacheKey = "KEXPIREDATE"
   private let expiration : Double = -900
    
    func fetchData(completionHandler: @escaping (NetworkResult) -> Void) {
        
//        guard let link = URL(string:APIService.listing.url) else {return}
        
        
        self.makeAPICall(urlString: APIService.listing.url) { (data, response) in
            if let statusCode = response?.statusCode,
                let httpStatusCode = HTTPStatusCodes(rawValue: statusCode) {
                switch httpStatusCode {
                case HTTPStatusCodes.success:
                    if let d = data as? Data, let obj = try? JSONDecoder().decode(ListingModel.self, from: d) {
                        if obj.success {
                            completionHandler(NetworkResult.success(obj.data))
                        }
                    }
                case HTTPStatusCodes.tooManyRequests:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.tooManyRequests, title: "429", subTitle: "Too many requests"))
                case HTTPStatusCodes.notFound:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.notFound, title: "404", subTitle: "Not Found"))
                case HTTPStatusCodes.unAvailable:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.unAvailable, title: "503", subTitle: "Un Available"))
                }
            }
        
        
//        URLSession.shared.dataTask(with: link) { (data, response, error) in
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                let httpStatusCode = HTTPStatusCodes(rawValue: statusCode) {
//                switch httpStatusCode {
//                case HTTPStatusCodes.success:
//                    if let d = data, let obj = try? JSONDecoder().decode(ListingModel.self, from: d) {
//                        if obj.success {
//                          completionHandler(NetworkResult.success(obj.data))
//                        }
//                    }
//                case HTTPStatusCodes.tooManyRequests:
//                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.tooManyRequests, title: "429", subTitle: "Too many requests"))
//                case HTTPStatusCodes.notFound:
//                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.notFound, title: "404", subTitle: "Not Found"))
//                case HTTPStatusCodes.unAvailable:
//                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.unAvailable, title: "503", subTitle: "Un Available"))
//                }
//            }
//        }.resume()
    }
    }
    
    func fetchDetail(id: String, completionHandler: @escaping (NetworkResult) -> Void) {
                
        self.makeAPICall(urlString: APIService.detail(id).url) { (data, response) in
            if let statusCode = response?.statusCode,
                let httpStatusCode = HTTPStatusCodes(rawValue: statusCode) {
                switch httpStatusCode {
                case HTTPStatusCodes.success:
                    if let d = data as? Data, let obj = try? JSONDecoder().decode(ContentDetail.self, from: d) {
                        if obj.success {
                            completionHandler(NetworkResult.successDetail(obj))
                        }
                    }
                case HTTPStatusCodes.tooManyRequests:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.tooManyRequests, title: "429", subTitle: "Too many requests"))
                case HTTPStatusCodes.notFound:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.notFound, title: "404", subTitle: "Not Found"))
                case HTTPStatusCodes.unAvailable:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.unAvailable, title: "503", subTitle: "Un Available"))
                }
            }
        }
    }
    
        
//        URLSession.shared.dataTask(with: link) { (data, response, error) in
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                let httpStatusCode = HTTPStatusCodes(rawValue: statusCode) {
//                switch httpStatusCode {
//                case HTTPStatusCodes.success:
//                    if let d = data, let obj = try? JSONDecoder().decode(ContentDetail.self, from: d) {
//                        if obj.success {
//                            completionHandler(NetworkResult.successDetail(obj))
//                        }
//                    }
//                case HTTPStatusCodes.tooManyRequests:
//                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.tooManyRequests, title: "429", subTitle: "Too many requests"))
//                case HTTPStatusCodes.notFound:
//                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.notFound, title: "404", subTitle: "Not Found"))
//                case HTTPStatusCodes.unAvailable:
//                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.unAvailable, title: "503", subTitle: "Un Available"))
//                }
//            }
//        }.resume()
    
}

extension APIManager {
        
    func makeAPICall(urlString:String, completion:@escaping ((Any?,HTTPURLResponse?)->Void))   {
        
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 100)
        request.httpMethod = "GET"
        
        self.makeAPICallWithRequest(request: request, completion: completion)
        
    }
    
    func makeAPICallWithRequest(request:URLRequest, completion:@escaping ((Any?,HTTPURLResponse?)->Void))
    {
        self.checkCacheResponse(urlRequest: request) { (cachedResponse) in
            if let response = cachedResponse
            {
//                let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data, options: [])
//                completion(jsonDictionary, response.response as? HTTPURLResponse)
                completion(response.data, response.response as? HTTPURLResponse)

                
                DispatchQueue.global(qos: .background).async {
                    self.cacheTask(request)
                }
            }
            else
            {
                self.cacheTask(request, completion: { (cachedResponse) in
                    if let response = cachedResponse
                    {
//                        let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data, options: [])
//                        completion(jsonDictionary, response.response as? HTTPURLResponse)
                        completion(response.data, response.response as? HTTPURLResponse)
                    }
                    else
                    {
                        completion(nil, cachedResponse?.response as? HTTPURLResponse)
                    }
                })
            }
        }
    }
    
    func checkCacheResponse(urlRequest:URLRequest, completion:@escaping ((CachedURLResponse?)->Void))
    {
        if let cacheResponse = URLCache.shared.cachedResponse(for: urlRequest), let userInfo = cacheResponse.userInfo,let cachedDate = userInfo[cacheKey] as? Date, cachedDate.timeIntervalSinceNow > expiration
        {
            DispatchQueue.main.async {
                completion(cacheResponse)
            }
        }
        else
        {
            if let cacheResponse = URLCache.shared.cachedResponse(for: urlRequest), let userInfo = cacheResponse.userInfo,let cachedDate = userInfo[cacheKey] as? Date, cachedDate.timeIntervalSinceNow < expiration
            {
                URLCache.shared.removeCachedResponse(for: urlRequest)
            }
            
            completion(nil)
        }
    }
       
    func cacheTask(_ request: URLRequest, completion: ((CachedURLResponse?)->Void)? = nil) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let _ = error {
                    completion?(nil)
                }
                else if let data = data {
                    if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                        
                        let cacheResponse = CachedURLResponse(response: response, data: data)
                        var userInfo = cacheResponse.userInfo ?? [:]
                        userInfo[self.cacheKey] = Date()
                        let newCacheResponse = CachedURLResponse(response: cacheResponse.response, data: cacheResponse.data, userInfo: userInfo, storagePolicy: cacheResponse.storagePolicy)
                        URLCache.shared.storeCachedResponse(newCacheResponse, for: request)
                        completion?(newCacheResponse)
                    }
                    else
                    {
                        completion?(nil)
                    }
                }
            }
        }.resume()
    }
    
   private func getCachesURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func setCache() {
        var cacheURL = self.getCachesURL()
        var resourceValue = URLResourceValues()
        resourceValue.isExcludedFromBackup = true
        do {
            try cacheURL.setResourceValues(resourceValue)
        }
        catch {
            
        }
    }
    
}

enum APIService {
    
    case listing
    case detail(String)
    
    var url : String {
        let baseURL = APIManagerConstant.baseUrl
        let timeStamp = String(describing: Date().timeStamp ?? 0)        
        switch self {
        case .listing:
            return baseURL + APIEndPoint.listing + "?timestamp=\(timeStamp)"
        case .detail(let id):
            return baseURL + APIEndPoint.detail + "?roomId=\(id)" + "&timestamp=\(timeStamp)"
        }
    }
}
