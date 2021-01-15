//
//  DataCenter.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/14.
//

import UIKit
import SQLite

/// DB record
struct CacheRecord {
    var id: Int64
    var startTime: Int64
    var endTime: Int64
    var errorCode: Int
    var statusCode: Int
    var rawString: String
}

/// Management class for cached data
class DataCenter: NSObject {
    // singleton object
    public static let shared: DataCenter = DataCenter()

    // indicate if the fetching service is running
    private var isRunning = false

    /// DB connection
    private var db: Connection? = nil
    
    /// Table to store cache
    private let cacheTable = Table("cache")

    /// id to start Request
    private let id = Expression<Int64>("id")
    /// Time to start Request
    private let startTime = Expression<Int64>("startTime")
    /// Time to write into DB
    private let endTime = Expression<Int64>("endTime")
    /// Error Code
    private let errorCode = Expression<Int>("errorCode")
    /// Status Code
    private let statusCode = Expression<Int>("statusCode")
    /// Result
    private let rawString = Expression<String>("rawResult")
    
    // prevent from generating object except `shared`
    private override init() {
        super.init()
    }

    /// Start fo fetching data from endpoint
    func startFetch() -> Void {
        // prevent from starting repeatedly
        guard isRunning == false else {
            return
        }
        
        isRunning = true
        // initial database
        initDB()
        
        // start fetching data
        fetch()
    }
    
    /// fetch data from endpoint of Github and store this data into cache database,
    /// then post notification `githubCacheChanged` to notify other observer
    ///
    /// This function fetches data every 5 seconds.
    ///
    func fetch() -> Void {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5, execute: {
            self.fetch()
            
            let startTime = Int64(Date().timeIntervalSince1970 * 1000)
            GithubNetworkOperation.shared.visitEndpoint { [weak self] (error, dict) in
                guard let self = self else {
                    return
                }
                
                defer {
                    NotificationCenter.default.post(name: .githubCacheChanged, object: nil)
                }
                
                let endTime = Int64(Date().timeIntervalSince1970 * 1000)
                
                guard error == nil else {
                    
                    let err = error! as NSError
                    var statusCode = 0
                    if let code = err.userInfo["statusCode"] as? Int {
                        statusCode = code
                    }
                    var message = err.localizedDescription
                    if let str = err.userInfo["message"] as? String {
                        message = str
                    }
                    
                    // insert failure record
                    self.insertCache(record: CacheRecord(id: 0,
                                                         startTime: startTime,
                                                         endTime: endTime,
                                                         errorCode: err.code,
                                                         statusCode: statusCode,
                                                         rawString: message))
                    return
                }
                
                if let data = try? JSONSerialization.data(withJSONObject: dict!, options: []), let raw = String(data: data, encoding: .utf8) {
                    // insert cached record
                    self.insertCache(record: CacheRecord(id: 0,
                                                         startTime: startTime,
                                                         endTime: endTime,
                                                         errorCode: 0,
                                                         statusCode: 0,
                                                         rawString: raw))
                }
            }
        })
    }
}

// MARK: DB Operation
extension DataCenter {

    /// Initial the cache database
    @discardableResult
    func initDB() -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        guard let db = try? Connection("\(path)/cache.sqlite3") else {
            return false
        }
        
        do {
            try db.run(cacheTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(startTime)
                t.column(endTime)
                t.column(errorCode)
                t.column(statusCode)
                t.column(rawString)
            })
            
            self.db = db
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    /// Insert cached record to database
    /// 
    /// - parameter record:     cache information
    ///
    /// - returns: true: successful, false: failure
    @discardableResult
    func insertCache(record: CacheRecord) -> Bool {
        guard let db = self.db else {
            return false
        }
        
        do {
            try db.run(cacheTable.insert(self.startTime <- record.startTime,
                                         self.endTime <- record.endTime,
                                         self.errorCode <- record.errorCode,
                                         self.statusCode <- record.statusCode,
                                         self.rawString <- record.rawString) )
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    /// return total of cached records
    ///
    /// - returns: total of cached records
    func totalOfRecords() -> Int {
        if let count = try? db?.scalar(cacheTable.count) {
            return count
        } else {
            return 0
        }
    }
    
    /// return latest record
    ///
    /// - returns: latest record
    func latestRecord() -> CacheRecord? {
        guard let db = self.db else {
            return nil
        }
        
        let query = cacheTable.order(id.desc)
        
        if let recordRow = try? db.pluck(query) {
            return CacheRecord(id: recordRow[id],
                               startTime: recordRow[startTime],
                               endTime: recordRow[endTime],
                               errorCode: recordRow[errorCode],
                               statusCode: recordRow[statusCode],
                               rawString: recordRow[rawString])
        }
        
        return nil
    }
    
    /// return latest record
    ///
    /// - parameter limit:     page size
    /// - parameter offset:    start point of returned first record
    /// - parameter topID:     base ID, prevent from returning repeat records.
    ///
    ///    **For example**
    ///    limit = 4, offset = 0
    ///    first got records ids
    ///     20, 19, 18,17
    ///    before you get next page, there insert new records, ids is 22, 21.
    ///    if you don't specify the topID, you will records that's ids:
    ///      18, 17, 16, 15
    ///    Among them, 18, 17 is repeated. if you specify the topID == 20, you will get records.
    ///      16,15,14,13
    ///
    /// - returns: return records
    func records(limit: Int = 20, offset: Int = 0, topID: Int64 = Int64.max) -> [CacheRecord] {
        guard let db = self.db else {
            return []
        }
        
        let page = cacheTable.limit(limit, offset: offset).order(id.desc).filter(id <= topID)
        
        do {
            var array: [CacheRecord] = []
            for item in try db.prepare(page) {
                array.append(CacheRecord(id: item[id],
                                         startTime: item[startTime],
                                         endTime: item[endTime],
                                         errorCode: item[errorCode],
                                         statusCode: item[statusCode],
                                         rawString: item[rawString]))
            }
            
            return array
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
