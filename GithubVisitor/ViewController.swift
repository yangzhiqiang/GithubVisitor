//
//  ViewController.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/14.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tipLabel: UILabel!
    
    var record: SimpleRootInfo!

    /// Define this controller's work mode,
    ///
    /// *Values*
    ///
    /// `realTime` for real time mode, default mode
    ///
    /// `history` for history mode. if Controller was opened in histroy list.
    
    enum WorkMode {
        case realTime
        case history
    }
    
    var workMode: WorkMode = .realTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if workMode == .realTime {
            // register notification observer
            registerNotification();
        }
        
        updateContent()
    }

    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    func registerNotification() -> Void {
        // Register the observer for cache datebase.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContentByNotification(_:)),
                                               name: .githubCacheChanged,
                                               object: nil)
    }
    
    @objc func updateContentByNotification(_ noti : Notification){
        updateContent()
    }
    
    /// Update UI Content
    func updateContent() -> Void {
        if workMode == .history {
            if self.tableView.isHidden == true {
                self.tableView.isHidden = false
                self.tipLabel.isHidden = true
            }
            self.tableView.reloadData()
        } else {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                
                if let cache = DataCenter.shared.latestRecord() {
                    if  let record = SimpleRootInfo(cache: cache) {
                        //print("Start at: \(record.startTime) End at: \(record.endTime), content: \(record.rawString)")
                        self.record = record
                        if self.tableView.isHidden == true {
                            self.tableView.isHidden = false
                            self.tipLabel.isHidden = true
                        }
                        self.tableView.reloadData()
                    } else {
                        self.record = nil
                        if self.tipLabel.isHidden == true {
                            self.tableView.isHidden = true
                            self.tipLabel.isHidden = false
                        }
                        self.tipLabel.text = cache.rawString
                    }
                } else { //
                    self.record = nil
                    if self.tipLabel.isHidden == true {
                        self.tableView.isHidden = true
                        self.tipLabel.isHidden = false
                    }
                    self.tipLabel.text = "No record to get, please wait a moment"
                }
            }
        }
    }
}

// MARK: UI Method
extension ViewController {
    func setupUI() -> Void {
        
        if workMode == .realTime {
            // History Button
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "History",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(showHistory(_ :)));

            navigationItem.title = "Github Root Info";
            
            tableView.refreshControl = UIRefreshControl();
            tableView.refreshControl?.addTarget(self, action:
                                                        #selector(handleRefreshControl),
                                                        for: .valueChanged)
        } else {
            navigationItem.title = "History Root Info";
        }
        
        tableView.register(GithubInfoDetailCell.self, forCellReuseIdentifier: "\(GithubInfoDetailCell.self)")
        
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 80;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: UIScreen.currentWidth(),
                                                         height: 1));
    }
    
    @objc func showHistory(_ sender : Any) {
        if let storyboard = self.storyboard {
           let controller = storyboard.instantiateViewController(identifier: "\(HistoryListController.self)")
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    @objc func handleRefreshControl() {
        updateContent()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.record != nil else {
            return 0
        }
        return SimpleRootInfo.displayKeys.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(GithubInfoDetailCell.self)") as! GithubInfoDetailCell;
        
        let title = SimpleRootInfo.displayKeys[indexPath.row]
        
        if let content = record[title] {
            cell.updateContent(title: title, content: content);
        } else {
            cell.updateContent(title: title, content: "Invalid data");
        }
        
        if indexPath.row >= (SimpleRootInfo.displayKeys.count - 1) {// if last item, then hide Seperator
            cell.separatorInset = UIEdgeInsets(top: 100, left: 1000, bottom: 100, right: -1000);
        }
        
        return cell;
    }
}

