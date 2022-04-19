//
//  CoinDetailViewController.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import UIKit
import RxSwift
import Gloss
import Kingfisher
import SVGKit

class CoinDetailViewController: UIViewController {
    
    @IBOutlet weak var btnCloseDialog: UIButton!
    @IBOutlet weak var btnGoToWebsite: UIButton!
    @IBOutlet weak var viewImage: UIView!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSymbol: UILabel!
    @IBOutlet weak var lbPriceText: UILabel!
    @IBOutlet weak var lbMarketCapText: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbMarketCap: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    let disposeBag = DisposeBag()
    var viewModel: CoinDetailInterface!
    var uuid: String?

    private let svgRatio = 0.8

    var coinDetailViewModel: CoinDetailDisplayViewModel? {
        didSet {
            if let coinDetailViewModel = coinDetailViewModel {
                setDisplayDetail(coinDetailViewModel: coinDetailViewModel)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(CoinDetailViewModel())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let uuid = uuid {
            viewModel.input.getCoinDetail(uuid: uuid)
        }
    }
    
    func setup(_ interface: CoinDetailInterface) {
        viewModel = interface
        setupView()
        setupEvent()
    }
    
    func setupView(){
        btnGoToWebsite.addBorder(to: .top, in: UIColor.constColor.separatorColor(), width: 1)
    }
    
    func setupEvent(){
        viewModel.output.behCoinDetailDisplay.debug().subscribe(
            onNext: { [weak self] res in
                guard let weakSelf = self, let res = res else { return }
                weakSelf.coinDetailViewModel = res
            },
            onError: { err in
                print(err)
            }
        ).disposed(by: disposeBag)
    }
    
    func setDisplayDetail(coinDetailViewModel: CoinDetailDisplayViewModel!) {
        lbPrice.text = "PRICE"
        lbMarketCap.text = "MARKET CAP"
        
        if let iconUrl = coinDetailViewModel.iconUrl {
            for view in viewImage.subviews {
                view.removeFromSuperview()
            }
            
            if(iconUrl.uppercased().range(of: "SVG") != nil) {
                let url = URL(string: iconUrl)
                let data = try? Data(contentsOf: url!)
                let receivedimage: SVGKImage = SVGKImage(data: data)
                
                let viewBox = receivedimage.domTree.viewBox
                
                if abs(Double(viewBox.width / viewBox.height)) < svgRatio {
                    receivedimage.scaleToFit(inside: CGSize(width: receivedimage.size.width, height: imageViewIcon.frame.height))
                } else {
                    receivedimage.scaleToFit(inside: CGSize(width: imageViewIcon.frame.width, height: imageViewIcon.frame.height))
                }
                
                imageViewIcon.image = receivedimage.uiImage
                imageViewIcon.contentMode = .scaleAspectFit
            } else {
                let url = URL(string: iconUrl)
                imageViewIcon.kf.setImage(with: url)
            }
        }
        
        if let hexString = coinDetailViewModel.color {
            lbName.textColor = UIColor().colorWithHexString(hexString:hexString)
        }
        
        lbName.text = coinDetailViewModel.name
        lbSymbol.text = coinDetailViewModel.symbolText
        lbPriceText.text = coinDetailViewModel.priceText
        lbMarketCapText.text = coinDetailViewModel.marketCapText
        tvDescription.attributedText = coinDetailViewModel.description?.htmlToAttributedString
        
        if coinDetailViewModel.websiteUrl != nil {
            btnGoToWebsite.isHidden = false
        } else {
            btnGoToWebsite.isHidden = true
        }
    }
    
    @IBAction func btnCloseDialogAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnGoToWebsiteAction(_ sender: Any) {
        viewModel.input.goToWebsite(url: coinDetailViewModel?.websiteUrl)
    }
}
