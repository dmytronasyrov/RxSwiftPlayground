import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import UIKit
import RxSwift

exampleOf("doOnNext") {
    let bag = DisposeBag()

    let observable = Observable.from([-40, 0, 70, 212])
    observable.do(onNext: { $0 * $0 }, onError: nil, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    observable.do(onNext: { print("\($0)F = ", terminator: "") }, onError: nil, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    observable.map { Double($0 - 32) * 5 / 9.0 }
        .subscribe(onNext: { print(String(format: "%.1fC", $0)) }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
}

exampleOf("schedulers") {
    let scheduler1 = ConcurrentDispatchQueueScheduler(qos: .background)
    
    let queueCustom = DispatchQueue(
        label: "com.rxqueue",
        qos: .background,
        attributes: [.concurrent],
        autoreleaseFrequency: .inherit,
        target: nil
    )
    let scheduler2 = SerialDispatchQueueScheduler(queue: queueCustom, internalSerialQueueName: "com.rxqueueanother")
    
    let queueOperation = OperationQueue()
    queueOperation.qualityOfService = .background
    let scheduler3 = OperationQueueScheduler(operationQueue: queueOperation)
    
    let imgView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 128.0, height: 128.0))
    imgView.contentMode = .scaleAspectFit
    PlaygroundPage.current.liveView = imgView
    
    let img = UIImage(named: "img.jpg")!
    let imgData = UIImagePNGRepresentation(img)! as Data
    
    let bag = DisposeBag()
    let subjectImg = PublishSubject<Data>()
    subjectImg.disposed(by: bag)
    subjectImg.observeOn(scheduler3)
        .map { UIImage(data: $0)! }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { imgView.image = $0 }, onError: nil, onCompleted: nil, onDisposed: nil)
    
    subjectImg.onNext(imgData)
}

