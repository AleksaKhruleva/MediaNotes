//
//  Row2.swift
//  MediaNotes
//
//  Created by Aleksa on 23.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI

struct Row2: View {
    var film: Media
    
    var body: some View {
        HStack {
            Text(film.title!).font(.system(size: 20))
            Spacer()
            Text(film.type!).foregroundColor(.gray).font(.system(size: 18))
            
            if (film.rating == 0) {
                Circle().fill(Color.gray).frame(width: 13, height: 13)
            } else if (film.rating == 1) {
                Circle().fill(Color.pink).frame(width: 13, height: 13)
            } else if (film.rating == 2) {
                Circle().fill(Color.yellow).frame(width: 13, height: 13)
            } else {
                Circle().fill(Color.green).frame(width: 13, height: 13)
            }
            
        }.frame(height: 40)
    }
}

//struct Row2_Previews: PreviewProvider {
//    static var previews: some View {
//        let f0 = Film(id: UUID(), title: "Hello", type: "film", rating: 3, isWatched: true)
//        Row2(film: f0)
//    }
//}
