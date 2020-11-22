//
//  ContentView.swift
//  MediaNotes
//
//  Created by Aleksa on 20.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        TabView {
            NotWatchedView().tabItem { Image(systemName: "circle") }
            WatchedView().tabItem { Image(systemName: "circle.fill") }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
