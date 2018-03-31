import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

exampleOf("startWith") {
    let bag = DisposeBag()
    Observable.of("1", "2", "3")
        .startWith("A")
        .startWith("B")
        .startWith("C", "D")
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
}

exampleOf("merge") {
    let bag = DisposeBag()
    let subject1 = PublishSubject<String>()
    let subject2 = PublishSubject<String>()
    
    Observable.of(subject1, subject2)
        .merge()
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
    
    subject1.onNext("A")
    subject1.onNext("B")
    subject2.onNext("1")
    subject2.onNext("2")
    subject1.onNext("C")
    subject2.onNext("3")
}

exampleOf("zip") {
    let bag = DisposeBag()
    let subjectString = PublishSubject<String>()
    let subjectInt = PublishSubject<Int>()
    
    Observable
        .zip(subjectString, subjectInt) { strEl, intEl in
            "\(strEl)   \(intEl)"
        }
        .subscribe(onNext: { print($0) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
    
    subjectString.onNext("A")
    subjectString.onNext("B")
    
    subjectInt.onNext(1)
    subjectInt.onNext(2)
    
    subjectInt.onNext(3)
    subjectString.onNext("C")
    
    subjectString.onNext("D")
    subjectString.onNext("E")
    subjectInt.onNext(4)
}
