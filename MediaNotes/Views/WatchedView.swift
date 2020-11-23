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
    
    @State var activeSheet = 0
    @State var isPresented = false
    @State var filmIDWV: UUID = UUID()
    
    var body: some View {
        NavigationView {
            List {
                ForEach (modelData) { watch in
                    Row2(film: watch)
                        .onTapGesture {
                            print("WatchedView.List.ForEach(modelData).Row(watch).onTapGesture()")
                            filmIDWV = watch.id!
                            print("watch.title = \(watch.title!)")
                            print("watch.id    = \(watch.id!)")
                            print("filmID      = \(filmIDWV)")
                            activeSheet = 1
                            isPresented = true
                            print("activeSheet: \(activeSheet)")
                        }
                }
                .onDelete(perform: { indexSet in
                    do {
                        print("WatchedView.List.ForEach(modelData).onDelete()")
                        for index in indexSet {
                            print("delete: ", index)
                            let filmWV = modelData[index]
                            managedObjectContext.delete(filmWV)
                        }
                        try managedObjectContext.save()
                    } catch { print(error) }
                })
            }
            .sheet(isPresented: $isPresented) {
                MySheetsWV(activeSheet: $activeSheet, filmID: $filmIDWV, isPresented: $isPresented)
            }
            .navigationBarTitle("Просмотренные")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        activeSheet = 2
                                        isPresented = true },
                                           label: { Image(systemName: "plus.circle").imageScale(.large) }))
        }.listStyle(PlainListStyle())
    }
}

struct MySheetsWV: View {
    @Binding var activeSheet: Int
    @Binding var filmID: UUID
    @Binding var isPresented: Bool
    
    var body: some View {
        if activeSheet == 1 {
            DetailWatchedView(filmIDWV: $filmID, isPresentedDetailViewWV: $isPresented)
        }
        else if activeSheet == 2 {
            AddingWatchedView(isPresented: $isPresented)
        }
        else if activeSheet == 0 {
            Text("0")
        }
    }
}
