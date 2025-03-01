//
//  AnimeCardCell.swift
//  DashboardTextures
//
//  Created by Aakarsh Verma on 01/03/25.
//

import UIKit
import AsyncDisplayKit

class AnimeCellNode: ASCellNode {
    
    private let coverImageNode = ASNetworkImageNode()
    private let statusBadgeNode = ASTextNode()
    private let seasonEpisodeNode = ASTextNode()
    private let titleNode = ASTextNode()
    private let ratingNode = ASTextNode()
    private let rankingNode = ASTextNode()
    private let genreStack = ASStackLayoutSpec()
    
    init(anime: AnimeData) {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = .navyBackGround
        setupNodes(anime: anime)
    }
    
    private func setupNodes(anime: AnimeData) {
        // Cover Image
        coverImageNode.url = URL(string: anime.images?["jpg"]?.imageURL ?? "")
        coverImageNode.style.preferredSize = CGSize(width: 100, height: 140)
        coverImageNode.cornerRadius = 8
        coverImageNode.clipsToBounds = true
        
        // Status Badge
        statusBadgeNode.attributedText = NSAttributedString(
            string: anime.status ?? "NA",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 12)]
        )
        statusBadgeNode.backgroundColor = UIColor.darkGray
        statusBadgeNode.cornerRadius = 4
        statusBadgeNode.style.spacingAfter = 5
        
        // Season and Episode Count
        seasonEpisodeNode.attributedText = NSAttributedString(
            string: "\(anime.season ?? "NA") • \(anime.episodes ?? 0) episodes",
            attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 12)]
        )
        
        // Anime Title
        titleNode.attributedText = NSAttributedString(
            string: anime.title ?? "NA",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]
        )
        
        // Rating
        ratingNode.attributedText = NSAttributedString(
            string: "⭐ \(anime.rating ?? "0") (\(anime.members ?? 0) users)",
            attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 12)]
        )
        
        // Ranking
        rankingNode.attributedText = NSAttributedString(
            string: "#\(anime.popularity ?? -1) Ranking",
            attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 12)]
        )
        
        // Genre Tags
        for genre in (anime.genres ?? []) {
            let genreNode = ASTextNode()
            genreNode.attributedText = NSAttributedString(
                string: genre.name ?? "",
                attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 12)]
            )
            genreNode.backgroundColor = UIColor.darkGray
            genreNode.cornerRadius = 4
//            genreNode.style.padding = 5
            genreStack.children?.append(genreNode)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .start,
            children: [statusBadgeNode, seasonEpisodeNode, titleNode, ratingNode, rankingNode, genreStack]
        )
        
        let mainStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [coverImageNode, textStack]
        )
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: mainStack)
    }
}

