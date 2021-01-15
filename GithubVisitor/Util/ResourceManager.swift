//
//  ResourceManager.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/15.
//

import UIKit

class ResourceManager: NSObject {

    // MARK: Color
    public static let NORMAL_TEXT_COLOR = UIColor.fromRGB(0x252525);
    public static let GRAY_LINE_COLOR = UIColor.fromRGB(0xDFDFDF);
    public static let GRAY_BACKGROUND_COLOR = UIColor.fromRGB(0xF4F4F4);

    // MARK: Dimension
    public static let DEFAULT_CELL_MARGIN_X : CGFloat = 10;
    public static let DEFAULT_CELL_MARGIN_Y : CGFloat = 10;
    public static let SUBVIEW_MARGIN_X : CGFloat = 20;
    public static let SUBVIEW_MARGIN_Y : CGFloat = 10;
    public static let LINE_HEIGHT : CGFloat = 1;

    // MARK: Font
    public static let TITLE_FONT : UIFont = UIFont.systemFont(ofSize: 20)
    public static let NORMAL_FONT : UIFont = UIFont.systemFont(ofSize: 12)
}
