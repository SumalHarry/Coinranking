//
//  MainManager.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Foundation
import RxSwift
import Gloss

class MainViewModel: MainInterface, MainInteractorOutput {
    
    var input: MainInteractorInput  { return self }
    var output: MainInteractorOutput  { return self }
    
    private let topRankDisplay = 3
    private let inviteIndexConst = 5
    private let limit = 10

    var currentOffset = 0
    var currentKeyword: String?
    
    let dispostBag = DisposeBag()
    var isLoadData = false
    
    // Output
    let behCoinsData = BehaviorSubject<GetCoinsModel?>(value: nil)
    let behSearchFromKeyword = BehaviorSubject<Bool>(value: false)
    let behGetCoinError = BehaviorSubject<Bool>(value: false)
    
    var behViewCoinDetail = BehaviorSubject<String?>(value: nil)
    var behHiddenNoResultView = BehaviorSubject<Bool>(value: true)
    
    var behTableCoinCellDisplay = BehaviorSubject<TableCoinCellDisplay>(value: TableCoinCellDisplay(topRank: [], coins: []))

    var totalData: Int? = -1 {
        didSet {
            guard let totalData = totalData else {return}
            if totalData == 0 {
                hiddenNoResultView(isHidden: false)
            } else {
                hiddenNoResultView(isHidden: true)
            }
        }
    }
    var coinViewModel: [CoinDisplayViewModel] = []
    var isLoadFromRefresh = false
    var isSearchFromKeyword = false
}

enum ResponseType: Int, CaseIterable {
    case loading
    case success
    case error
}

extension MainViewModel {
    
    func clearData(){
        coinViewModel = []
        totalData = -1
        currentOffset = 0
    }
    
    func isDisplayTopRank() -> Bool {
        return isSearchFromKeyword == false && !coinViewModel.isEmpty
    }
    
    func mapToCoinViewModel(getCoins: GetCoinsModel?,type: ResponseType){
        if let getCoins = getCoins {
            totalData = getCoins.data?.stats?.totalData
            let coins = getCoins.data?.coins
            
            // if have totalData and have new coinData
            if totalData != 0 && coins?.count ?? 0 > 0 {
                let newCoinViewModel = coins?.map({ coin in
                    CoinDisplayViewModel(model: coin)!
                })
                coinViewModel.append(contentsOf: newCoinViewModel!)
            }
        }
        
        if isLoadFromRefresh == false {
            mapToTableCoinCellDisplay(coinViewModel: coinViewModel, type: type)
        }
    }
   
    func mapToTableCoinCellDisplay(coinViewModel: [CoinDisplayViewModel], type: ResponseType){
        var topRank:[CoinDisplayViewModel] = []
        var coins:[TableCoinCellDisplayViewModel] = []

        let count = coinViewModel.count
        guard let totalData = totalData else { return }
        
        // Check display invite cell
        var inviteAppendAmount = 0
        var inviteIndex = inviteIndexConst
        let displayTopRank = isDisplayTopRank()
        let plusTopRankDisplay = (displayTopRank == true) ? topRankDisplay : 0
        
        for (index, element) in coinViewModel.enumerated() {
            if displayTopRank == true && index < topRankDisplay{
                topRank.append(element)
            } else {
                if (index + 1) == ((inviteIndex + plusTopRankDisplay) - inviteAppendAmount) {
                    coins.append(TableCoinCellDisplayViewModel(cellType: .invite))
                    inviteAppendAmount += 1
                    inviteIndex *= 2
                }
                coins.append(TableCoinCellDisplayViewModel(cellType: .normal, coinViewModel:element))
            }
        }
        
        // Check display loading cell
        if count < totalData || totalData == -1 {
            switch type {
            case .loading:
                coins.append(TableCoinCellDisplayViewModel(cellType: .loading))
            case .success:
                coins.append(TableCoinCellDisplayViewModel(cellType: .loading))
            case .error:
                coins.append(TableCoinCellDisplayViewModel(cellType: .error))
            }
        }
        
        let tableCoinCellDisplay = TableCoinCellDisplay(topRank: topRank, coins: coins)
        behTableCoinCellDisplay.onNext(tableCoinCellDisplay)
    }
}

extension MainViewModel: MainInteractorInput {
    
    func getCoints(keyword: String?, doClearData: Bool = false){
        isLoadData = true
        if doClearData == true {
            clearData()
        }
        currentKeyword = keyword
        
        // init Request Param
        var parameters: [String: Any] = [
            "limit": limit,
            "offset": currentOffset
        ]
        
        // set search Request Param
        if let keyword = keyword, keyword.isEmpty == false {
            parameters["search"] = keyword
            isSearchFromKeyword = true
            behSearchFromKeyword.onNext(true)
        } else {
            isSearchFromKeyword = false
            behSearchFromKeyword.onNext(false)
        }
        
        // For Show loading
        mapToCoinViewModel(getCoins: nil, type: .loading)
        
        CoinrankingService.shared.getCoins(parameters: parameters).debug().subscribe(
            onNext: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.isLoadData = false
                weakSelf.isLoadFromRefresh = false
                
                let getCoins = GetCoinsModel.init(json: $0 as! JSON)
                if getCoins?.status == "success" {
                    weakSelf.mapToCoinViewModel(getCoins: getCoins, type: .success)
                } else {
                    weakSelf.mapToCoinViewModel(getCoins: nil, type: .error)
                }
            },
            onError: { [weak self] err in
                guard let weakSelf = self else { return }
                weakSelf.isLoadData = false
                weakSelf.isLoadFromRefresh = false
                weakSelf.mapToCoinViewModel(getCoins: nil, type: .error)
            }
        )
        .disposed(by: dispostBag)
    }
    
    // lazy load active function
    func getCointsMore(){
        currentOffset = coinViewModel.count
        getCoints(keyword: currentKeyword)
    }
    
    // Pull to refresh active function
    func getCointsRefresh(){
        isLoadFromRefresh = true
        getCoints(keyword: currentKeyword, doClearData: true)
    }
    
    func viewCoinDetail(uuid: String) {
        behViewCoinDetail.onNext(uuid)
    }
    
    func hiddenNoResultView(isHidden: Bool) {
        behHiddenNoResultView.onNext(isHidden)
    }
    
    func tryAgainAction() {
        getCointsMore()
    }
}
