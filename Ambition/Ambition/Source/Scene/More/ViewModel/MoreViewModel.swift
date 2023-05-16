import Foundation
import RxMoya
import Moya
import RxSwift
import RxCocoa

class MoreViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let logout: Signal<Void>
        let quitUser: Signal<Void>
    }

    struct Output {
        let isLogoutSucceed: Signal<Void>
        let isQuitUserSucceed: Signal<Void>
    }

    func transform(input: Input) -> Output {
        let service = AuthService()
        let isLogoutSucceed = PublishRelay<Void>()
        let isQuitUserSucceed = PublishRelay<Void>()

        input.logout.asObservable()
            .flatMap {
                service.logout()
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isLogoutSucceed.accept(())
                default:
                    print("err")
                }
            })
            .disposed(by: disposedBag)

        input.quitUser.asObservable()
            .flatMap {
                service.deleteUser()
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isQuitUserSucceed.accept(())
                default:
                    print("err")
                }
            })
            .disposed(by: disposedBag)

        return Output(
            isLogoutSucceed: isLogoutSucceed.asSignal(),
            isQuitUserSucceed: isQuitUserSucceed.asSignal()
        )
    }
}
