//
//  AnimeViewModel.swift
//  DashboardTextures
//
//  Created by Aakarsh Verma on 28/02/25.
//

import Foundation
import RxSwift
import RxCocoa

class AnimeViewModel {
    let networkManager: NetworkServiceProtocol
    private let disposeBag = DisposeBag()
    private(set) var animeList: PublishSubject<[Datum]> = PublishSubject()
    
    init(networkManager: NetworkServiceProtocol = AnimeAPIService()) {
        self.networkManager = networkManager
    }
    
    func fetchAnimeData() {
        networkManager.fetchData()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] anime in
                guard let self = self else { return }
                self.animeList.onNext(anime)
            } onError: { error in
                NSLog(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
