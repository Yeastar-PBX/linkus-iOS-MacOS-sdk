//
//  ViewComponet.swift
//  Linkus
//
//  Created by 杨桂福 on 2022/9/13.
//

import SwiftUI

struct SideBarLabel: View {
    var title: String
    var imageName: String
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
            Text(title)
        }
    }
}

struct imageStatus: View {
    var presenceStatus: String?
    var registerStatus: Int?
    var body: some View {
        HStack {
            Image(imageName(presenceStatus ?? "available", registerStatus ?? 0))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12)
        }
    }
    
    func imageName( _ presenceStatus: String, _ registerStatus: Int) -> String {
        if registerStatus == 0 {
            switch presenceStatus {
            case "available":
                return "Extension_status_Presence_free"
            case "away":
                return "Extension_status_Presence_away"
            case "do_not_disturb":
                return "Extension_status_Presence_DND"
            case "launch":
                return "Extension_status_Presence_lunch"
            case "business_trip":
                return "Extension_status_Presence_business"
            case "off_work":
                return "Extension_status_Presence_OffWork"
            default:
                return "Extension_status_Presence_free"
            }
        } else if registerStatus == 2 {
            return "Extension_status_Presence_busy"
        } else if registerStatus == 4 {
            return "Extension_status_Presence_noregist"
        } else {
            return "Extension_status_Presence_free"
        }
    }
}
