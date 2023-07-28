//
//  FortsSecurity.swift
//  hwSB303
//
//  Created by serg on 11.07.2023.
//

import Foundation

enum DateTimeFormats: String {
    case Date = "yyyy-MM-dd"
    case DateTime = "yyyy-MM-dd HH:mm:ss"
    case Time = "HH:mm:ss"
    
    static func toDateTime(_ container: inout UnkeyedDecodingContainer, format: Self) throws -> Date? {
        let tmpStr = try container.decode(String?.self)
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier:"Europe/Moscow")
        df.dateFormat = format.rawValue
        return df.date(from: tmpStr ?? "")
    }
}

struct AllFortsSecResponse: Decodable {
    let securities: FortsSecurityDate
    let marketdata: FortsMarketData
}

struct FortsSecurityDate: Decodable {
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
        
        imtime = try DateTimeFormats.toDateTime(&container, format: .DateTime)
        
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
        
        updatetime = try DateTimeFormats.toDateTime(&container, format: .Time)
        
        lastchangeprcnt = try container.decode(Double?.self)
        biddepth = try container.decode(Double?.self)
        biddeptht = try container.decode(Double?.self)
        numbids = try container.decode(Double?.self)
        offerdepth = try container.decode(Double?.self)
        offerdeptht = try container.decode(Double?.self)
        numoffers = try container.decode(Double?.self)
        
        time = try DateTimeFormats.toDateTime(&container, format: .Time)
        
        settletoprevsettleprc = try container.decode(Double?.self)
        seqnum = try container.decode(Int64?.self)
        
        systime = try DateTimeFormats.toDateTime(&container, format: .DateTime)
        tradedate = try DateTimeFormats.toDateTime(&container, format: .DateTime)
        
        lasttoprevprice = try container.decode(Double?.self)
        oichange = try container.decode(Int64?.self)
        openperiodprice = try container.decode(Double?.self)
        swaprate = try container.decode(Double?.self)
    }
}
