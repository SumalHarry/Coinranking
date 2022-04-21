//
//  MainViewController.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 2/4/2565 BE.
//

import UIKit
import RxSwift

class MainViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var viewNoResult: UIView!
    
    @IBOutlet weak var searchbar: SearchCoinController!
    @IBOutlet weak var tableCoinList: TableCoinController!
    
    let disposeBag = DisposeBag()
    var uuidSelectDetail: String?
    var viewModel: MainInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(MainViewModel(service: CoinrankingService()))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCoinDetail"{
            let destination = segue.destination as? CoinDetailViewController
            destination?.uuid = uuidSelectDetail
        }
    }
    
    func setup(_ interface: MainInterface) {
        viewModel = interface
        setupView()
        setupEvent()
    }
    
    func setupView(){
        hideKeyboardWhenTappedAround()
        viewSeparator.backgroundColor = UIColor.constColor.separatorColor()
        searchbar.backgroundImage = UIImage()
        
        searchbar.setup(viewModel)
        tableCoinList.setup(viewModel)
    }
    
    func setupEvent(){
        viewModel.output.behViewCoinDetail.debug().subscribe(
            onNext: { [weak self] uuid in
                guard let weakSelf = self,let uuid = uuid  else { return }
                weakSelf.uuidSelectDetail = uuid
                weakSelf.performSegue(withIdentifier: "goToCoinDetail", sender: self)
            },
            onError: { err in
                print(err)
            }
        ).disposed(by: disposeBag)
        
        viewModel.output.behHiddenNoResultView.debug().subscribe(
            onNext: { [weak self] isHidden in
                guard let weakSelf = self else { return }
                weakSelf.viewNoResult.isHidden = isHidden
                weakSelf.tableCoinList.isHidden = !isHidden
            },
            onError: { err in
                print(err)
            }
        ).disposed(by: disposeBag)
    }
}
