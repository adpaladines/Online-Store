//
//  OtherCharts.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/22/23.
//

import SwiftUI
import Charts
import HidableTabView

struct OtherCharts: View {
    
    var body: some View {
        VStack {
            HeaderBarView(title: "Statistics", letftButtonHidden: true, rightButtonHidden: true)
            ScrollView {
                VStack {
                    GroupBox ("Spent (\(currentWeek.first!.month) \(currentWeek.first!.year) - \(currentWeek.last!.month)  \(currentWeek.last!.year))") {
                        Chart(currentWeek) {
                            LineMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("Spent", $0.amount)
                            )
                            .interpolationMethod(.catmullRom)
                        }
                        .foregroundStyle(Color.mint.gradient)
                    }
                    
                    GroupBox ("Spent (\(currentWeek.first!.month) \(currentWeek.first!.year) - \(currentWeek.last!.month)  \(currentWeek.last!.year))") {
                        Chart(currentWeek) {
                            BarMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("Spent", $0.amount)
                            )
                            
                        }.foregroundStyle(Color.mint.gradient)
                    }
                    
                    GroupBox ("Spent (\(currentWeek.first!.month) \(currentWeek.first!.year) - \(currentWeek.last!.month)  \(currentWeek.last!.year))") {
                        Chart(currentWeek) {
                            PointMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("Spent", $0.amount)
                            )
                            
                        }
                    }
                    
    //                GroupBox ("Spent (\(currentWeek.first!.month) \(currentWeek.first!.year) - \(currentWeek.last!.month)  \(currentWeek.last!.year))") {
    //                    Chart(currentWeek) {
    //                        RectangleMark(
    //                            x: .value("Week Day", $0.weekday, unit: .day),
    //                            y: .value("Spent", $0.steps)
    //                        )
    //                    }
    //                }
                    
                    GroupBox ("Spent (\(currentWeek.first!.month) \(currentWeek.first!.year) - \(currentWeek.last!.month)  \(currentWeek.last!.year))") {
                        Chart(currentWeek) {
                            AreaMark(
                                x: .value("Week Day", $0.weekday, unit: .day),
                                y: .value("Spent", $0.amount)
                            )
                            .interpolationMethod(.catmullRom(alpha: 0.4))
                        }
                    }
                }
            }
            
        }
        .padding()
        .onAppear {
            UITabBar.showTabBar(animated: true)
        }
    }
}


struct OtherCharts_Previews: PreviewProvider {
    static var previews: some View {
        OtherCharts()
    }
}
