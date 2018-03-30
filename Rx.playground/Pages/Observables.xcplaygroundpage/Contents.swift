import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

exampleOf("just") {
    Observable
        .just("Hi there!")
        .subscribe { print($0) }
}

exampleOf("of") {
    let observable = Observable.of(1, 2, 3)
    
    observable.subscribe { print($0) }.dispose()
    observable.subscribe { print($0) }.dispose()
}

exampleOf("from") {
    let bag = DisposeBag()
    let observable = Observable.from([1, 2, 3])
    
    observable
        .subscribe { print($0) }
        .disposed(by: bag)
    
    observable
        .subscribe(
            onNext: { print("Next:", $0) },
            onError: { print("Err:", $0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        ).disposed(by: bag)
}

exampleOf("error") {
    enum TestError: Error {
        case test
    }
    
    let disposable = Observable<Int>
        .error(TestError.test)
        .asObservable()
        .subscribe { print($0) }
}

