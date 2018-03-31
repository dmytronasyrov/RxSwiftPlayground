import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

exampleOf("filter") {
    let bag = DisposeBag()
    Observable
        .generate(initialState: 1, condition: { $0 < 101 }, iterate: { $0 + 1 })
        .filter { number in
            guard number > 1 else { return false }
            var isPrime = true
            
            (2..<number).forEach {
                if number % $0 == 0 {
                    isPrime = false
                }
            }
            
            return isPrime
        }.toArray()
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
}

exampleOf("distinctUntilChanged") {
    let bag = DisposeBag()
    let search = Variable("")
    
    search.asObservable()
        .map { $0.lowercased() }
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
    
    search.value = "apple"
    search.value = "orange"
    search.value = "apple"
    search.value = "APPLE"
    search.value = "Banana"
}

exampleOf("takeWhile") {
    let bag = DisposeBag()
    let numbers = Observable.from([1, 2, 3, 4, 3, 2, 1])
    numbers.takeWhile { $0 < 4 }
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
}
