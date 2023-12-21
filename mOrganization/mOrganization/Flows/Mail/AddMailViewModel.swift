//
//  AddMailViewModel.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import RxRelay

final class AddMailViewModel {
    
    let isValidInput = BehaviorRelay<Bool>(value: false)
    let recievers = BehaviorRelay<[MailReciever]>(value: [])
    let selectedRecieverRelay = BehaviorRelay<IndexPath?>(value: nil)
    let mailSentRelay = PublishRelay<Bool>()
    let loadingRelay = PublishRelay<Void>()
    
    private var businessManager: BusinessManager
    private var authManager: AuthManager
    private var employeeManager: EmployeeManager
    private var mailManager: MailManager
    let imageManager: ImageManager
    
    private var input: Input?
    private var selectedReciever: String?
    
    init(_ managerFactory: ManagerFactory) {
        self.businessManager = managerFactory.businessManager
        self.authManager = managerFactory.authManager
        self.employeeManager = managerFactory.employeeManager
        self.mailManager = managerFactory.mailManager
        self.imageManager = managerFactory.imageManager
        initialize()
    }
    
    func enterInput(_ input: Input) {
        self.input = input
        if let selectedReciever = selectedReciever {
            self.input?.reciever = selectedReciever
        }
        isValidInput.accept(input.isValid())
    }
    
    func didSelectReciever(_ indexPath: IndexPath) {
        selectedRecieverRelay.accept(indexPath)
        let reciever = recievers.value[indexPath.row]
        guard let uid = reciever.uid, var input = input else { return }
        input.reciever = uid
        selectedReciever = uid
        isValidInput.accept(input.isValid())
    }
    
    func send() {
        guard var input = input, let selectedReciever = selectedReciever, let userId = authManager.currentUser else { return }
        input.reciever = selectedReciever
        guard input.isValid() else { return }
        let mail = Mail(sender: userId, reciever: input.reciever, header: Ciper.seal(input.header), theme: Ciper.seal(input.theme), content: Ciper.seal(input.text), attachments: [])
        loadingRelay.accept(())
        mailManager.createMail(mail) { [weak self] completed in
            self?.mailSentRelay.accept(completed)
        }
    }
}

extension AddMailViewModel {
    
    struct Input {
        var header: String
        var theme: String
        var text: String
        var reciever: String
        
        func isValid() -> Bool {
            return !header.isEmpty && !theme.isEmpty && !text.isEmpty && !reciever.isEmpty
        }
    }
    
    private func initialize() {
        guard let userId = authManager.currentUser else { return }
        if let businessId = businessManager.currentBusiness {
            employeeManager.observeEmployee(for: businessId) { [weak self] employee in
                let recievers = employee.filter({ $0.uid != userId }).map({ MailReciever(uid: $0.uid, title: $0.fullName, subtitle: $0.type.rawValue, imageUrl:  $0.imageUrl) })
                self?.recievers.accept(recievers)
            }
        }
        else if let employeeId = employeeManager.currentEmployee {
            employeeManager.observeEmployee(employeeId) { [weak self] employee in
                guard let employee = employee else { return }
                self?.businessManager.observeBusiness(employee.businessId, { business in
                    guard let business = business, business.uid != userId, let businessId = business.uid else { return }
                    var results = [MailReciever]()
                    results.append(MailReciever(uid: business.uid, title: business.title, subtitle: business.type.rawValue))
                    self?.employeeManager.observeEmployee(for: businessId, { employee in
                        let recievers = employee.filter({ $0.uid != userId }).map({ MailReciever(uid: $0.uid, title: $0.fullName, subtitle: $0.type.rawValue, imageUrl: $0.imageUrl) })
                        results.append(contentsOf: recievers)
                        self?.recievers.accept(results)
                    })
                })
            }
        }
    }
}
