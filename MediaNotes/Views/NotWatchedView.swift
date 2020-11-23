//
//  NotWatchedView.swift
//  MediaNotes
//
//  Created by Aleksa on 22.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI
import CoreData

struct NotWatchedView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Media.entity()
        ,sortDescriptors: [NSSortDescriptor(keyPath: \Media.title, ascending: true)]
        ,predicate: NSPredicate(format: "isWatched == %@", NSNumber(value: false))
    ) var modelData: FetchedResults<Media>
    
    @State var activeSheet = 0
    @State var isPresented = false
    @State var filmID: UUID = UUID()
    
    var body: some View {
        NavigationView {
            List {
                ForEach (modelData) { watch in
                    Row(film: watch)
                        .onTapGesture {
                            print("NotWatchedView.List.ForEach(modelData).Row(watch).onTapGesture()")
                            filmID = watch.id!
                            print("watch.title = \(watch.title!)")
                            print("watch.id    = \(watch.id!)")
                            print("filmID      = \(filmID)")
                            activeSheet = 1
                            isPresented = true
                            print("activeSheet: \(activeSheet)")
                        }
                }
                .onDelete(perform: { indexSet in
                            do {
                                print("NotWatchedView.List.ForEach(modelData).onDelete()")
                                for index in indexSet {
                                    print("delete: ", index)
                                    let film = modelData[index]
                                    managedObjectContext.delete(film)
                                }
                                try managedObjectContext.save()
                            } catch { print(error) }
                })
            }
            .sheet(isPresented: $isPresented) {
                MySheets(activeSheet: $activeSheet, filmID: $filmID, isPresented: $isPresented)
            }
            .navigationBarTitle("Посмотреть")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        activeSheet = 2
                                        isPresented = true
                                        print("activeSheet: \(activeSheet)")
                                        },
                                           label: { Image(systemName: "plus.circle").imageScale(.large) }))
            .listStyle(PlainListStyle())
        }
        .onAppear() {
            print(".onAppear().activeSheet: \(activeSheet)")
        }
    }
}

struct MySheets: View {
    @Binding var activeSheet: Int
    @Binding var filmID: UUID
    @Binding var isPresented: Bool
    
    var body: some View {
        if activeSheet == 1 {
            DetailNotWatchedView(filmID: $filmID, isPresentedDetailView: $isPresented)
        }
        else if activeSheet == 2 {
            AddingNotWatchedView(isPresented: $isPresented)
        }
        else if activeSheet == 0 {
            Text("0")
        }
    }
}
