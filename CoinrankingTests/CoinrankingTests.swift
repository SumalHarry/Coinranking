//
//  CoinrankingTests.swift
//  CoinrankingTests
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import XCTest
import Gloss

@testable import Coinranking


class CoinrankingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testConvertCoinViewModel(){
        let str = "{ \"uuid\": \"Qwsogvtv82FCd\", \"symbol\": \"BTC\", \"name\": \"Bitcoin\", \"color\": \"#f7931A\", \"iconUrl\": \"https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg\", \"marketCap\": \"778608585375\", \"price\": \"40960.34835663846\", \"listedAt\": 1330214400, \"tier\": 1, \"change\": \"-4.09\", \"rank\": 1, \"sparkline\": [ \"42706.5866839679099520860000\", \"42738.6738659241186991870000\", \"42758.9094910498831300560000\", \"42899.0791631868442362210000\", \"43138.7978728532611002920000\", \"43154.5668662056079153220000\", \"43271.8313911661857309620000\", \"43213.7446031275770247440000\", \"42905.2047665039093216960000\", \"42317.3071522492005236150000\", \"42281.8640965673203913270000\", \"42274.4279374017941962390000\", \"42289.4109562843331502040000\", \"42070.8606547920135461250000\", \"42094.7202200280755520460000\", \"42199.6089050322716494900000\", \"42278.6923266584494129250000\", \"42265.6735798299115862760000\", \"42290.3196156741193651960000\", \"42255.9598088376401903990000\", \"42099.8904260370572302000000\", \"41610.4197442423401799640000\", \"41448.0185192153278673350000\", \"41178.8054294222803148020000\", \"41155.8616699697769493650000\", \"41085.8711163239231750990000\", \"40960.3483566384637637120000\" ], \"lowVolume\": false, \"coinrankingUrl\": \"https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc\", \"24hVolume\": \"26531897258\", \"btcPrice\": \"1\" }"
        let json = str.convertToDictionary!

        guard let coinModel = GetCoinsCoin(json: json) else { return }
        let coinViewModel = CoinDisplayViewModel(model: coinModel)

        XCTAssertTrue(coinViewModel != nil)
        if let coinViewModel = coinViewModel {
            XCTAssertEqual(coinModel.uuid, coinViewModel.uuid)
            XCTAssertEqual(coinModel.iconUrl, coinViewModel.iconUrl)
            XCTAssertEqual(coinModel.symbol, coinViewModel.symbol)
            XCTAssertEqual(coinModel.name, coinViewModel.name)
            XCTAssertEqual("$40,960.35", coinViewModel.priceText)
            XCTAssertEqual(coinModel.rank, coinViewModel.rank)
            XCTAssertEqual("\u{2193} 4.09", coinViewModel.changeText)
            XCTAssertEqual(UIColor.constColor.changeDecreaseColor(), coinViewModel.changeTextColor)
        }
    }

    func testConvertCoinNodescriptionViewModel(){
        let str = "{ \"uuid\": \"Qwsogvtv82FCd\", \"symbol\": null, \"name\": null, \"color\": \"#f7931A\", \"iconUrl\": \"https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg\", \"marketCap\": \"778608585375\", \"price\": null, \"listedAt\": 1330214400, \"tier\": 1, \"change\": null , \"rank\": null, \"sparkline\": [ \"42706.5866839679099520860000\", \"42738.6738659241186991870000\", \"42758.9094910498831300560000\", \"42899.0791631868442362210000\", \"43138.7978728532611002920000\", \"43154.5668662056079153220000\", \"43271.8313911661857309620000\", \"43213.7446031275770247440000\", \"42905.2047665039093216960000\", \"42317.3071522492005236150000\", \"42281.8640965673203913270000\", \"42274.4279374017941962390000\", \"42289.4109562843331502040000\", \"42070.8606547920135461250000\", \"42094.7202200280755520460000\", \"42199.6089050322716494900000\", \"42278.6923266584494129250000\", \"42265.6735798299115862760000\", \"42290.3196156741193651960000\", \"42255.9598088376401903990000\", \"42099.8904260370572302000000\", \"41610.4197442423401799640000\", \"41448.0185192153278673350000\", \"41178.8054294222803148020000\", \"41155.8616699697769493650000\", \"41085.8711163239231750990000\", \"40960.3483566384637637120000\" ], \"lowVolume\": false, \"coinrankingUrl\": \"https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc\", \"24hVolume\": \"26531897258\", \"btcPrice\": \"1\" }"
        let json = str.convertToDictionary!

        guard let coinModel = GetCoinsCoin(json: json) else { return }
        let coinViewModel = CoinDisplayViewModel(model: coinModel)

        XCTAssertTrue(coinViewModel != nil)
        let noDescriptionText = "No description"
        if let coinViewModel = coinViewModel {
            XCTAssertEqual(coinModel.uuid, coinViewModel.uuid)
            XCTAssertEqual(coinModel.iconUrl, coinViewModel.iconUrl)
            XCTAssertEqual(noDescriptionText, coinViewModel.symbol)
            XCTAssertEqual(noDescriptionText, coinViewModel.name)
            XCTAssertEqual(noDescriptionText, coinViewModel.priceText)
            XCTAssertEqual(coinModel.rank, coinViewModel.rank)
            XCTAssertEqual(noDescriptionText, coinViewModel.changeText)
            XCTAssertEqual(UIColor.black, coinViewModel.changeTextColor)
        }
    }
    

//        self.iconUrl = model.iconUrl
//        self.symbol = (model.symbol != nil) ? model.symbol: "No description"
//        self.name = (model.name != nil) ? model.name: "No description"
//
//        if let priceTxt = model.price, let price = Double(priceTxt) {
//            self.priceText = "$\(price.withCommas(digits: 2))"
//        } else {
//            self.priceText = "No description"
//        }
//
//        if let changeTxt = model.change, var change = Double(changeTxt) {
//            if change >= 0 {
//                self.changeText = "\u{2191} \(change.withCommas(digits: 2))"
//                self.changeTextColor = UIColor.constColor.changeIncreaseColor()
//            } else if  change < 0 {
//                change *= -1
//                self.changeText = "\u{2193} \(change.withCommas(digits: 2))"
//                self.changeTextColor = UIColor.constColor.changeDecreaseColor()
//            } else {
//                self.changeText = change.withCommas(digits: 2)
//                self.changeTextColor = UIColor.black
//            }
//        } else {
//            self.changeText = "No description"
//            self.changeTextColor = UIColor.black
//        }
//
//        self.rank = model.rank

}
