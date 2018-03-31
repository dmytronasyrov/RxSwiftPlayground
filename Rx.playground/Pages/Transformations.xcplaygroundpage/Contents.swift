import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

exampleOf("map") {
    Observable.of(1, 2, 3)
        .map { $0 * $0 }
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .dispose()
}

exampleOf("flatMap") {
    let bag = DisposeBag()
    
    struct Player {
        let score: Variable<Int>
    }
    
    let vasja = Player(score: Variable(80))
    let petja = Player(score: Variable(90))
    let player = Variable(vasja)
    
    player.asObservable()
    
    player.asObservable()
        .flatMap { $0.score.asObservable() }
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
    
    player.value.score.value = 85
    vasja.score.value = 88
    
    player.value = petja
    
    vasja.score.value = 100
}

exampleOf("flatMapLatest") {
    let bag = DisposeBag()
    
    struct Player {
        let score: Variable<Int>
    }
    
    let vasja = Player(score: Variable(80))
    let petja = Player(score: Variable(90))
    let player = Variable(vasja)
    
    player.asObservable()
    
    player.asObservable()
        .flatMapLatest { $0.score.asObservable() }
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
    
    player.value.score.value = 85
    vasja.score.value = 88
    
    player.value = petja
    
    vasja.score.value = 100
}

exampleOf("scan") {
    let bag = DisposeBag()
    let score = PublishSubject<Int>()
    
    score.asObservable()
        .scan(500) { acc, val in
            let result = acc - val
            return result >= 0 ? result : 0
        }
        .`do`(onNext: {
            if $0 == 0 {
                score.onCompleted()
            }
        }, onError: nil, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
        .subscribe({ (event) in
            print(event.isStopEvent ? event : event.element! )
        })
//        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: { print("Completed") }, onDisposed: nil)
        .disposed(by: bag)
    
    score.onNext(13)
    score.onNext(60)
    score.onNext(35)
    score.onNext(566)
    score.onNext(23)
}

exampleOf("buffer") {
    let bag = DisposeBag()
    let score = PublishSubject<Int>()
    
    score.asObservable()
        .buffer(timeSpan: 0.0, count: 3, scheduler: MainScheduler.instance)
        .map { $0.reduce(0, +) }
        .scan(501) { acc, val in
            let result = acc - val
            return result >= 0 || result > 1 ? result : 0
        }
        .`do`(onNext: {
            if $0 == 0 {
                score.onCompleted()
            }
        }, onError: nil, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
        .subscribe({ (event) in
            print(event.isStopEvent ? event : event.element! )
        })
        .disposed(by: bag)
    
    score.onNext(13)
    score.onNext(60)
    score.onNext(50)
    score.onNext(566)
    score.onNext(0)
    score.onNext(0)
    score.onNext(378)
}











