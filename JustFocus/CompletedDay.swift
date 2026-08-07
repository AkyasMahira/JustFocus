//
//  CompletedDay.swift
//  JustFocus
//
//  Created by Mac on 07/08/26.
//

import Foundation
import SwiftData

@Model
final class CompletedDay {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
}
