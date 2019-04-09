//  ActionCell.swift
//  XLActionController ( https://github.com/xmartlabs/ActionCell )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public protocol SeparatorCellType: NSObjectProtocol {
    func showSeparator()
    func hideSeparator()
}

open class ActionCell: UICollectionViewCell, SeparatorCellType {

    @IBOutlet open weak var actionTitleLabel: UILabel?
    @IBOutlet open weak var actionImageView: UIImageView?
    @IBOutlet open weak var actionDetailLabel: UILabel?
    @IBOutlet open weak var separatorView: UIView?

    @IBOutlet open weak var imageViewWidthConstraint: NSLayoutConstraint?

    var imageWidth: CGFloat = 0

    open override func awakeFromNib() {
        super.awakeFromNib()

        imageWidth = imageViewWidthConstraint?.constant ?? 0
    }

    open func setup(_ title: String?, detail: String?, image: UIImage?) {
        actionTitleLabel?.text = title
        actionTitleLabel?.textColor = .white
        actionDetailLabel?.text = detail
        actionImageView?.image = image

        imageViewWidthConstraint?.constant = image == nil ? 0 : imageWidth

        setNeedsLayout()
    }
    
    open func showSeparator() {
        separatorView?.alpha = 1.0
    }
    
    open func hideSeparator() {
        separatorView?.alpha = 0.0
    }
}
