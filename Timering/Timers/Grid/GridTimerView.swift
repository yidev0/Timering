//
//  GridTimerView.swift
//  Timering
//
//  Created by Yuto on 2022/03/31.
//

import SwiftUI
import AVKit
import UserNotifications

class GridTimerValue: ObservableObject{
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
}

enum GridShape: Int{
    case defaultShape = 0, circle, square
}

struct GridTimerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("GridAutoPlay", store: userDefaults) var autoPlay = false
    
    var trGroup:TRGroup
    var trSession:TRSession
    var fetchedTimers: FetchRequest<TRTimer>
    
    @State var gridItems:[GridItem] = [GridItem(.fixed((375-32-12)/2), spacing: 8, alignment: .center)]
    @State var itemSize = CGSize(width: 100, height: 100)
    @State var spacing:CGFloat = 8
    
    @State var timerCount = 1
    
    let gridLimit = 6
    @State var orientation:DeviceOrientation = UIDevice.current.userInterfaceIdiom == .phone ? .vertical:.horizontal
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center){
                LazyVGrid(columns: gridItems, spacing: spacing) {
                    ForEach(fetchedTimers.wrappedValue) { timer in
                        GridTimerCell(timer: timer, size: $itemSize)
                    }
                    if fetchedTimers.wrappedValue.count < gridLimit{
                        Button {
                            withAnimation {
                                let timer = TRTimer(context: viewContext)
                                timer.title = "Test\(Int.random(in: 0..<100))"
                                timer.session = trGroup.getActiveSession()
                                timer.goalTime = 10
                                timer.tint = UIColor.random
                                timer.icon = timerSymbols.randomElement()
                                try? viewContext.save()
                            }
                        } label: {
                            ZStack{
                                Color.blue.opacity(0.2)
                                
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                            }.cornerRadius(itemSize.width / 12.8)
                        }
                        .frame(width: itemSize.width, height: itemSize.height)
                    }
                }
                .padding(.all, spacing)
            }
            .onAppear{
                DispatchQueue.main.async {
                    calculateGrid(size: geometry.size)
                }
            }
            .onChange(of: geometry.size) { size in
                calculateGrid(size: size)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init(group:TRGroup){
        self.trGroup = group
        self.trSession = group.getActiveSession()!
        self.fetchedTimers = FetchRequest(sortDescriptors: [],
                                          predicate: NSPredicate(format: "session == %@", trSession),
                                          animation: .default)
    }
    
    func calculateGrid(size:CGSize){
        withAnimation {
            orientation = size.width > size.height ? .horizontal:.vertical
            var horizontalCount:CGFloat = 0
            var verticalCount:CGFloat = 0
            if UIDevice.current.userInterfaceIdiom == .phone{
                horizontalCount = (orientation == .horizontal) ? 3:2
                verticalCount   = (orientation == .horizontal) ? 2:3
            } else {
                horizontalCount = (orientation == .horizontal) ? 3:3
                verticalCount   = (orientation == .horizontal) ? 3:3
            }
            
            let spacing:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 12:8
            let width = (size.width - (spacing*2) - spacing * (horizontalCount - 1)) / horizontalCount
            let height = (size.height - (spacing*2) - spacing * (verticalCount - 1)) / verticalCount
            let size = width > height ? height:width
            itemSize = CGSize(width: size, height: size)
            gridItems = [GridItem](repeating: GridItem(.fixed(size), spacing: spacing, alignment: .center),
                                   count: Int(horizontalCount))
            self.spacing = spacing
        }
    }
}

struct GridToolView: View{
    
    @Binding var trTimer:TRTimer
    var fetchedEntry: FetchRequest<TREntry>
//    var showInfo: () -> Void
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                
                if UIDevice.current.userInterfaceIdiom == .phone{
                    NavigationLink {
//                        NavigationView{
//                            GridTimerDetailView(gridTimer: gridTimer, showToolbar: false)
//                        }
                    } label: {
                        ZStack{
                            Circle()
                                .foregroundColor(Color(.systemFill))
                            Image(systemName: "info")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(.blue)
                        }
                        .padding(.all, 4)
                    }.frame(width: 36, height: 36, alignment: .center)
                } else {
                    Button(action: { /*showInfo()*/ }) {
                        ZStack{
                            Circle()
                                .foregroundColor(Color(.systemFill))
                            Image(systemName: "info")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(.blue)
                        }
                        .padding(.all, 4)
                    }
                    .frame(width: 36, height: 36, alignment: .center)
                }
            }
            
            Spacer()
        }
    }
}

//struct GridTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridTimerView()
//    }
//}
