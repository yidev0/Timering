//
//  TimerDetailView.swift
//  Timering
//
//  Created by Yuto on 2022/08/31.
//

import SwiftUI

struct TimerDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    var trTimer:TRTimer?
    var colors:[UIColor]
    var icons:[String]
    
    @State var color:UIColor
    @State var icon:String
    @State var title:String
    @State var isTimeSensitive:Bool
    @State var goalTime:Double
    
    @State var optionExpanded = true
    @State var colorExpanded = false
    @State var iconExpanded = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                GroupBox {
                    VStack(spacing: 16){
                        ZStack{
                            Image(systemName: icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 100, maxHeight: 100)
                                .foregroundColor(Color(color))
                        }.frame(width: 100, height: 100)
                        
                        TextField("Group.Detail.Field.Title", text: $title)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .font(.title2)
                            .background(Color(.systemFill))
                            .cornerRadius(8)
                            .frame(maxWidth: 500)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                GroupBox{
                    DisclosureGroup(isExpanded: $optionExpanded) {
                        VStack{
                            Toggle(isOn: $isTimeSensitive) {
                                Label {
                                    Text("time sensitive")
                                } icon: {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            Divider()
                            
                            DisclosureGroup{
                                TimerPicker(seconds: $goalTime)
                            } label: {
                                Label("goal", systemImage: "flag.checkered")
                                Divider()
                                Text(goalTime.toTimeStamp())
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.trailing, 2)
                        .tint(.blue)
                    } label: {
                        Label("Options", systemImage: "switch.2")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, optionExpanded ? 12:0)
                    }
                }
                .padding(.horizontal, 16)
                
                GroupBox{
                    DisclosureGroup(isExpanded: $colorExpanded) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44), spacing: 8)], spacing: 8) {
                            ForEach(colors, id: \.self) { color in
                                TimerDetailColorCell(selectedColor: $color, color: color)
                            }
                        }
                        .padding(.vertical, 4)
                    } label: {
                        Label("Color", systemImage: "paintpalette")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, colorExpanded ? 8:0)
                    }
                }
                .padding(.horizontal, 16)
                
                GroupBox{
                    DisclosureGroup(isExpanded: $iconExpanded) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44), spacing: 8)]) {
                            ForEach(icons, id: \.self) { symbol in
                                TimerDetailIconCell(selectedIcon: $icon, icon: symbol, selectedColor: $color)
                            }
                        }
                        .padding(.vertical, 4)
                    } label: {
                        Label("Icon", systemImage: "square.grid.2x2")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, iconExpanded ? 8:0)
                    }
                }
                .padding(.horizontal, 16)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if let trTimer = trTimer{
                            trTimer.icon = icon
                            trTimer.title = title
                            trTimer.tint = color
                            trTimer.goalTime = goalTime
                            trTimer.isTimeSensitive = isTimeSensitive
                        } else {
                            let trTimer = TRTimer(context: viewContext)
                            trTimer.icon = icon
                            trTimer.title = title
                            trTimer.tint = color
                            trTimer.goalTime = goalTime
                            trTimer.isTimeSensitive = isTimeSensitive
                        }
                        
                        do{
                            try viewContext.save()
                            dismiss.callAsFunction()
                        } catch {
                            print(error.localizedDescription)
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
            .groupBoxStyle(ColorGroupBox(hideLabel: true,
                                         color: Color(.secondarySystemGroupedBackground)))
            .background(Color(.systemGroupedBackground))
        }
    }
    
    init(trTimer: TRTimer? = nil) {
        self.trTimer = trTimer
        self.colors = [.systemGray, .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemMint, .systemTeal, .systemCyan, .systemBlue, .systemIndigo, .systemPurple, .systemBrown]
        self.icons = timerSymbols
        
        self._goalTime = .init(initialValue: trTimer?.goalTime ?? 5*60)
        self._isTimeSensitive = .init(initialValue: trTimer?.isTimeSensitive ?? false)
        self._color = .init(initialValue: trTimer?.tint as? UIColor ?? .systemGray)
        self._icon = .init(initialValue: trTimer?.icon ?? "trash")
        self._title = .init(initialValue: trTimer?.title ?? "Untitled".localize())
    }
}

struct TimerDetailColorCell: View{
    
    @Binding var selectedColor:UIColor
    var color:UIColor
    
    var body: some View{
        Button {
            selectedColor = color
        } label: {
            ZStack{
                Circle()
                    .foregroundColor(Color(color))
                    .frame(width: 40, height: 40)
            }
            .frame(width: 48, height: 48)
            .overlay(
                Circle()
                    .stroke(lineWidth: selectedColor == color ? 2:0)
                    .foregroundColor(Color(color))
            )
        }
    }
}

struct TimerDetailIconCell: View{
    
    @Binding var selectedIcon:String
    let icon:String
    @Binding var selectedColor:UIColor
    
    
    var body: some View{
        Button {
            withAnimation {
                selectedIcon = icon
            }
        } label: {
            ZStack{
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.system(.body).weight(.semibold))
                    .foregroundColor(selectedIcon == icon ? .white:.secondary)
                    .padding(.all, 6)
            }
            .frame(width: 44, height: 44)
            .background(selectedIcon == icon ? Color(selectedColor):Color.clear)
            .cornerRadius(44/6.4)
        }
    }
}

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerDetailView()
    }
}
