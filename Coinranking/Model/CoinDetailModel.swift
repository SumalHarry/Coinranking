//
//  CoinDetailModel.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Gloss
//
// MARK: - TestModel
struct CoinDetailModel: JSONDecodable {
    let status: String
    let data: CoinDetailDataClass?

    init?(json: JSON) {
        guard let status : String = "status" <~~ json else {
            return nil
        }
        self.status = status
        self.data = "data" <~~ json
    }
}

// MARK: - DataClass
struct CoinDetailDataClass: JSONDecodable {
    let coin: CoinDetailCoin?

    init?(json: JSON) {
        self.coin = "coin" <~~ json
    }
}

// MARK: - Coin
struct CoinDetailCoin: JSONDecodable {
    let uuid: String?
    let symbol: String?
    let name: String?
    let description: String?
    let color: String?
    let iconUrl: String?
    let websiteUrl: String?
    let links: [CoinDetailLink]?
    let supply: CoinDetailSupply?
    let numberOfMarkets: Int?
    let numberOfExchanges: Int?
    let the24HVolume: String?
    let marketCap: String?
    let price: String?
    let btcPrice: String?
    let priceAt: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String]?
    let allTimeHigh: CoinDetailAllTimeHigh?
    let coinrankingUrl: String?
    let tier: Int?
    let lowVolume: Bool?
    let listedAt: Int?

    init?(json: JSON) {
        self.uuid = "uuid" <~~ json
        self.symbol = "symbol" <~~ json
        self.name = "name" <~~ json
        self.description = "description" <~~ json
        self.color = "color" <~~ json
        self.iconUrl = "iconUrl" <~~ json
        self.websiteUrl = "websiteUrl" <~~ json
        self.links = "links" <~~ json
        self.supply = "supply" <~~ json
        self.numberOfMarkets = "numberOfMarkets" <~~ json
        self.numberOfExchanges = "numberOfExchanges" <~~ json
        self.the24HVolume = "the24HVolume" <~~ json
        self.marketCap = "marketCap" <~~ json
        self.price = "price" <~~ json
        self.btcPrice = "btcPrice" <~~ json
        self.priceAt = "priceAt" <~~ json
        self.change = "change" <~~ json
        self.rank = "rank" <~~ json
        self.sparkline = "sparkline" <~~ json
        self.allTimeHigh = "allTimeHigh" <~~ json
        self.coinrankingUrl = "coinrankingUrl" <~~ json
        self.tier = "tier" <~~ json
        self.lowVolume = "lowVolume" <~~ json
        self.listedAt = "listedAt" <~~ json
    }
}

// MARK: - AllTimeHigh
struct CoinDetailAllTimeHigh: JSONDecodable {
    let price: String?
    let timestamp: Int?
    
    init?(json: JSON) {
        self.price = "price" <~~ json
        self.timestamp = "timestamp" <~~ json
    }
}

// MARK: - Link
struct CoinDetailLink: JSONDecodable {
    let name: String?
    let type: String?
    let url: String?

    init?(json: JSON) {
        self.name = "name" <~~ json
        self.type = "type" <~~ json
        self.url = "url" <~~ json
    }
}

// MARK: - Supply
struct CoinDetailSupply: JSONDecodable {
    let confirmed: Bool?
    let total: String?
    let circulating: String?
    
    init?(json: JSON) {
        self.confirmed = "confirmed" <~~ json
        self.total = "total" <~~ json
        self.circulating = "circulating" <~~ json
    }

}
