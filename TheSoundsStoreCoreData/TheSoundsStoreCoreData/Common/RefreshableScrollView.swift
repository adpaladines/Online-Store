//
//  RefreshableScrollView.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/21/23.
//

import SwiftUI

public struct RefreshableScrollView<Content: View>: View {
    var content: Content
    var onRefresh: () -> Void

    public init(content: @escaping () -> Content, onRefresh: @escaping () -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }

    public var body: some View {
        List {
            content
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .refreshable {
            onRefresh()
        }
    }
}

//struct RefreshableScrollView_Previews: PreviewProvider {
//    static var previews: some View {
////        RefreshableScrollView(content: {
////            
////        }, onRefresh: {
////            print("Refresh View")
////        })
//    }
//}
