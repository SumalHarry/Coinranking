//
//  TableCoinList.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 2/4/2565 BE.
//

import UIKit
import UCZProgressView

class TableCoinController: UITableView {
    var viewModel: MainInterface!
    var tableView: UITableView!
    var isSearchFromKeyword = false
    var tableCoinCellDisplay = TableCoinCellDisplay(topRank: [], coins: [])
    let uiRefresh = UIRefreshControl()
    
    func setup(_ interface: MainInterface) {
        viewModel = interface
        tableView = self
        setupEvent()
        setupTableView()
        setupRefreshControl()
    }
    
    fileprivate func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = 0
        
        // register header
        tableView.register(UINib(nibName: TableCoinHeaderCell.reuseId, bundle: .main),
                           forHeaderFooterViewReuseIdentifier: TableCoinHeaderCell.reuseId)
        // register cell
        tableView.register(UINib(nibName: CollectionCoinTopRank.reuseId, bundle: .main),
                           forCellReuseIdentifier: CollectionCoinTopRank.reuseId)
        tableView.register(UINib(nibName: TableCoinSearchCell.reuseId, bundle: .main),
                           forCellReuseIdentifier: TableCoinSearchCell.reuseId)
        tableView.register(UINib(nibName: TableCoinInviteCell.reuseId, bundle: .main),
                           forCellReuseIdentifier: TableCoinInviteCell.reuseId)
        tableView.register(UINib(nibName: TableCoinLoadingCell.reuseId, bundle: .main),
                           forCellReuseIdentifier: TableCoinLoadingCell.reuseId)
        tableView.register(UINib(nibName: TableCoinErrorCell.reuseId, bundle: .main),
                           forCellReuseIdentifier: TableCoinErrorCell.reuseId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 40
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
    }
    
    func setupRefreshControl(){
        uiRefresh.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        let progressView = UCZProgressView()
        progressView.indeterminate = true
        progressView.tintColor = UIColor.constColor.progressViewColor()
        progressView.lineWidth = 4
        uiRefresh.backgroundColor = UIColor.clear
        uiRefresh.tintColor = UIColor.clear
        uiRefresh.addSubview(progressView)
        
        progressView.frame = uiRefresh.bounds.offsetBy(dx: tableView.frame.size.width / 2 - 20, dy: 10)
        progressView.frame.size.width = 40
        progressView.frame.size.height = 40
        enableRefreshControl()
    }
    
    func enableRefreshControl(){
        tableView.refreshControl = uiRefresh
    }
    
    func disableRefreshControl(){
        tableView.refreshControl = nil
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.input.getCointsRefresh()
    }
    
    func setupEvent(){
        // Event for check display top 3 rank and display pull to refresh
        viewModel.output.behSearchFromKeyword.subscribe(
            onNext: { [weak self] res in
                guard let weakSelf = self else { return }
                // New Search From Keyword Reset offet to 0 and query
                weakSelf.isSearchFromKeyword = res
                
                if weakSelf.isSearchFromKeyword == true {
                    weakSelf.disableRefreshControl()
                } else {
                    weakSelf.enableRefreshControl()
                }
            }
        )
        
        viewModel.output.behTableCoinCellDisplay.subscribe(
            onNext: { [weak self] (res) in
                guard let weakSelf = self else { return}
                weakSelf.uiRefresh.endRefreshing()
                
                weakSelf.tableCoinCellDisplay = res
                weakSelf.tableView.reloadData()
            }
        )
    }
    
    func isDisplayTopRank() -> Bool {
        return tableCoinCellDisplay.topRank.isEmpty == false
    }
    
    func isTopRank(section: Int) -> Bool {
        if section == 0 && isDisplayTopRank() {
            return true
        } else {
            return false
        }
    }
}

extension TableCoinController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isDisplayTopRank() ? 2: 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 && isTopRank(section: section)) ? 1 : tableCoinCellDisplay.coins.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableCoinHeaderCell.reuseId) as? TableCoinHeaderCell
        if isTopRank(section: section) {
            let stringOne = "Top \(tableCoinCellDisplay.topRank.count) rank crypto"
            let stringTwo = String(tableCoinCellDisplay.topRank.count)
            let range = (stringOne as NSString).range(of: stringTwo)
            let attributedText = NSMutableAttributedString.init(string: stringOne)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            
            header?.title = attributedText
        }
        else {
            header?.title = NSMutableAttributedString.init(string: "Buy, sell and hold crypto")
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isTopRank(section: indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCoinTopRank.reuseId, for: indexPath) as! CollectionCoinTopRank
            cell.viewModel = viewModel
            cell.topRankCoin = tableCoinCellDisplay.topRank
            return cell
        } else {
            let tableCoinCell = tableCoinCellDisplay.coins[indexPath.row]
            switch tableCoinCell.cellType {
            case .normal:
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCoinSearchCell.reuseId, for: indexPath) as! TableCoinSearchCell
                
                let data = tableCoinCell.coinViewModel
                cell.coinViewModel = data
                cell.selectionStyle = .none
                return cell
            case .invite:
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCoinInviteCell.reuseId, for: indexPath) as! TableCoinInviteCell
                cell.selectionStyle = .none
                return cell
            case .loading:
                if(!viewModel.output.isLoadData){
                    //lazy load More Data
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.viewModel.input.getCointsMore()
                    }
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCoinLoadingCell.reuseId, for: indexPath) as! TableCoinLoadingCell
                cell.selectionStyle = .none
                return cell
            case .error:
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCoinErrorCell.reuseId, for: indexPath) as! TableCoinErrorCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                return cell
            }
        }
    }
}

extension TableCoinController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableCoinHeaderCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isTopRank(section: indexPath.section) {
            let tableViewModel = tableCoinCellDisplay.coins[indexPath.row]
            if tableViewModel.cellType == .normal {
                guard
                    let uuid = tableViewModel.coinViewModel?.uuid
                else { return }
                
                viewModel.input.viewCoinDetail(uuid: uuid)
            } else if tableViewModel.cellType == .invite {
                guard let url = URL(string: Constants.INVITE_URL)
                else {
                    return
                }
                UIApplication.shared.open(url)
            }
        }
    }
}
