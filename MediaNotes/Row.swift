//
//  Row.swift
//  MediaNotes
//
//  Created by Aleksa on 21.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI

struct Row: View {
    var film: Media
    
    var body: some View {
        HStack {
            Text(film.title!).font(.system(size: 20))
            Spacer()
            Text(film.type!).foregroundColor(.gray).font(.system(size: 18))
        }.frame(height: 40)
    }
}

//struct Row_Previews: PreviewProvider {
//    static var previews: some View {
//        let f0 = Film(id: UUID(), title: "Hello", type: "film", rating: 0, isWatched: false)
//        Row(film: f0)
//    }
//}
