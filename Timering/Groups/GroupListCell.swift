//
//  GroupListCell.swift
//  Timering
//
//  Created by Yuto on 2023/01/24.
//

import Foundation
import SwiftUI

struct GroupListCell: View{
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var group:TRGroup
    @Binding var popGroup:TRGroup?
    @Binding var sheetSession:TRSession?
    
    var LinkCell: some View{
        NavigationLink {
            TimerView(group: group)
        } label: {
            Label(group.title ?? "Untitled", systemImage: group.icon ?? "folder")
        }
    }
    
    var ButtonCell: some View{
        Button {
            sheetSession = group.getActiveSession()
        } label: {
            Label(title: { Text(group.title ?? "Untitled").foregroundColor(.primary) },
                  icon: { Image(systemName: group.icon ?? "folder") })
        }
    }
    
    var TrashButton: some View{
        Button(role: .destructive) {
            group.delete()
        } label: {
            Label("Sidebar.Button.Delete", systemImage: "trash")
        }
    }
    
    var DetailButton: some View{
        Button {
            popGroup = group
        } label: {
            Label("Sidebar.Button.ShowDetail", systemImage: "info.circle")
        }
    }
    
    var body: some View{
        Group{
            if UIDevice.current.userInterfaceIdiom == .phone{
                ButtonCell
            } else {
                LinkCell
            }
        }
        .swipeActions {
            TrashButton
            DetailButton
        }
        .contextMenu{
            DetailButton
            TrashButton
        }
    }
}
