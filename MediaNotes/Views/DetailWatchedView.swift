//
//  DetailWatchedView.swift
//  MediaNotes
//
//  Created by Aleksa on 24.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI

struct DetailWatchedView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Media.entity()
        ,sortDescriptors: [NSSortDescriptor(keyPath: \Media.title, ascending: true)]
        ,predicate: NSPredicate(format: "isWatched == %@", NSNumber(value: true))
    ) var modelData: FetchedResults<Media>
    
    @Binding var filmIDWV: UUID
    @Binding var isPresentedDetailViewWV: Bool
    
    @State var title: String = ""
    @State var type: String = ""
    @State var rating = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(){
                    TextField("Название", text: $title)
                        .padding([.bottom, .vertical, .leading])
                        .cornerRadius(9)
                        .font(.system(size: 20, weight: .bold))
                    
                    Button(action: {
                        title = ""
                    }, label: {
                        Image(systemName: "multiply.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(ColorManager.lightGray)
                    })
                    .padding(.trailing, 10)
                }
                .background(Color(UIColor.tertiarySystemFill))
                .cornerRadius(9)
                
                Picker(selection: $type, label: Text("Picker"), content: {
                    Text("фильм").tag("фильм")
                    Text("сериал").tag("сериал")
                })
                .padding(.vertical, 5.0)
                .pickerStyle(SegmentedPickerStyle())
                
                HStack() {
                    
                    Text("Рейтинг").bold()
                    
                    Picker(selection: $rating, label: Text("Picker"), content: {
                        Image("CircleGray").tag(0)
                        Image("CircleRed").tag(1)
                        Image("CircleYellow").tag(2)
                        Image("CircleGreen").tag(3)
                    })
                    .padding(.bottom, 5.0)
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                //MARK: if-else begin
                
                if (title.isEmpty) {
                    Button(action: { },
                           label: {
                            Text("Сохранить")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(ColorManager.lightGray)
                                .foregroundColor(.white)
                                .cornerRadius(9)
                           })
                        .disabled(true)
                        .padding(.bottom, 5.0)
                    
                    Button(action: { },
                           label: {
                            Text("В \"Посмотреть\"")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(ColorManager.lightGray)
                                .foregroundColor(.white)
                                .cornerRadius(9)
                           })
                        .disabled(true)
                } else {
                    Button(action: {
                        let updatedMedia = Media(context: managedObjectContext)
                        let filmWV = getFilm(id: filmIDWV)
                        updatedMedia.id = UUID()
                        updatedMedia.title = title
                        updatedMedia.rating = Int32(rating)
                        updatedMedia.type = type
                        updatedMedia.isWatched = filmWV.isWatched
                        
                        do {
                            managedObjectContext.delete(filmWV)
                            try managedObjectContext.save()
                        }
                        catch { print(error) }
                        isPresentedDetailViewWV = false
                    }, label: {
                        Text("Сохранить")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(9)
                    })
                    .padding(.bottom, 5.0)
                    
                    Button(action: {
                        let updatedMedia = Media(context: managedObjectContext)
                        let filmWV = getFilm(id: filmIDWV)
                        
                        updatedMedia.id = UUID()
                        updatedMedia.title = title
                        updatedMedia.rating = Int32(rating)
                        updatedMedia.type = type
                        updatedMedia.isWatched = !filmWV.isWatched
                        
                        do {
                            managedObjectContext.delete(filmWV)
                            try managedObjectContext.save()
                        }
                        catch { print(error) }
                        isPresentedDetailViewWV = false
                    }, label: {
                        Text("В \"Посмотреть\"")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(ColorManager.brightYellow)
                            .foregroundColor(.white)
                            .cornerRadius(9)
                    })
                }
                
                //MARK: if-else end
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Изменить", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {isPresentedDetailViewWV = false},
                                                 label: { Image(systemName: "xmark.circle").imageScale(.medium) }))
            .onAppear() {
                print("DetailWatchedView.onAppear()")
                print("filmID = \(filmIDWV)")
                
                let filmWV = getFilm(id: filmIDWV)
                
                title = filmWV.title ?? "nil"
                type = filmWV.type ?? "nil"
                rating = Int(filmWV.rating)
            }
        }
    }
    
    func getFilm(id: UUID) -> Media {
        for data in modelData {
            if (data.id == id) { return data }
        }
        return modelData[0]
    }
}
