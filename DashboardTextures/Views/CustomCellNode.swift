//
//  CustomCellNode.swift
//  DashboardTextures
//
//  Created by Aakarsh Verma on 27/02/25.
//

import UIKit
import AsyncDisplayKit

class CustomCellNode: ASCellNode {
    let spinner = SpinnerNode()
    let text = ASTextNode()
    
    override init() {
        super.init()
        self.backgroundColor = .clear
        addSubnode(text)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white,
            .kern: -0.3
        ]
        text.attributedText = NSAttributedString(
            string: "Loading…",
            attributes: textAttributes
        )
        addSubnode(spinner)
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 16,
            justifyContent: .center,
            alignItems: .center,
            children: [ text, spinner ])
    }
}

final class SpinnerNode: ASDisplayNode {
    var activityIndicatorView: UIActivityIndicatorView {
        return view as! UIActivityIndicatorView
    }
    
    override init() {
        super.init()
        setViewBlock {
            UIActivityIndicatorView(style: .medium)
        }
        
        // Set spinner node to default size of the activitiy indicator view
        self.style.preferredSize = CGSize(width: 20.0, height: 20.0)
    }
    
    override func didLoad() {
        super.didLoad()
        activityIndicatorView.color = .white
        activityIndicatorView.startAnimating()
    }
}
