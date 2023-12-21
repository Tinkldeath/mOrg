//
//  TextViewModel.swift
//  mOrganization
//
//  Created by Dima on 12.11.23.
//

import Foundation
import RxRelay


final class TextViewModel {
    
    private(set) var title: BehaviorRelay<String> = BehaviorRelay(value: "")
    private(set) var text: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    init(_ title: String) {
        self.title.accept(title)
    }
    
    func loadTextFromUrl(_ url: URL) {
        guard let text = try? String(contentsOf: url) else { return }
        self.text.accept(text)
    }
    
}
