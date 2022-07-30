//
//  IconsView.swift
//  Timering
//
//  Created by Yuto on 2022/04/02.
//

import SwiftUI

struct IconsView: View {
    
    let iconNames = ["DefaultIcon", "wave1", "wave2", "wave3"]
    
    var body: some View {
        List{
            ForEach(iconNames, id: \.self) { iconName in
                Button {
                    UIApplication.shared.setAlternateIconName(iconName == "DefaultIcon" ? nil:iconName)
                } label: {
                    HStack(spacing: 16){
                        Image(uiImage: UIImage(named: iconName)!)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(50/6.4)
                        Text(iconName)
                    }
                }
            }
        }
        .navigationTitle("Icons")
    }
}

struct IconsView_Previews: PreviewProvider {
    static var previews: some View {
        IconsView()
    }
}
