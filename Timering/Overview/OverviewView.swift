//
//  OverviewView.swift
//  Timering
//
//  Created by Yuto on 2022/08/18.
//

import SwiftUI

struct OverviewView: View {
    
    let column = [GridItem(.flexible(minimum: (375-32-8)/2,
                                     maximum: (420-32)),
                           spacing: 8)]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                LazyVGrid(columns: column, spacing: 8) {
                    GroupBox {
                        Text("Total")
                            .padding()
                    } label: {
                        Label("Overview.Header.Total", systemImage: "calendar")
                    }
                    
                    GroupBox {
                        Text("Total Today")
                            .padding()
                    } label: {
                        Label("Overview.Header.TodayTotal", systemImage: "calendar")
                    }
                }.padding()
                Text("Hello, World!")
            }
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
