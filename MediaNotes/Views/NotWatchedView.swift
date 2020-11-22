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
    
    @State var isPresented = false
    @State var isPresentedDetailView = false
    @State var searchText = ""
    
    var body: some View {
        
        NavigationView {
            
            //            VStack {
            //                VStack {
            //                TextField("search here...", text: $searchText)
            //                    .padding([.leading, .trailing, .vertical])
            //                    .background(Color(UIColor.tertiarySystemFill))
            //                    .cornerRadius(9)
            //                    .font(.system(size: 20))
            //                }.padding([.leading, .trailing])
            //
            List {
                ForEach (modelData) { watch in
                    Row(film: watch)
                        .onTapGesture { isPresentedDetailView.toggle() }
                        .sheet(isPresented: $isPresentedDetailView, content: { DetailNotWatchedView(film: watch, isPresentedDetailView: $isPresentedDetailView) })
                }
                .onDelete(perform: { indexSet in
                            do {
                                for index in indexSet {
                                    print("delete: ", index)
                                    let film = modelData[index]
                                    managedObjectContext.delete(film)
                                }
                                try managedObjectContext.save()
                            } catch { print(error) } })
            }
            .sheet(isPresented: $isPresented, content: { AddingNotWatchedView(isPresented: $isPresented) })
            .navigationBarTitle("Посмотреть")
            .navigationBarItems(trailing: Button(action: { self.isPresented.toggle() },
                                                 label: { Image(systemName: "plus").imageScale(.large) }))
            .listStyle(PlainListStyle())
            
            //            }
            
        }
    }
}


//struct NotWatchedView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotWatchedView()
//    }
//}
