//
//  Film.swift
//  MediaNotes
//
//  Created by Aleksa on 21.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI

struct Film: Identifiable {
    
    var id: UUID
    var title: String
    var type: String
    var rating = 0
    var isWatched = false
}
