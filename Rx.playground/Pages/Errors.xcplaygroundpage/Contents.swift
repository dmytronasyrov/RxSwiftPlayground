import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import UIKit
import RxSwift

enum TestError: Error {
    case test
}

exampleOf("catchErrorJustReturn") {
    let bag = DisposeBag()
    let seqThatFails = PublishSubject<String>()
    seqThatFails.catchErrorJustReturn("I'm an error")
        .subscribe { print($0) }
        .disposed(by: bag)
    
    seqThatFails.onNext("Hello there")
    seqThatFails.onError(TestError.test)
}

exampleOf("catchError") {
    let bag = DisposeBag()
    let seqThatFails = PublishSubject<String>()
    let recoverySeq = PublishSubject<String>()
    
    seqThatFails.catchError {
        print("Err: ", $0)
        return recoverySeq
    }.subscribe { print($0) }
    
    seqThatFails.onNext("Hello, again")
    seqThatFails.onError(TestError.test)
    seqThatFails.onNext("Bye now")
    
    recoverySeq.onNext("Hi there, recovery is here")
}

exampleOf("retry") {
    let bag = DisposeBag()
    var count = 1
    
    let seqThatErrors = Observable<Int>.create { o in
        o.onNext(1)
        o.onNext(2)
        
        if count == 1 {
            o.onError(TestError.test)
            print("Error encountered")
            count += 1
        }
        
        o.onNext(3)
        o.onCompleted()
        
        return Disposables.create()
    }
    
    seqThatErrors.retry()
        .subscribe { print($0) }
        .disposed(by: bag)
}
