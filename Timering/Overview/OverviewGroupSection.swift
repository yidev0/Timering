//
//  OverviewGroupSection.swift
//  Timering
//
//  Created by Yuto on 2023/03/03.
//

import SwiftUI

struct OverviewGroupSection: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRGroup.title, ascending: true)], predicate: nil, animation: .default)
    var groups:FetchedResults<TRGroup>
    
    var body: some View {
        Section {
            ForEach(groups, id: \.self) { group in
                GroupChartView(trGroup: group)
            }
        } header: {
            HStack {
                Text("Overview.Header.Groups")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 8)
        }
    }
}

struct OverviewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            OverviewGroupSection()
        }
    }
}
