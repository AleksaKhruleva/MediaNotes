//
//  WatchedView.swift
//  MediaNotes
//
//  Created by Aleksa on 22.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI

struct WatchedView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Media.entity()
        ,sortDescriptors: [NSSortDescriptor(keyPath: \Media.title, ascending: true)]
        ,predicate: NSPredicate(format: "isWatched == %@", NSNumber(value: true))
    ) var modelData: FetchedResults<Media>
    
    @State var isPresentedAddingView = false
    @State var isPresentedDetailView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach (modelData) { watch in
                    Row2(film: watch)
                        .onTapGesture { isPresentedDetailView.toggle()}
                        .sheet(isPresented: $isPresentedDetailView, content: {
                            DetailWatchedView(film: watch, isPresentedDetailView: $isPresentedDetailView)
                        })
                }
                .onDelete(perform: { indexSet in
                    do {
                        for index in indexSet {
                            print("delete: ", index)
                            let film = modelData[index]
                            managedObjectContext.delete(film)
                        }
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                })
            }
            .sheet(isPresented: $isPresentedAddingView, content: {
                AddingWatchedView(isPresentedAddingView: $isPresentedAddingView)
            })
            .navigationBarTitle("Просмотренные")
            .navigationBarItems(trailing: Button(action: { isPresentedAddingView.toggle() },
                                                 label: { Image(systemName: "plus").imageScale(.large) }))
        }.listStyle(PlainListStyle())
    }
}

struct WatchedView_Previews: PreviewProvider {
    static var previews: some View {
        WatchedView()
    }
}
