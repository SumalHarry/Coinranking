//
//  CoinDetailInteractor.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 12/4/2565 BE.
//

import Foundation
import RxSwift
import Alamofire

// MARk - Data-binding
protocol CoinDetailInteractorInput {
    func getCoinDetail(uuid: String)
    func goToWebsite(url: String?)
}

protocol CoinDetailInteractorOutput {
    var behCoinDetailDisplay : BehaviorSubject<CoinDetailDisplayViewModel?> { get }
}

protocol CoinDetailInterface {
    var input: CoinDetailInteractorInput { get }
    var output: CoinDetailInteractorOutput { get }
}

protocol CoinDetailServiceInterface {
    func getCoinDatail(uuid: String) -> Observable<Any>
}
