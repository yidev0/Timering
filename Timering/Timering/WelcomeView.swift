//
//  WelcomeView.swift
//  Timering
//
//  Created by Yuto on 2022/05/10.
//

import SwiftUI
import UserNotifications

@available(iOS 15.0, *)
struct WelcomeView: View{
    
    enum WelcomeType:Int{
        case welcome, feature, permission
    }
    @Namespace var namespace
    @Environment(\.presentationMode) var presentationMode
    @State var welcomeType:WelcomeType = .welcome
    @State var playBackground = true
    @AppStorage("hasShownWelcomeBeta", store: userDefaults) var welcome = false
    
    var body: some View{
        ZStack{
            Color(hue: 219/359, saturation: 0.10, brightness: 100/100)
                .ignoresSafeArea()
            
            LayeredCircleBackground(play: $playBackground)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Button(action: { playBackground.toggle() }) {
                        ZStack{
                            Image(systemName: playBackground ? "pause":"play")
                                .padding(.all, 8)
                        }
                        .frame(width: 32, height: 32, alignment: .center)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(Circle().strokeBorder())
                        .foregroundColor(.white)
                    }
                    .contentShape(Circle())
                    Spacer()
                }.padding()
                
                Spacer()
                
                VStack{
                    if welcomeType != .welcome{
                        HStack{
                            Button {
                                withAnimation {
                                    switch welcomeType {
                                    case .welcome:
                                        break
                                    case .feature:
                                        welcomeType = .welcome
                                    case .permission:
                                        welcomeType = .feature
                                    }
                                }
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .font(.subheadline)
                                    .padding(.all, 8)
                            }
                            .background(Circle().foregroundColor(Color(.systemFill)))
                            .hoverEffect()
                            .accessibilityLabel(Text("Welcome.Button.Title.Back"))
                            
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                    
                    switch welcomeType {
                    case .welcome:
                        WelcomeInitialView(namespace: namespace)
                    case .feature:
                        WelcomeFeatureView(namespace: namespace)
                    case .permission:
                        WelcomePermissionView(namespace: namespace)
                    }
                    
                    Button {
                        withAnimation {
                            switch welcomeType {
                            case .welcome:
                                welcomeType = .feature
                            case .feature:
                                welcomeType = .permission
                            case .permission:
                                welcome = true
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        switch welcomeType {
                        case .welcome:
                            Text("Welcome.Button.Continue")
                                .frame(maxWidth: 360)
                        case .feature:
                            Text("Welcome.Button.Continue")
                                .frame(maxWidth: 360)
                        case .permission:
                            Text("Welcome.Button.Close")
                                .frame(maxWidth: 360)
                        }
                    }
                    .frame(maxWidth: 360)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(8)
                .shadow(color: .gray.opacity(0.6), radius: 6)
                .padding()
            }
        }
        .interactiveDismissDisabled()
    }
}

struct WelcomeInitialView: View{
    
    var namespace: Namespace.ID
    
    var body: some View{
        HStack{
            Spacer()
            RoundedRectangle(cornerRadius: 100/6.4)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 100)
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.4), radius: 4)
                .matchedGeometryEffect(id: "AppIcon", in: namespace)
                .accessibilityLabel(Text("Welcome.Icon"))
            Spacer()
        }
        
        Text("Welcome.Title.Timering")
            .font(.title)
            .bold()
            .accessibilityAddTraits(.isHeader)
            .matchedGeometryEffect(id: "Title", in: namespace)
        
        Spacer().frame(height: 60)
    }
}

@available(iOS 15.0, *)
struct WelcomeFeatureView: View{
    
    @AccessibilityFocusState var accessibilityFocus:Bool
    var namespace: Namespace.ID
    
    var body: some View{
        VStack{
            HStack(spacing: 16){
                RoundedRectangle(cornerRadius: 40/6.4)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.4), radius: 4)
                    .matchedGeometryEffect(id: "AppIcon", in: namespace)
                    .accessibilityLabel(Text("Welcome.Icon"))
                Text("Welcome.Title.Features")
                    .font(.title3)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                    .matchedGeometryEffect(id: "Title", in: namespace)
                    .accessibilityFocused($accessibilityFocus)
                Spacer()
            }
            .padding(.vertical, 16)
            
            ScrollView{
                WelcomeViewCell(color: .blue, image: "circle.circle", detail: "Ring")
                Divider()
                if UIDevice.current.userInterfaceIdiom == .phone{
                    WelcomeViewCell(color: .blue, image: "square.grid.2x2", detail: "GridiPhone")
                } else {
                    WelcomeViewCell(color: .blue, image: "square.grid.2x2", detail: "GridiPad")
                }
                Divider()
                WelcomeViewCell(color: .blue, image: "arrow.triangle.2.circlepath", detail: "Switch")
                Divider()
                WelcomeViewCell(color: .blue, image: "slider.horizontal.3", detail: "Customize")
//                Divider()
//                WelcomeViewCell(color: .blue, image: "hand.raised", detail: "Privacy")
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() +  0.1) {
                accessibilityFocus = true
            }
        }
    }
}

@available(iOS 15.0, *)
struct WelcomePermissionView: View{
    
    @AccessibilityFocusState var accessibilityFocus:Bool
    var namespace: Namespace.ID
    
    @State var allowNotification:Bool
    
    var body: some View{
        VStack{
            HStack(spacing: 16){
                RoundedRectangle(cornerRadius: 40/6.4)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.4), radius: 4)
                    .matchedGeometryEffect(id: "AppIcon", in: namespace)
                    .accessibilityLabel(Text("Welcome.Icon"))
                Text("Welcome.Title.Options")
                    .font(.title3)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                    .matchedGeometryEffect(id: "Title", in: namespace)
                    .accessibilityFocused($accessibilityFocus)
                Spacer()
            }
            .padding(.vertical, 16)
            
            ScrollView{
                WelcomePermissionCell(isSelected: $allowNotification, detail: "Notification", image: "bell.badge"){
                    
                }.disabled(allowNotification)
                
                Divider()
                
                Link(destination: URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!) {
                    HStack{
                        Label("Welcome.Title.OpenSettings", systemImage: "gear")
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() +  0.1) {
                accessibilityFocus = true
            }
            
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permision in
                if permision.authorizationStatus == .authorized{
                    self.allowNotification = true
                }
            })
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                allowNotification = success
                print(error ?? "success")
            }
        }
    }
    
    init(namespace: Namespace.ID){
        self.namespace = namespace
        self._allowNotification = /*State<Bool>*/.init(initialValue: false)
    }
}

struct LayeredCircleBackground: View{
    
    @Binding var play:Bool
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let colorSet = [Color(hue: 219/359, saturation: 0.20, brightness: 100/100),
                    Color(hue: 219/359, saturation: 0.40, brightness: 100/100),
                    Color(hue: 219/359, saturation: 0.60, brightness: 100/100),
                    Color(hue: 219/359, saturation: 0.80, brightness: 100/100),
                    Color(hue: 219/359, saturation: 0.94, brightness: 100/100),
                    Color(hue: 219/359, saturation: 0.96, brightness: 75/100),
                    Color(hue: 219/359, saturation: 0.98, brightness: 50/100)]
    
    @State var colors:[Color] = [Color(hue: 219/359, saturation: 0.40, brightness: 100/100)]
    @State var sizes:[CGFloat] = [1]
    @State var viewOffset:CGSize = .zero
    
    @State var dif:CGFloat = 1
    @State var max:CGFloat = 1
    
    @State var index = 2
    @State var change = 1
    
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                ForEach(0..<sizes.count, id: \.self) { i in
                    Circle()
                        .frame(height: sizes[i])
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(colors[i])
                }
                Circle()
                    .frame(height: geometry.size.height*1.6)
                    .foregroundColor(.clear)
            }
            .offset(x: -(geometry.size.height * 1.6 - geometry.size.width)/2,
                    y: -300)
            .onReceive(timer) { _ in
                if !play { return }
                for i in 0..<sizes.count{
                    withAnimation {
                        if sizes[i] < max{
                            sizes[i] += (geometry.size.height*0.005)
                        } else {
                            colors[i] = .clear
                        }
                    }
                }
                if sizes.last! > dif{
                    sizes.append(1)
                    colors.append(colorSet[index])
                    index += change
                    if index == colorSet.count - 1{
                        change = -1
                    } else if index == 0 {
                        change = 1
                    }
                }
            }
            .onAppear {
                dif = geometry.size.height*0.2
                max = geometry.size.height*1.6 - 2
            }
            .onChange(of: play) { newValue in
                if newValue{
                    startTimer()
                } else {
                    stopTimer()
                }
            }
        }
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    }
}

@available(iOS 15.0, *)
struct WelcomeViewCell: View{
    
    var color:Color
    var image:String
    var detail:String
    
    var body: some View{
        HStack{
            ZStack{
                Image(systemName: image)
                    .foregroundColor(color)
                    .symbolRenderingMode(.hierarchical)
            }
            .frame(minWidth: 42)
            .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 2){
                Text("Welcome.Title.\(detail)".localize())
                Text("Welcome.Detail.\(detail)".localize())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            
            Spacer()
        }
        .listItemTint(color)
    }
}

@available(iOS 15.0, *)
struct WelcomePermissionCell: View{
    
    @Namespace var namespace
    @Binding var isSelected:Bool
    var detail:String
    var image:String
    
    var action: () -> Void
    
    var body: some View{
        Button {
            action()
        } label: {
            HStack(spacing: 12){
                ZStack{
                    RoundedRectangle(cornerRadius: 24/6.4)
                        .strokeBorder()
                        .frame(width: 24, height: 24, alignment: .center)
                    if isSelected{
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 12, height: 12, alignment: .center)
                            .foregroundColor(.blue)
                            .padding(.all, 4)
                    }
                }
                .frame(minWidth: 42)
                .aspectRatio(1, contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 4){
                    Label("Welcome.Title.Permission.\(detail)".localize(), systemImage: image)
                        .foregroundColor(.primary)
//                        .accessibilityLinkedGroup(id: "Content", in: namespace)
                    Text("Welcome.Detail.Permission.\(detail)".localize())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
//                        .accessibilityLinkedGroup(id: "Content", in: namespace)
                }
                
                Spacer()
            }
        }
        .accessibilityAddTraits(traits())
    }
    
    func traits() -> AccessibilityTraits{
        if isSelected{
            return [.isSelected]
        } else {
            return []
        }
    }
}

@available(iOS 15.0, *)
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
