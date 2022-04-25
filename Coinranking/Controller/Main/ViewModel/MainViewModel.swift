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
    var service: MainServiceInterface!
    
    let topRankDisplay = 3
    let inviteIndexConst = 5
    let limit = 10

    var currentOffset = 0
    var currentKeyword: String?
    
    let disposeBag = DisposeBag()
    var coinViewModel: [CoinDisplayViewModel] = []
    var isLoadFromRefresh = false
    var isSearchFromKeyword = false
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
    
    // Output
    var isLoadData = false
    let behSearchFromKeyword = BehaviorSubject<Bool>(value: false)
    var behViewCoinDetail = BehaviorSubject<String?>(value: nil)
    var behHiddenNoResultView = BehaviorSubject<Bool>(value: true)
    var behTableCoinCellDisplay = BehaviorSubject<TableCoinCellDisplay>(value: TableCoinCellDisplay(topRank: [], coins: []))
    
    init(service: MainServiceInterface) {
        self.service = service
    }
}

enum ResponseType: Int, CaseIterable {
    case loading
    case success
    case error
}

extension MainViewModel {
    
    // MARK: - Clear data when refresh or search
    func clearData(){
        coinViewModel = []
        totalData = -1
        currentOffset = 0
    }
    
    var isDisplayTopRank: Bool {
        get {
            return isSearchFromKeyword == false && !coinViewModel.isEmpty
        }
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

        guard let totalData = totalData else { return }
        
        // Check display invite cell
        var inviteAppendAmount = 0
        var inviteIndex = inviteIndexConst
        let displayTopRank = isDisplayTopRank
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
        let count = coinViewModel.count
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
    
    // MARK: - Show or hidden no result view
    func hiddenNoResultView(isHidden: Bool) {
        behHiddenNoResultView.onNext(isHidden)
    }
}

extension MainViewModel: MainInteractorInput {
    // MARK: - Load coins data
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
        
        service.getCoins(parameters: parameters).debug().subscribe(
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
        .disposed(by: disposeBag)
    }
    
    // MARK: - Lazy load active function
    func getCointsMore(){
        currentOffset = coinViewModel.count
        getCoints(keyword: currentKeyword)
    }
    
    // MARK: - Pull to refresh active function
    func getCointsRefresh(){
        isLoadFromRefresh = true
        getCoints(keyword: currentKeyword, doClearData: true)
    }
    
    // MARK: - Pull to refresh active function
    func viewCoinDetail(uuid: String) {
        behViewCoinDetail.onNext(uuid)
    }
    
    // MARK: - Try again active function
    func tryAgainAction() {
        getCointsMore()
    }
}
