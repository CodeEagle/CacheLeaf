//
//  CacheLeaf.swift
//  CacheLeaf
//
//  Created by LawLincoln on 2016/9/19.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Foundation
import Alamofire
public extension URLConvertible {
    /// execute url for data
    ///
    /// - parameter cache:  duraton for caching result
    /// - parameter ignoreExpires: return cache ignore expires
    /// - parameter requestAnyway: do request no matter has cache or not
    ///  - parameter log: print response
    /// - parameter canCache: a closure return Bool to judge whether the result should cache or not
    /// - parameter completion: requet Done
    ///
    /// - returns: DataRequest?
    @discardableResult public func execute(cache maxAge: TimeInterval = 0, ignoreExpires: Bool = false, requestAnyway: Bool = true, requestWithoutCacheTrigger callBack: @escaping () -> Void = {}, log: Bool = false, sessionManager: SessionManager = SessionManager.default, canCache closure: ((_ result: Result<Data>) -> Bool)? = nil, executor: ((URLRequest, @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?)-> Void) -> Void)? = nil, completion handler: @escaping (_ result: Result<Data>) -> Void = { _ in }) -> DataRequest? {
        do {
            let url = try asURL()
            let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            return req.execute(cache: maxAge, ignoreExpires: ignoreExpires, requestAnyway: requestAnyway, requestWithoutCacheTrigger: callBack, log: log, sessionManager: sessionManager, canCache: closure, executor: executor, completion: handler)
        } catch { return nil }
    }
}

public extension URLRequestConvertible {

    /// execute url for data
    ///
    /// - parameter cache:  duraton for caching result
    /// - parameter ignoreExpires: return cache ignore expires
    /// - parameter requestAnyway: do request no matter has cache or not
    /// - parameter log: print response
    /// - parameter canCache: a closure return Bool to judge whether the result should cache or not
    /// - parameter completion: requet Done
    ///
    /// - returns: DataRequest?

    @discardableResult public func execute(cache maxAge: TimeInterval = 0, ignoreExpires: Bool = false, requestAnyway: Bool = true, requestWithoutCacheTrigger callBack: @escaping () -> Void = {}, log: Bool = false, sessionManager: SessionManager = SessionManager.default, canCache closure: ((_ result: Result<Data>) -> Bool)? = nil, executor: ((URLRequest, @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?)-> Void) -> Void)? = nil, completion handler: @escaping (_ result: Result<Data>) -> Void = { _ in }) -> DataRequest? {
        guard var urlReq = urlRequest else { return nil }
        urlReq.ll_max_age = maxAge
        var cacheHash = 0
        
        var req: DataRequest? = nil
        
        func goGetData() {
            if let exe = executor {
                exe(urlReq, { (request, response, data, error) in
                    if log, let resp = response { print("🚦", resp) }
                    var dataHash = 0
                    if let err = error { handler(.failure(err)) }
                    else if let resp = response, let data = data, let req = request {
                        dataHash = data.description.hash
                        let dat: Result<Data> = Result.success(data)
                        if let cacheConfigClosure = closure { if cacheConfigClosure(dat) { req.ll_storeResponse(maxAge, resp: resp, data: data) } }
                        else { req.ll_storeResponse(maxAge, resp: resp, data: data) }
                        if dataHash != cacheHash && dataHash != 0 { DispatchQueue.main.async { handler(dat) } }
                    }
                })
            } else {
                req = sessionManager.request(urlReq)
                req?.response { (result: DefaultDataResponse) in
                    if log, let resp = result.response { print("🚦", resp) }
                    var dataHash = 0
                    if let err = result.error { handler(.failure(err)) }
                    else if let resp = result.response, let data = result.data, let req = result.request {
                        dataHash = data.description.hash
                        let dat: Result<Data> = Result.success(data)
                        if let cacheConfigClosure = closure { if cacheConfigClosure(dat) { req.ll_storeResponse(maxAge, resp: resp, data: data) } }
                        else { req.ll_storeResponse(maxAge, resp: resp, data: data) }
                        if dataHash != cacheHash && dataHash != 0 { DispatchQueue.main.async { handler(dat) } }
                    }
                }
                req?.resume()
            }
        }
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            if maxAge == 0 {
                callBack()
                goGetData()
            } else {
                if let data = urlReq.ll_lastCachedResponseDataIgnoreExpires(ignoreExpires) {
                    if closure?(Result.success(data)) == true {
                        cacheHash = data.description.hash
                        DispatchQueue.main.async {
                            handler(.success(data))
                        }
                    }
                    if requestAnyway && ignoreExpires &&
                        urlReq.ll_lastCachedResponseDataIgnoreExpires(false) == nil {
                        goGetData()
                    }
                } else {
                    callBack()
                    goGetData()
                }
            }
        }
        return req
    }
}

private extension String {
    var date: Date! {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(abbreviation: "GMT")
        return fmt.date(from: self)
    }
}

private extension Foundation.URLRequest {

    private struct AssociatedKeys { static var MaxAge = "MaxAge" }
    var ll_max_age: TimeInterval {
        get { return (objc_getAssociatedObject(self, &AssociatedKeys.MaxAge) as? TimeInterval) ?? 0 }
        set(max) { objc_setAssociatedObject(self, &AssociatedKeys.MaxAge, max, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func ll_storeResponse(_: TimeInterval, resp: HTTPURLResponse?, data: Data?) {
        guard let response = resp, let url = response.url, let header = response.allHeaderFields as? [String: String], let data = data, let re = HTTPURLResponse(url: url, statusCode: response.statusCode, httpVersion: nil, headerFields: header) else { return }
        let cachedResponse = CachedURLResponse(response: re, data: data, userInfo: nil, storagePolicy: URLCache.StoragePolicy.allowed)
        URLCache.shared.storeCachedResponse(cachedResponse, for: self)
    }

    func ll_lastCachedResponseDataIgnoreExpires(_ ignoreExpires: Bool = true) -> Data? {
        let response = URLCache.shared.cachedResponse(for: self)
        if ignoreExpires { return response?.data }
        let now = Date()
        var data: Data!
        guard let resp = response?.response as? HTTPURLResponse, let dateString = resp.allHeaderFields["Date"] as? String, let dateExpires = dateString.date else { return data }
        let expires = dateExpires.addingTimeInterval(ll_max_age)
        if now.compare(expires) == .orderedAscending { data = response?.data }
        return data
    }
}
