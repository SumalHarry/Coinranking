//
//  GetCoinModel.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Gloss

// MARK: - GetCoinsModel
struct GetCoinsModel: JSONDecodable {
    let status: String
    let data: GetCoinsDataClass?
    
    init?(json: JSON) {
        guard let status : String = "status" <~~ json else {
            return nil
        }
        self.status = status
        self.data = "data" <~~ json
    }
}

// MARK: - DataClass
struct GetCoinsDataClass: JSONDecodable {
    let stats: GetCoinsStats?
    let coins: [GetCoinsCoin]?

    init?(json: JSON) {
        self.stats = "stats" <~~ json
        self.coins = "coins" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "stats" ~~> self.stats,
            "coins" ~~> self.coins,
        ])
    }
}

// MARK: - Coin
struct GetCoinsCoin: JSONDecodable {
    let uuid: String?
    let symbol: String?
    let name: String?
    let color: String?
    let iconUrl: String?
    let marketCap: String?
    let price: String?
    let listedAt: Int?
    let tier: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String]?
    let lowVolume: Bool?
    let coinrankingUrl: String?
    let the24HVolume: String?
    let btcPrice: String?

    init?(json: JSON) {
        self.uuid = "uuid" <~~ json
        self.symbol = "symbol" <~~ json
        self.name = "name" <~~ json
        self.color = "color" <~~ json
        self.iconUrl = "iconUrl" <~~ json
        self.marketCap = "marketCap" <~~ json
        self.price = "price" <~~ json
        self.listedAt = "listedAt" <~~ json
        self.tier = "tier" <~~ json
        self.change = "change" <~~ json
        
        self.rank = "rank" <~~ json
        self.sparkline = "sparkline" <~~ json
        self.lowVolume = "lowVolume" <~~ json
        self.coinrankingUrl = "coinrankingUrl" <~~ json
        self.the24HVolume = "the24HVolume" <~~ json
        self.btcPrice = "btcPrice" <~~ json
    }
}

// MARK: - Stats
struct GetCoinsStats: JSONDecodable {
    let totalData: Int?
    let referenceCurrencyRate: Int?
    let totalCoins: Int?
    let totalMarkets: Int?
    let totalExchanges: Int?
    let totalMarketCap: String?
    let total24HVolume: String?
    let btcDominance: Double?
    let bestCoins: [GetCoinsEstCoin]?
    let newestCoins: [GetCoinsEstCoin]?

    init?(json: JSON) {
        self.totalData = "total" <~~ json
        self.referenceCurrencyRate = "referenceCurrencyRate" <~~ json
        self.totalCoins = "totalCoins" <~~ json
        self.totalMarkets = "totalMarkets" <~~ json
        self.totalExchanges = "totalExchanges" <~~ json
        self.totalMarketCap = "totalMarketCap" <~~ json
        self.total24HVolume = "total24HVolume" <~~ json
        self.btcDominance = "btcDominance" <~~ json
        self.bestCoins = "bestCoins" <~~ json
        self.newestCoins = "newestCoins" <~~ json
    }
}

// MARK: - EstCoin
struct GetCoinsEstCoin: JSONDecodable {
    let uuid: String?
    let symbol: String?
    let name: String?
    let iconUrl: String?
    let coinrankingUrl: String?
    
    init?(json: JSON) {
        self.uuid = "uuid" <~~ json
        self.symbol = "symbol" <~~ json
        self.name = "name" <~~ json
        self.iconUrl = "iconUrl" <~~ json
        self.coinrankingUrl = "coinrankingUrl" <~~ json
    }
}



