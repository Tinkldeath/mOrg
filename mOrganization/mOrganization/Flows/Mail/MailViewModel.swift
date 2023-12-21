//
//  BusinessMailViewModel.swift
//  mOrganization
//
//  Created by Dima on 21.12.23.
//

import Foundation
import RxRelay

final class MailViewModel {
    
    let mail = BehaviorRelay<[Mail]>(value: [])
    
    private var mailManager: MailManager
    private var authManager: AuthManager
    
    init(_ managerFactory: ManagerFactory) {
        self.mailManager = managerFactory.mailManager
        self.authManager = managerFactory.authManager
        initialize()
    }
}

private extension MailViewModel {
    
    private func initialize() {
        guard let userId = authManager.currentUser else { return }
        mailManager.observeMail(for: userId) { [weak self] mail in
            self?.mail.accept(mail)
        }
    }
}
