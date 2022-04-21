//
//  CoinDetailViewModel.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 13/4/2565 BE.
//

import Foundation
import RxSwift
import Gloss

class CoinDetailViewModel: CoinDetailInterface, CoinDetailInteractorInput {
    
    var input: CoinDetailInteractorInput  { return self }
    var output: CoinDetailInteractorOutput  { return self }
    
    let disposeBag = DisposeBag()
    
    let behCoinDetailDisplay = BehaviorSubject<CoinDetailDisplayViewModel?>(value: nil)
    
    // MARK : - Init
    var service: CoinDetailServiceInterface!
    
    init(service: CoinDetailServiceInterface) {
        self.service = service
    }
    
    func getCoinDetail(uuid: String){
        service.getCoinDatail(uuid: uuid).debug().subscribe(
            onNext: { [weak self] in
                guard let weakSelf = self else { return }
                
                let getCoins = CoinDetailModel.init(json: $0 as! JSON)
                guard let coin = getCoins?.data?.coin else {
                    return
                }
                let coinDetailViewModel = CoinDetailDisplayViewModel(model: coin)
                
                weakSelf.behCoinDetailDisplay.onNext(coinDetailViewModel)
            },
            onError: { err in
                print(err)
            }
        )
        .disposed(by: disposeBag)
    }
    
    
    func goToWebsite(url: String?) {
        guard let websiteUrl = url,
              let url = URL(string: websiteUrl)
        else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

extension CoinDetailViewModel: CoinDetailInteractorOutput {
    
}
