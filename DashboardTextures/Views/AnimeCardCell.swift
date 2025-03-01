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
        backgroundColor = .navyBackGround
        setupNodes(with: anime)
    }
    
    private func setupNodes(with anime: AnimeData) {
        setupCoverImage(with: anime)
        setupStatusBadge(with: anime)
        setupSeasonEpisode(with: anime)
        setupTitle(with: anime)
        setupRating(with: anime)
        setupRanking(with: anime)
        setupGenreTags(with: anime)
    }
    
    private func setupCoverImage(with anime: AnimeData) {
        coverImageNode.url = URL(string: anime.images?["jpg"]?.imageURL ?? "")
        coverImageNode.style.preferredSize = CGSize(width: 100, height: 140)
        coverImageNode.cornerRadius = 8
        coverImageNode.clipsToBounds = true
    }
    
    private func setupStatusBadge(with anime: AnimeData) {
        statusBadgeNode.attributedText = NSAttributedString(
            string: anime.status ?? "NA",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 12)]
        )
    }
    
    private func setupSeasonEpisode(with anime: AnimeData) {
        seasonEpisodeNode.attributedText = NSAttributedString(
            string: "\(anime.season?.uppercased() ?? "NA") • \(anime.episodes ?? 0) episodes",
            attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 12)]
        )
    }
    
    private func setupTitle(with anime: AnimeData) {
        titleNode.attributedText = NSAttributedString(
            string: anime.title ?? "NA",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]
        )
    }
    
    private func setupRating(with anime: AnimeData) {
        ratingNode.attributedText = NSAttributedString(
            string: "⭐ \(anime.rating ?? "0") (\(anime.members ?? 0) users)",
            attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 12)]
        )
    }
    
    private func setupRanking(with anime: AnimeData) {
        rankingNode.attributedText = NSAttributedString(
            string: "#\(anime.popularity ?? -1) Ranking",
            attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 12)]
        )
    }
    
    private func setupGenreTags(with anime: AnimeData) {
        genreStack.direction = .horizontal
        genreStack.spacing = 5
        genreStack.justifyContent = .start
        genreStack.alignItems = .center

        for genre in (anime.genres ?? []) {
            let genreNode = ASTextNode()
            genreNode.attributedText = NSAttributedString(
                string: genre.name ?? "",
                attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 12)]
            )
            genreStack.children?.append(createPaddedBackgroundNode(for: genreNode, withColor: .darkGray, value: 2))
        }
    }
    
    private func createPaddedBackgroundNode(for node: ASDisplayNode, withColor color: UIColor, value: CGFloat = 2) -> ASBackgroundLayoutSpec {
        let paddedNode = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: value, left: value*2, bottom: value, right: value*2),
            child: node
        )

        let backgroundNode = ASDisplayNode()
        backgroundNode.backgroundColor = color
        backgroundNode.cornerRadius = 4

        return ASBackgroundLayoutSpec(child: paddedNode, background: backgroundNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let statusBadgeWithBackground = createPaddedBackgroundNode(for: statusBadgeNode, withColor: .darkGray, value: 4)

        let textStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .start,
            children: [statusBadgeWithBackground, seasonEpisodeNode, titleNode, ratingNode, rankingNode, genreStack]
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
