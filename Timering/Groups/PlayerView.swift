//
//  PlayerView.swift
//  Timering
//
//  Created by Yuto on 2023/02/04.
//

import Foundation
import SwiftUI

struct PlayerView<Label: View, Content: View>: View {
    
    @Namespace var namespace
    @Binding var style: PlayerStyle
    @State var visibility: Visibility = .visible
    
    @State var viewHeight: CGFloat = 0
    @State var cellOffset: CGFloat = 0
    @State var dragOrigin: CGPoint = .zero
    
    var content: Content
    var label: Label
    
    init(_ style: Binding<PlayerStyle>,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder label: @escaping () -> Label
    ) {
        self._style = style
        self.label = label()
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            switch style {
            case .compact:
                Spacer()
                cell
                    .matchedGeometryEffect(id: "Player", in: namespace)
                Divider()
            case .fullScreen:
                fullScreen
            }
        }
        .toolbar(visibility, for: .tabBar)
        .animation(.easeInOut, value: style)
        .onChange(of: style) { newValue in
            switch newValue {
            case .compact:
                visibility = .visible
            case .fullScreen:
                visibility = .hidden
            }
        }
        .highPriorityGesture(
            DragGesture()
                .onChanged { value in
                    if dragOrigin == .zero {
                        dragOrigin = value.location
                    } else {
                        if value.location.y > dragOrigin.y {
                            cellOffset = value.location.y - dragOrigin.y
                        }
                    }
                    checkCollpase(0.5)
                }
                .onEnded { value in
                    withAnimation {
                        cellOffset = 0
                        dragOrigin = .zero
                    }
                    checkCollpase(0.3)
                }
        )
    }
    
    var fullScreen: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: cellOffset)
                cell
                Divider()
                    .background(Color.secondary)
                VStack {
                    content
                    Spacer()
                }
                .opacity(style == .fullScreen ? 1:0)
                .animation(.easeOut, value: style)
                .transition(.move(edge: .bottom))
                .background(.thinMaterial)
                .matchedGeometryEffect(id: "Player", in: namespace)
            }
            .onAppear {
                viewHeight = geometry.size.height
            }
            .onChange(of: geometry.size.width) { newValue in
                viewHeight = newValue
            }
        }
    }
    
    var cell: some View {
        Button {
            withAnimation {
                style = (style == .compact) ? .fullScreen:.compact
            }
        } label: {
            label
        }
        .background(.thinMaterial)
        .matchedGeometryEffect(id: "Cell", in: namespace)
    }
    
    func checkCollpase(_ percentage: CGFloat) {
        print(cellOffset, viewHeight * percentage)
        if cellOffset > viewHeight * percentage && cellOffset > 0 {
            style = .compact
        }
    }
}

struct PlayerCellView: View {
    
    let symbol: String
    let imageColor: Color
    var title: String
    var subtitle: String
    var value: Double
    
    init(symbol: String, imageColor: Color, title: String, subtitle: String, value: Double) {
        self.symbol = symbol
        self.imageColor = imageColor
        self.title = title
        self.subtitle = subtitle
        self.value = value
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: symbol)
                .foregroundStyle(imageColor.gradient)
            
            VStack(alignment: .leading) {
                Text("aaaaaa")
                    .font(.body)
                    .foregroundColor(.primary)
                Text("aaaaaa")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
            
            Spacer()
            
            Text("\(value, specifier: "%.1f")")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerView(.constant(.compact)) {
                ScrollView {
                    ForEach(0..<10) { i in
                        Text("\(i)")
                    }
                }
            } label: {
                PlayerCellView(symbol: "camera",
                           imageColor: .blue,
                           title: "Title",
                           subtitle: "Subtitle",
                           value: 12.3)
            }
            
            PlayerCellView(symbol: "camera",
                       imageColor: .blue,
                       title: "Title",
                       subtitle: "Subtitle",
                       value: 12.3)
            
            PlayerCellView(symbol: "car",
                       imageColor: .orange,
                       title: "Title",
                       subtitle: "Subtitle",
                       value: 123.4)
        }
    }
}

