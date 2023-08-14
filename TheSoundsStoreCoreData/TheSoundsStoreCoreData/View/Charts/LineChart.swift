//
//  ChartsScreen.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/22/23.
//

import SwiftUI
import Charts


struct LineChart1: View {

    var body: some View {
        VStack {
            GroupBox ( "Line Chart - Step Count") {
                Chart {
                    ForEach(currentWeek) {
                        LineMark(
                            x: .value("Week Day", $0.weekday, unit: .day),
                            y: .value("Step Count", $0.amount)
                        )
                    }
                }
            }

            GroupBox ( "Line Chart - Step Count") {
                Chart(currentWeek) {
                    LineMark(
                        x: .value("Week Day", $0.weekday, unit: .day),
                        y: .value("Step Count", $0.amount)
                    )
                }
            }
        }
    }
}
struct LineChart1_Previews: PreviewProvider {
    
    static var previews: some View {
        LineChart1()
            .environmentObject(ProductsListViewModel(networkManager: NetworkManager()))
    }
    

}
