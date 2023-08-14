//
//  WideButton.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI

struct WideButton: View {
    
    @State var text: String
    @State var color: UIColor = .systemMint
    @State var disabled: Bool = false
    
    let action: () -> Void
    
    var body: some View {
        HStack {
            ViewThatFits(in: .horizontal) {
                if disabled {
                    Button {
                        
                    } label: {
                        Text(text)
                            .font(Font.system(size: 20, weight: .semibold))
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                }else {
                    Button {
                        action()
                    } label: {
                        Text(text)
                            .font(Font.system(size: 20, weight: .semibold))
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                }
                
            }
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(disabled ? .gray : .mint)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 0.5)
            )
        }
    }
}

struct WideButton_Previews: PreviewProvider {
    
    static var previews: some View {
        WideButton(text: "Button", color: UIColor.systemMint, action: {
            
        })
    }
}
