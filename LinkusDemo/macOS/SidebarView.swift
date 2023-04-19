//
//  SidebarView.swift
//  Linkus
//
//  Created by 杨桂福 on 2022/9/13.
//

import SwiftUI

enum Panel: Hashable {
    case callLogs
    case contacts
}

struct SidebarView: View {
//    @StateObject private var searchVM = SearchVM()
    @State private var selection: Panel? = Panel.contacts
    @State private var hover = false
    
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                NavigationLink(tag: Panel.callLogs, selection: $selection) {
//                    HistoryListView()
                } label: {
                    SideBarLabel(title: "拨打", imageName: "TabBarItem_Calls_Normal")
                }
                NavigationLink(tag: Panel.contacts, selection: $selection) {
//                    ContactsView()
                } label: {
                    SideBarLabel(title: "挂断", imageName: "TabBarItem_Contacts_Normal")
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 160)
        }
        .navigationTitle("")
#if os(macOS)
//        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button {
//                    LinkusAppVM().toggleSidebar()
                } label: {
                    Label("Sidebar", systemImage: "sidebar.left")
                }
            }
            ToolbarItem(placement: .primaryAction) {
//                SearchBarView(searchText: $searchVM.searchText, popover: $searchVM.popover)
//                    .popover(isPresented: $searchVM.popover) {
//                        ExtensionListView(extensions: searchVM.searchResults!)
//                            .frame(width: 200)
//                    }
            }
        }
#endif
    }
}
