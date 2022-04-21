//
//  CoinrankingService.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class CoinrankingService {
    private let baseUrl = Constants.BASE_URL
    private let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "x-access-token": Constants.X_ACCESS_TOKEN
    ]
    
    private func getApiUrl(apiName:String) -> String {
        let url = "https://\(baseUrl)/v2/\(apiName)"
        return url
    }
}

extension CoinrankingService: MainServiceInterface {
    func getCoins(
        parameters: Parameters? = nil
    ) -> Observable<Any> {
        let url = getApiUrl(apiName: "coins")
        return RxAlamofire.json(.get, url, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
    }
}

extension CoinrankingService: CoinDetailServiceInterface {
    func getCoinDatail(uuid: String) -> Observable<Any> {
        let url = getApiUrl(apiName: "coin/\(uuid)")
        return RxAlamofire.json(.get, url, parameters: nil, encoding: URLEncoding.queryString, headers: headers)
    }
}
