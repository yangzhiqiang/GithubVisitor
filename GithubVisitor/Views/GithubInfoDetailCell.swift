//
//  GithubInfoDetailCell.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/15.
//

import UIKit
import SnapKit

class GithubInfoDetailCell: UITableViewCell {
    var titleLabel : UILabel!;
    var contentLabel : UILabel!;

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        initCell();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        initCell();
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initCell();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// Initialization code
    func initCell() {
        contentView.backgroundColor = ResourceManager.GRAY_BACKGROUND_COLOR;
        
        let backView = UIView();
        backView.backgroundColor = .white;
        contentView.addSubview(backView);
        backView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview();
            make.bottom.equalToSuperview().offset(-ResourceManager.DEFAULT_CELL_MARGIN_Y);
        }
        
        titleLabel = UILabel();
        titleLabel.textColor = ResourceManager.NORMAL_TEXT_COLOR;
        titleLabel.font = ResourceManager.TITLE_FONT;
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = .byTruncatingMiddle;
        backView.addSubview(titleLabel);
        titleLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(20);
            make.leading.equalToSuperview().offset(ResourceManager.DEFAULT_CELL_MARGIN_X);
            make.trailing.lessThanOrEqualToSuperview().offset(-ResourceManager.DEFAULT_CELL_MARGIN_X);
            make.top.equalToSuperview().offset(ResourceManager.DEFAULT_CELL_MARGIN_Y);
        }
        
        let sep1 = UIView();
        sep1.backgroundColor = ResourceManager.GRAY_LINE_COLOR;
        backView.addSubview(sep1);
        sep1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(ResourceManager.DEFAULT_CELL_MARGIN_X);
            make.trailing.lessThanOrEqualToSuperview()
                .offset(-ResourceManager.DEFAULT_CELL_MARGIN_X)
            make.trailing.equalTo(titleLabel.snp.trailing)
                .offset(ResourceManager.DEFAULT_CELL_MARGIN_X)
                .priority(500);
            make.top.equalTo(titleLabel.snp.bottom).offset(ResourceManager.SUBVIEW_MARGIN_Y);
            make.height.equalTo(ResourceManager.LINE_HEIGHT);
        }
        
        contentLabel = UILabel();
        contentLabel.textColor = ResourceManager.NORMAL_TEXT_COLOR;
        contentLabel.font = ResourceManager.NORMAL_FONT;
        contentLabel.numberOfLines = 0;
        backView.addSubview(contentLabel);
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(ResourceManager.DEFAULT_CELL_MARGIN_X);
            make.trailing.equalToSuperview().offset(-ResourceManager.DEFAULT_CELL_MARGIN_X);
            make.top.equalTo(sep1.snp.bottom).offset(ResourceManager.SUBVIEW_MARGIN_Y);
            make.height.greaterThanOrEqualTo(20);
            make.bottom.equalToSuperview().offset(-ResourceManager.DEFAULT_CELL_MARGIN_Y);
        }
    }

    func updateContent(title: String, content: String) -> Void {
        titleLabel.text = title
        contentLabel.text = content
    }
}
