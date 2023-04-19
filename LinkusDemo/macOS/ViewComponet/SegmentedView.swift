//
//  SegmentedView.swift
//  Linkus
//
//  Created by 杨桂福 on 2022/10/10.
//

import SwiftUI

struct DemoTabsView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            TabItemView { Text("Following") }
            TabItemView { Spacer() }
            TabItemView { Text("Followers") }
            TabItemView { Spacer() }
            TabItemView(selected: true) { Text("Profile") }
        }
        .padding()
    }
}

struct TabItemView<Label: View>: View {
    var selected = false
    let label: () -> Label
    var body: some View {
        VStack(spacing: 20) {
            label()
                .font(.system(size: 16))
                .foregroundColor(selected ? Color.blue : Color.black)
            Rectangle().frame(height: 3)
                .foregroundColor(selected ? Color.blue : Color.black)
        }.fixedSize(horizontal: false, vertical: true)
    }
}

