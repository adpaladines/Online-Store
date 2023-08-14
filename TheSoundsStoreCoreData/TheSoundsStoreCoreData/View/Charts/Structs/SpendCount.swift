//
//  asdad.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/22/23.
//

import Foundation

struct SpendCount: Identifiable {

    let id = UUID()
    let weekday: Date
    let amount: Int
    
    init(day: String, amount: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        self.weekday = formatter.date(from: day) ?? Date.distantPast
        self.amount = amount
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: weekday)
        return nameOfMonth
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let nameOfMonth = dateFormatter.string(from: weekday)
        return nameOfMonth
    }
}



let currentWeek: [SpendCount] = [
    SpendCount(day: "20230717", amount: 220),
    SpendCount(day: "20230718", amount: 230),
    SpendCount(day: "20230719", amount: 280),
    SpendCount(day: "20230720", amount: 100),
    SpendCount(day: "20230721", amount: 53),
    SpendCount(day: "20230722", amount: 104),
    SpendCount(day: "20230723", amount: 43),
    SpendCount(day: "20230801", amount: 156),
    SpendCount(day: "20230802", amount: 36),
    SpendCount(day: "20230803", amount: 98),
    SpendCount(day: "20230804", amount: 14),
    SpendCount(day: "20230805", amount: 40)
]
