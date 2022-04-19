//
//  SearchBarController.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 2/4/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa

class SearchCoinController: UISearchBar {
    var viewModel: MainInterface!
    let disposeBag = DisposeBag()
    
    func setup(_ interface: MainInterface) {
        viewModel = interface
        setupSearch()
    }
    
    private func setupSearch(){
        self.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] keyword in
                guard let weakSelf = self else { return }
                weakSelf.viewModel.input.getCoints(keyword: keyword, doClearData: true)
            })
            .disposed(by: disposeBag)
    }
}


