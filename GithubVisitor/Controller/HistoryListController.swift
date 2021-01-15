//
//  HistoryListController.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/15.
//

import UIKit
import PullToRefreshKit

class HistoryListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tipLabel: UILabel!
    
    var records: [CacheRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        updateContent()
    }

    /// Update UI Content
    func updateContent() -> Void {
        // get lasted 20 records
        records = DataCenter.shared.records(limit: 20, offset: 0)
        
        // update status of refresh control
        if records.count < 20 {
            self.tableView.switchRefreshFooter(to: .noMoreData)
        } else {
            self.tableView.switchRefreshFooter(to: .normal)
        }
        self.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
        tableView.reloadData()
    }
    
    /// load more data
    func loadMore() -> Void {
        // topID make the quest same with first request. prevent repeated data because inserted new records.
        var topID: Int64 = Int64.max
        if records.count > 0 {
            topID = records[0].id
        }
        
        let retRecords = DataCenter.shared.records(limit: 20, offset: records.count, topID: topID)
        records.append(contentsOf: retRecords)
        
        // update status of refresh control
        if retRecords.count < 20 {
            self.tableView.switchRefreshFooter(to: .noMoreData)
        } else {
            self.tableView.switchRefreshFooter(to: .normal)
        }
        tableView.reloadData()
    }
}

// MARK: UI Method
extension HistoryListController {
    func setupUI() -> Void {
        // History Button
        navigationItem.title = "History";

        tableView.register(HistoryCell.self, forCellReuseIdentifier: "\(HistoryCell.self)")
        
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 80;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: UIScreen.currentWidth(),
                                                         height: 1));
        
        let header = DefaultRefreshHeader.header();
        tableView.configRefreshHeader(with: header,container:self) { [weak self] in
            self?.updateContent();
        }
        
        let footer = DefaultRefreshFooter.footer();
        self.tableView.configRefreshFooter(with: footer,container:self) { [weak self] in
            self?.loadMore()
        };
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension HistoryListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(HistoryCell.self)") as! HistoryCell;
        
        cell.updateContent(record: records[indexPath.row]);
        
        if indexPath.row >= (SimpleRootInfo.displayKeys.count - 1) {// if last item, then hide Seperator
            cell.separatorInset = UIEdgeInsets(top: 100, left: 1000, bottom: 100, right: -1000);
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cacheRecord = records[indexPath.row]
        
        if cacheRecord.errorCode == 0, let record = SimpleRootInfo(cache: cacheRecord) {
            if let storyboard = self.storyboard,
               let controller = storyboard.instantiateViewController(identifier: "\(ViewController.self)") as? ViewController {
                controller.workMode = .history
                controller.record = record
                navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Warning", message: "This is a error record, can not show it", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
