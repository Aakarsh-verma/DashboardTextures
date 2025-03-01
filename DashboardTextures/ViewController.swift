//
//  ViewController.swift
//  DashboardTextures
//
//  Created by Aakarsh Verma on 27/02/25.
//

import UIKit
import AsyncDisplayKit
import RxSwift
import RxCocoa

class ViewController: ASDKViewController<ASDisplayNode> {
    private let viewModel = AnimeViewModel()
    private let disposeBag = DisposeBag()
    private var dataSource: [AnimeData] = []
    
    struct State {
        var itemCount: Int
        var fetchingMore: Bool
        static let empty = State(itemCount: 20, fetchingMore: false)
    }
    
    enum Action {
        case beginBatchFetch
        case endBatchFetch(resultCount: Int)
    }
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    fileprivate(set) var state: State = .empty
    
    override init() {
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.backgroundColor = .navyBackGround
        self.title = "Anime List"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchAnimeData()
    }
    
    private func setupBindings() {
        viewModel.animeList
            .subscribe(onNext: { [weak self] animeList in
                guard let self else { return }
                self.dataSource = animeList
                self.state = State(itemCount: animeList.count, fetchingMore: false)
                self.tableNode.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ASTableNode data source and delegate.
extension ViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let rowCount = self.tableNode(tableNode, numberOfRowsInSection: 0)
        
        if state.fetchingMore && indexPath.row == rowCount - 1 {
            return {
                let node = CustomCellNode()
                node.style.height = ASDimensionMake(44.0)
                return node;
            }
        }
        
        if dataSource.count == 0 { return { return ASTextCellNode() } }
        let anime = self.dataSource[indexPath.row]
        return {
            return AnimeCellNode(anime: anime)
        }
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        var count = state.itemCount
        if state.fetchingMore {
            count += 1
        }
        return count
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        /// This call will come in on a background thread. Switch to main
        /// to add our spinner, then fire off our fetch.
        DispatchQueue.main.async {
            let oldState = self.state
            self.state = ViewController.handleAction(.beginBatchFetch, fromState: oldState)
            self.renderDiff(oldState)
        }
        
//        ViewController.fetchDataWithCompletion { resultCount in
//            let action = Action.endBatchFetch(resultCount: resultCount)
//            let oldState = self.state
//            self.state = ViewController.handleAction(action, fromState: oldState)
//            self.renderDiff(oldState)
//            context.completeBatchFetching(true)
//        }
    }
    
    fileprivate func renderDiff(_ oldState: State) {
        
        self.tableNode.performBatchUpdates({
            
            // Add or remove items
            let rowCountChange = state.itemCount - oldState.itemCount
            if rowCountChange > 0 {
                let indexPaths = (oldState.itemCount..<state.itemCount).map { index in
                    IndexPath(row: index, section: 0)
                }
                tableNode.insertRows(at: indexPaths, with: .none)
            } else if rowCountChange < 0 {
                assertionFailure("Deleting rows is not implemented. YAGNI.")
            }
            
            // Add or remove spinner.
            if state.fetchingMore != oldState.fetchingMore {
                if state.fetchingMore {
                    // Add spinner.
                    let spinnerIndexPath = IndexPath(row: state.itemCount, section: 0)
                    tableNode.insertRows(at: [ spinnerIndexPath ], with: .none)
                } else {
                    // Remove spinner.
                    let spinnerIndexPath = IndexPath(row: oldState.itemCount, section: 0)
                    tableNode.deleteRows(at: [ spinnerIndexPath ], with: .none)
                }
            }
        }, completion:nil)
    }
    
    /// (Pretend) fetches some new items and calls the
    /// completion handler on the main thread.
    fileprivate static func fetchDataWithCompletion(_ completion: @escaping (Int) -> Void) {
        let time = DispatchTime.now() + Double(Int64(TimeInterval(NSEC_PER_SEC) * 1.0)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            let resultCount = Int(arc4random_uniform(20))
            completion(resultCount)
        }
    }
    
    fileprivate static func handleAction(_ action: Action, fromState state: State) -> State {
        var state = state
        switch action {
        case .beginBatchFetch:
            state.fetchingMore = true
        case let .endBatchFetch(resultCount):
            state.itemCount += resultCount
            state.fetchingMore = false
        }
        return state
    }
}
