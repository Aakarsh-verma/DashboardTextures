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
    private let networkManager: NetworkServiceProtocol
    private let disposeBag = DisposeBag()
    private(set) var animeList: PublishSubject<[AnimeData]> = PublishSubject()
    
    init(networkManager: NetworkServiceProtocol = AnimeAPIService()) {
        self.networkManager = networkManager
    }
    
    func fetchAnimeData() {
        networkManager.fetchData()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (animeResponse: AnimeResponseModel) in
                guard let self = self else { return }
                self.animeList.onNext(animeResponse.data ?? [])
            } onError: { error in
                NSLog(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
