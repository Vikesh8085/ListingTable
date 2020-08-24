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
   private let timeStampKey = "TimeStamp"
   private let cacheKey = "KEXPIREDATE"
   private let expiration : Double = -900
    
    func fetchData(completionHandler: @escaping (NetworkResult) -> Void) {
        
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
                case HTTPStatusCodes.badrequest:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.badrequest, title: HTTPError.errorCode.rawValue, subTitle: HTTPError.errorMessage.rawValue))
                }
            }
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
                case HTTPStatusCodes.badrequest:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.badrequest, title: HTTPError.errorCode.rawValue, subTitle: HTTPError.errorMessage.rawValue))
                }
            }
        }
    }
}

extension APIManager {
        
   private func makeAPICall(urlString:String, completion:@escaping ((Any?,HTTPURLResponse?)->Void))   {
        
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        print(url)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 100)
        request.httpMethod = "GET"
        
        self.makeAPICallWithRequest(request: request, completion: completion)
        
    }
    
   private func makeAPICallWithRequest(request:URLRequest, completion:@escaping ((Any?,HTTPURLResponse?)->Void))
    {
        self.checkCacheResponse(urlRequest: request) { (cachedResponse) in
            if let response = cachedResponse
            {
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
    
  private func checkCacheResponse(urlRequest:URLRequest, completion:@escaping ((CachedURLResponse?)->Void))
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
       
   private func cacheTask(_ request: URLRequest, completion: ((CachedURLResponse?)->Void)? = nil) {
        
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
    
    func saveTimeStamp(timeStamp: String) {
        UserDefaults.standard.set(timeStamp, forKey: timeStampKey)
        UserDefaults.standard.synchronize()
    }
    
    func getLastTimeStamp() -> String {
        if let time = UserDefaults.standard.value(forKey: timeStampKey) as? String {
            return time
        }
        return ""
    }
    
    func getTimeStamp() -> String {
        var timeStamp = String(describing: Date().timeStamp ?? 0)
        if !ReachabilityWrapper.shared.isNetworkAvailable() {
            timeStamp = APIManager.shared.getLastTimeStamp()
        } else {
            APIManager.shared.saveTimeStamp(timeStamp: timeStamp)
        }
        print("timesssss\(timeStamp)")
        return timeStamp
    }
}

enum APIService {
    
    case listing
    case detail(String)
    
    var url : String {
        let baseURL = APIManagerConstant.baseUrl
        let timeStamp = APIManager.shared.getTimeStamp()
        switch self {
        case .listing:
            return baseURL + APIEndPoint.listing + "?timestamp=\(timeStamp)"
        case .detail(let id):
            return baseURL + APIEndPoint.detail + "?roomId=\(id)" + "&timestamp=\(timeStamp)"
        }
    }
}
