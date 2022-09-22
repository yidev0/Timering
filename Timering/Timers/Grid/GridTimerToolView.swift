//
//  GridToolView.swift
//  Timering
//
//  Created by Yuto on 2022/09/17.
//

import SwiftUI

struct GridTimerToolView: View{
    
    @Binding var trTimer:TRTimer
    var fetchedEntry: FetchRequest<TREntry>
    var showInfo: () -> Void
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                
                Button(action: { showInfo() }) {
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
            
            Spacer()
        }
    }
}

//struct GridToolView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridToolView()
//    }
//}
