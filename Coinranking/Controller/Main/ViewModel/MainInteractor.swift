//
//  MainInteractor.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 12/4/2565 BE.
//

import Foundation
import RxSwift
import Alamofire

// MARk - Data-binding
protocol MainInteractorInput {
    // MARK : - Input GET Service
    func getCoints(keyword: String?, doClearData: Bool)
    // Lazy load active function
    func getCointsMore()
    // Pull to refresh active function
    func getCointsRefresh()
    
    func hiddenNoResultView(isHidden: Bool)
    
    func viewCoinDetail(uuid: String)
    
    func tryAgainAction()
}

protocol MainInteractorOutput {
    var behSearchFromKeyword: BehaviorSubject<Bool> { get }    
    var behViewCoinDetail: BehaviorSubject<String?> { get }
    var behHiddenNoResultView: BehaviorSubject<Bool> { get }
    
    var behTableCoinCellDisplay: BehaviorSubject<TableCoinCellDisplay> { get }
    
    var isLoadData: Bool { get }
}

protocol MainInterface {
    var input: MainInteractorInput { get }
    var output: MainInteractorOutput { get }
}

protocol MainServiceInterface {
    func getCoins(parameters: Parameters?) -> Observable<Any>
}
