//
//  Optional+Extension.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
