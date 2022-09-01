//
//  RingSettingsView.swift
//  Timering
//
//  Created by Yuto on 2022/04/02.
//

import SwiftUI

struct RingSettingsView: View {
    
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    
    let colors:[UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemBlue, .systemTeal, .systemGreen, .systemPurple, .systemIndigo, .systemGray, .label]
    
    var body: some View {
        Toggle(isOn: $vibrate) {
            Label("Settings.Ring.PlayVibration", systemImage: "waveform")
        }
    }
}

struct GridColorSettings: View{
    
    enum SelectedColor: Int, Identifiable{
        case blue, gray, rainbow
        
        var id:Int{
            self.rawValue
        }
    }
    
    @AppStorage("Settings.Ring.DefaultColor", store: userDefaults) var defaultColor = 0
    
    var body: some View{
        List{
            Section{
                Button(action: { defaultColor = 0 }) {
                    HStack{
                        Text("Settings.Ring.Color.Blue")
                        Spacer()
                        if defaultColor == 0{
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: { defaultColor = 0 }) {
                    HStack{
                        Spacer()
                        ZStack{
                            ForEach(0..<6) { i in
                                Circle()
                                    .frame(width: 14 * CGFloat(6-i), height: 14 * CGFloat(6-i))
                                    .foregroundColor([Color(hue: 219/359, saturation: 0.20, brightness: 100/100),
                                                      Color(hue: 219/359, saturation: 0.40, brightness: 100/100),
                                                      Color(hue: 219/359, saturation: 0.60, brightness: 100/100),
                                                      Color(hue: 219/359, saturation: 0.80, brightness: 100/100),
                                                      Color(hue: 219/359, saturation: 0.94, brightness: 100/100),
                                                      Color(hue: 219/359, saturation: 0.96, brightness:  75/100)][i])
                                    .id("Gray\(i)")
                            }
                        }
                        Spacer()
                    }
                }
            }
            
            Section{
                Button(action: { defaultColor = 1 }) {
                    HStack{
                        Text("Settings.Ring.Color.Gray")
                        Spacer()
                        if defaultColor == 1{
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: { defaultColor = 1 }) {
                    HStack{
                        Spacer()
                        ZStack{
                            ForEach(0..<6) { i in
                                Circle()
                                    .frame(width: 12 * CGFloat(6-i), height: 12 * CGFloat(6-i))
                                    .foregroundColor([.gray, Color(.systemGray2), Color(.systemGray3), Color(.systemGray4), Color(.systemGray5), Color(.systemGray6)][i])
                                    .id("Gray\(i)")
                            }
                        }
                        Spacer()
                    }
                }
            }
            
            Section{
                Button(action: { defaultColor = 2 }) {
                    HStack{
                        Text("Settings.Ring.Color.Rainbow")
                        Spacer()
                        if defaultColor == 2{
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: { defaultColor = 2 }) {
                    HStack{
                        Spacer()
                        ZStack{
                            ForEach(0..<6) { i in
                                Circle()
                                    .frame(width: 12 * CGFloat(6-i), height: 12 * CGFloat(6-i))
                                    .foregroundColor([.red, .orange, .yellow, .blue, .green, .purple].reversed()[i])
                                    .id("Rainbow\(i)")
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct TimerPicker: UIViewRepresentable{
    
    @State var picker = UIPickerView()
    @State var hour:Int
    @State var minute:Int
    @State var second:Int
    
    @Binding var seconds:Double
    
    var hourLabel = UILabel()
    var minuteLabel = UILabel()
    var secondLabel = UILabel()
    
    init(seconds:Binding<Double>){
        self._seconds = seconds
        
        self.hour   = Int(seconds.wrappedValue)  /  60 / 60
        self.minute = (Int(seconds.wrappedValue) % (60 * 60)) / 60
        self.second = Int(seconds.wrappedValue)  %  60
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = picker
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        
        picker.selectRow(hour, inComponent: 0, animated: false)
        picker.selectRow(minute, inComponent: 2, animated: false)
        picker.selectRow(second, inComponent: 4, animated: false)
        
        hourLabel.text = "Settings.Ring.Time.Hour".localize()
        minuteLabel.text = "Settings.Ring.Time.Min".localize()
        secondLabel.text = "Settings.Ring.Time.Sec".localize()
        context.coordinator.setPickerLabels(labels: [1:hourLabel, 3:minuteLabel, 5:secondLabel], containedView: picker)
        return picker
    }
    
    func updateUIView(_ uiPickerView: UIPickerView, context: Context) {
//        context.coordinator.setPickerLabels(labels: [1:hourLabel, 3:minuteLabel, 5:secondLabel], containedView: picker)
    }
}

extension TimerPicker{
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
        
        let hours = (0...23).map { $0 }
        let minutes = (0...59).map { $0 }
        let seconds = (0...59).map { $0 }
        var parent: TimerPicker
        
        init(_ parent: TimerPicker) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            6
        }
        
        func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
            
            let fontSize = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
            let labelWidth:CGFloat = (containedView.bounds.width) / 7
            let numberWidth = (containedView.bounds.width) / 6
            let x:CGFloat = parent.picker.frame.origin.x
            let y:CGFloat = (parent.picker.frame.size.height / 2) - (fontSize / 2)
            
            for i in 0...parent.picker.numberOfComponents {
                
                if let label = labels[i] {
                    label.removeFromSuperview()
                    
                    //0 1 2 3 4 5
                    label.frame = CGRect(x: x + (labelWidth * CGFloat(i/2) + (numberWidth * CGFloat((i+1)/2))),
                                         y: y,
                                         width: labelWidth, height: fontSize)
                    label.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
                    label.backgroundColor = .clear
                    label.textAlignment = NSTextAlignment.center
                    label.textColor = .secondaryLabel
                    
                    parent.picker.addSubview(label)
                    parent.picker.bringSubviewToFront(label)
                }
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component%2 == 1{
                return 0
            } else {
                return [hours.count, minutes.count, seconds.count][component/2]
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            if component % 2 == 0{
                return pickerView.bounds.width / 6
            } else {
                return pickerView.bounds.width / 7
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component%2 == 1{
                return ""
            } else {
                return "\(row)"
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.hour   = pickerView.selectedRow(inComponent: 0)
            parent.minute = pickerView.selectedRow(inComponent: 2)
            parent.second = pickerView.selectedRow(inComponent: 4)
            
            parent.hourLabel.text = parent.hour > 1 ? "Settings.Ring.Time.Hours".localize():"Settings.Ring.Time.Hour".localize()
            
            if parent.hour + parent.minute + parent.second == 0{
                parent.picker.selectRow(1, inComponent: 4, animated: true)
                parent.second = 1
            }
            
            parent.seconds = Double(parent.second + parent.minute*60 + parent.hour*60*60)
        }
    }
}

struct RingSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RingSettingsView()
    }
}
