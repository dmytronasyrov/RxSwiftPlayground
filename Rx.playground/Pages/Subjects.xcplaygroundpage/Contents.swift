//: Playground - noun: a place where people can play

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

exampleOf("PublishSubject") {
    enum TestError: Error {
        case test
    }
    
    let subject = PublishSubject<String>()
    
    subject.subscribe { print($0) }
    
    subject.onNext("Hello ")
    subject.onNext("World")
    
    let subscriptionNew = subject.subscribe(onNext: { print($0) }, onError: { print($0) }, onCompleted: { print("Completed") }, onDisposed: { print("Disposed") })

    subject.onNext("Hi there")
    subject.onError(TestError.test)
    subject.onCompleted()
    
    subscriptionNew.dispose()
    
    subject.onNext("Bye there")
}

exampleOf("BehaviorSubject") {
    let subject = BehaviorSubject(value: "a")
    
    let firstSubscription = subject.subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
    
    subject.onNext("b")
    
    let secondSubscription = subject.subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
}

exampleOf("ReplaySubject") {
    let subject = ReplaySubject<Int>.create(bufferSize: 3)
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    subject.onNext(4)
    subject.subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
}

exampleOf("Variable") {
    let bag = DisposeBag()
    let variable = Variable("A")
    
    Observable.from(variable)
        .subscribe(onNext: { print($0.value) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
    
    variable.value = "B"
}


