//
//  GroupDetailView.swift
//  Timering
//
//  Created by Yuto on 2022/08/18.
//

import SwiftUI

struct GroupDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("Group.Detail.AutoFill", store: userDefaults) var autoFill = false
    
    var group:TRGroup?
    @State var title:String
    @State var icon:String
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100, maxHeight: 100)
                
                TextField("Group.Detail.Field.Title", text: $title)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .font(.title2)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(8)
                    .padding()
                Spacer()
                
                Toggle(isOn: $autoFill) {
                    Text("Group.Detail.AutoFill")
                }
                .padding()
                .tint(.blue)
                
                Divider()
                    .ignoresSafeArea(.keyboard)
                
                ScrollView(.horizontal){
                    LazyHGrid(rows: [GridItem(.adaptive(minimum: 48), spacing: 8)], spacing: 8){
                        ForEach(timerSymbols, id: \.self) { symbol in
                            Button {
                                withAnimation {
                                    icon = symbol
                                }
                            } label: {
                                ZStack{
                                    Image(systemName: symbol)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .font(.system(.body).weight(.semibold))
                                        .foregroundColor(symbol == icon ? .white:.secondary)
                                        .padding(.all, 8)
                                }
                                .frame(width: 48, height: 48)
                                .background(symbol == icon ? Color.blue:Color.clear)
                                .cornerRadius(48/6.4)
                            }
                        }
                    }
                    .padding()
                    .ignoresSafeArea(.keyboard)
                }.ignoresSafeArea(.keyboard)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Group.Detail.Button.Cancel")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                    } label: {
                        Text("Group.Detail.Button.Save")
                    }
                }
            }

        }
        .navigationViewStyle(.stack)
        .onChange(of: autoFill) { newValue in
            if newValue == true{
                icon = categorySymbols.randomElement() ?? "folder"
            }
        }
    }
    
    init(group:TRGroup?){
        self.group  = group
        self._title = .init(initialValue: self.group?.title ?? "")
        self._icon  = .init(initialValue: self.group?.icon ?? "folder")
    }
    
    func save(){
        let title = (self.title == "") ? nil:self.title
        if let group = group{
            group.title = title
            group.icon = icon
        } else {
            let newGroup = TRGroup(context: viewContext)
            newGroup.title = title
            newGroup.timerType = 1
            newGroup.icon = icon
            
            let newSession = TRSession(context: viewContext)
            newSession.group = newGroup
            newSession.createDate = Date()
        }
        
        do{
            try viewContext.save()
            dismiss.callAsFunction()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: nil)
    }
}
