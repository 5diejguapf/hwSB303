//
//  FortsSecurity.swift
//  hwSB303
//
//  Created by serg on 11.07.2023.
//

import Foundation

enum DateTimeFormats: String {
    case date = "yyyy-MM-dd"
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case time = "HH:mm:ss"
    
    static private func dateWithTZ(from: String?, format: Self) -> Date? {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier:"Europe/Moscow")
        df.dateFormat = format.rawValue
        return df.date(from: from ?? "")
    }    
    
    static func toDateTime(_ container: inout UnkeyedDecodingContainer, format: Self) throws -> Date? {
        let tmpStr = try container.decode(String?.self)
        return dateWithTZ(from: tmpStr, format: format)
    }
    
    static func toDateTime(_ from: Any?, format: Self) -> Date? {
        let tmpStr = from as? String
        return dateWithTZ(from: tmpStr, format: format)
    }
}

struct AllFortsSecResponse: Decodable {
    let securities: FortsSecurityData
    let marketdata: FortsMarketData
    
    init(from: Any) {
        let issData = from as? [String: Any] ?? [:]
        
        let securities = issData["securities"] as? [String: Any] ?? [:]
        let secColumns = securities["columns"] as? [String] ?? []
        let secData = securities["data"] as? [[Any]] ?? []
        
        var securitiesInfo: [IssFortsSecurityInfo] = []
        for security in secData {
            do {
                let secDict = Dictionary( uniqueKeysWithValues: zip(secColumns.map { $0.lowercased() }, security ))
                let secInfo = try IssFortsSecurityInfo(from: secDict)
                securitiesInfo.append(secInfo)
            } catch {
                print(error)
            }
        }
        self.securities = FortsSecurityData(data: securitiesInfo)
        
        let marketdata = issData["marketdata"] as? [String: Any] ?? [:]
        let marketColumns = marketdata["columns"] as? [String] ?? []
        let markData = marketdata["data"] as? [[Any]] ?? []

        var marketInfos: [IssFortsMarketInfo] = []
        for market in markData {
            do {
                let marketDict = Dictionary( uniqueKeysWithValues: zip(marketColumns.map { $0.lowercased() }, market ))
                let marketInfo = try IssFortsMarketInfo(from: marketDict)
                marketInfos.append(marketInfo)
            } catch {
                print(error)
            }
        }
        
        self.marketdata = FortsMarketData(data: marketInfos)
    }
}

struct FortsSecurityData: Decodable {
    let data: [IssFortsSecurityInfo]
}

struct FortsMarketData: Decodable {
    let data: [IssFortsMarketInfo]
}

struct IssFortsSecurityInfo: Decodable {
    let secid: String?
    let boardid: String?
    let shortname: String?
    let secname: String?
    let prevsettleprice: Double?
    let decimals: Int32?
    let minstep: Double?
    let lasttradedate: Date?
    let lastdeldate: Date?
    let sectype: String?
    let latname: String?
    let assetcode: String?
    let prevopenposition: Int64?
    let lotvolume: Int32?
    let initialmargin: Double?
    let highlimit: Double?
    let lowlimit: Double?
    let stepprice: Double?
    let lastsettleprice: Double?
    let prevprice: Double?
    let imtime: Date?
    let buysellfee: Double?
    let scalperfee: Double?
    let negotiatedfee: Double?
    let exercisefee: Double?
    
    init(from: [String: Any]) throws {
        secid = from["secid"] as? String
        boardid = from["boardid"] as? String
        shortname = from["shortname"] as? String
        secname = from["secname"] as? String
        prevsettleprice = from["prevsettleprice"] as? Double
        decimals = from["decimals"] as? Int32
        minstep = from["minstep"] as? Double
        lasttradedate = from["lasttradedate"] as? Date
        lastdeldate = from["lastdeldate"] as? Date
        sectype = from["sectype"] as? String
        latname = from["latname"] as? String
        assetcode = from["assetcode"] as? String
        prevopenposition = from["prevopenposition"] as? Int64
        lotvolume = from["lotvolume"] as? Int32
        initialmargin = from["initialmargin"] as? Double
        highlimit = from["highlimit"] as? Double
        lowlimit = from["lowlimit"] as? Double
        stepprice = from["stepprice"] as? Double
        lastsettleprice = from["lastsettleprice"] as? Double
        prevprice = from["prevprice"] as? Double
        imtime = DateTimeFormats.toDateTime(from["imtime"], format: .dateTime)
        buysellfee = from["buysellfee"] as? Double
        scalperfee = from["scalperfee"] as? Double
        negotiatedfee = from["negotiatedfee"] as? Double
        exercisefee = from["exercisefee"] as? Double
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        secid = try container.decode(String?.self)
        boardid = try container.decode(String?.self)
        shortname = try container.decode(String?.self)
        secname = try container.decode(String?.self)
        prevsettleprice = try container.decode(Double?.self)
        decimals = try container.decode(Int32?.self)
        minstep = try container.decode(Double?.self)
        lasttradedate = try container.decode(Date?.self)
        lastdeldate = try container.decode(Date?.self)
        sectype = try container.decode(String?.self)
        latname = try container.decode(String?.self)
        assetcode = try container.decode(String?.self)
        prevopenposition = try container.decode(Int64?.self)
        lotvolume = try container.decode(Int32?.self)
        initialmargin = try container.decode(Double?.self)
        highlimit = try container.decode(Double?.self)
        lowlimit = try container.decode(Double?.self)
        stepprice = try container.decode(Double?.self)
        lastsettleprice = try container.decode(Double?.self)
        prevprice = try container.decode(Double?.self)
        
        imtime = try DateTimeFormats.toDateTime(&container, format: .dateTime)
        
        buysellfee = try container.decode(Double?.self)
        scalperfee = try container.decode(Double?.self)
        negotiatedfee = try container.decode(Double?.self)
        exercisefee = try container.decode(Double?.self)
    }
}


struct IssFortsMarketInfo: Decodable {
    let secid: String?
    let boardid: String?
    let bid: Double?
    let offer: Double?
    let spread: Double?
    let open: Double?
    let high: Double?
    let low: Double?
    let last: Double?
    let quantity: Int32?
    let lastchange: Double?
    let settleprice: Double?
    let settletoprevsettle: Double?
    let openposition: Double?
    let numtrades: Int32?
    let voltoday: Int64?
    let valtoday: Int64?
    let valtoday_usd: Int64?
    let updatetime: Date?
    let lastchangeprcnt: Double?
    let biddepth: Double?
    let biddeptht: Double?
    let numbids: Double?
    let offerdepth: Double?
    let offerdeptht: Double?
    let numoffers: Double?
    let time: Date?
    let settletoprevsettleprc: Double?
    let seqnum: Int64?
    let systime: Date?
    let tradedate: Date?
    let lasttoprevprice: Double?
    let oichange: Int64?
    let openperiodprice: Double?
    let swaprate: Double?

    init(from: [String: Any]) throws {
        secid = from["secid"] as? String
        boardid = from["boardid"] as? String
        bid = from["bid"] as? Double
        offer = from["offer"] as? Double
        spread = from["spread"] as? Double
        open = from["open"] as? Double
        high = from["high"] as? Double
        low = from["low"] as? Double
        last = from["last"] as? Double
        quantity = from["quantity"] as? Int32
        lastchange = from["lastchange"] as? Double
        settleprice = from["settleprice"] as? Double
        settletoprevsettle = from["settletoprevsettle"] as? Double
        openposition = from["openposition"] as? Double
        numtrades = from["numtrades"] as? Int32
        voltoday = from["voltoday"] as? Int64
        valtoday = from["valtoday"] as? Int64
        valtoday_usd = from["valtoday_usd"] as? Int64
        updatetime = DateTimeFormats.toDateTime(from["updatetime"], format: .time)
        lastchangeprcnt = from["lastchangeprcnt"] as? Double
        biddepth = from["biddepth"] as? Double
        biddeptht = from["biddeptht"] as? Double
        numbids = from["numbids"] as? Double
        offerdepth = from["offerdepth"] as? Double
        offerdeptht = from["offerdeptht"] as? Double
        numoffers = from["numoffers"] as? Double
        time = DateTimeFormats.toDateTime(from["time"], format: .time)
        settletoprevsettleprc = from["settletoprevsettleprc"] as? Double
        seqnum = from["seqnum"] as? Int64
        systime = DateTimeFormats.toDateTime(from["systime"], format: .dateTime)
        tradedate = DateTimeFormats.toDateTime(from["tradedate"], format: .dateTime)
        lasttoprevprice = from["lasttoprevprice"] as? Double
        oichange = from["oichange"] as? Int64
        openperiodprice = from["openperiodprice"] as? Double
        swaprate = from["swaprate"] as? Double
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        secid = try container.decode(String?.self)
        boardid = try container.decode(String?.self)
        bid = try container.decode(Double?.self)
        offer = try container.decode(Double?.self)
        spread = try container.decode(Double?.self)
        open = try container.decode(Double?.self)
        high = try container.decode(Double?.self)
        low = try container.decode(Double?.self)
        last = try container.decode(Double?.self)
        quantity = try container.decode(Int32?.self)
        lastchange = try container.decode(Double?.self)
        settleprice = try container.decode(Double?.self)
        settletoprevsettle = try container.decode(Double?.self)
        openposition = try container.decode(Double?.self)
        numtrades = try container.decode(Int32?.self)
        voltoday = try container.decode(Int64?.self)
        valtoday = try container.decode(Int64?.self)
        valtoday_usd = try container.decode(Int64?.self)
        
        updatetime = try DateTimeFormats.toDateTime(&container, format: .time)
        
        lastchangeprcnt = try container.decode(Double?.self)
        biddepth = try container.decode(Double?.self)
        biddeptht = try container.decode(Double?.self)
        numbids = try container.decode(Double?.self)
        offerdepth = try container.decode(Double?.self)
        offerdeptht = try container.decode(Double?.self)
        numoffers = try container.decode(Double?.self)
        
        time = try DateTimeFormats.toDateTime(&container, format: .time)
        
        settletoprevsettleprc = try container.decode(Double?.self)
        seqnum = try container.decode(Int64?.self)
        
        systime = try DateTimeFormats.toDateTime(&container, format: .dateTime)
        tradedate = try DateTimeFormats.toDateTime(&container, format: .dateTime)
        
        lasttoprevprice = try container.decode(Double?.self)
        oichange = try container.decode(Int64?.self)
        openperiodprice = try container.decode(Double?.self)
        swaprate = try container.decode(Double?.self)
    }
}
