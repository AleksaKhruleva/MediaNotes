//
//  AddingNewWatchedView.swift
//  MediaNotes
//
//  Created by Aleksa on 24.10.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import SwiftUI

struct AddingWatchedView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var isPresented: Bool
    @State var title = ""
    @State var type = "фильм"
    @State var rating = 0
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack(){
                    TextField("Название", text: $title)
                        .padding([.bottom, .vertical, .leading])
                        .cornerRadius(9)
                        .font(.system(size: 20, weight: .bold))
                    
                    Button(action: { title = "" }, label: {
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
                           }).disabled(true)
                } else {
                    Button(action: {
                        let newMedia = Media(context: managedObjectContext)
                        
                        newMedia.id = UUID()
                        newMedia.title = title
                        newMedia.rating = Int32(rating)
                        newMedia.type = type
                        newMedia.isWatched = true
                        
                        do { try managedObjectContext.save() }
                        catch { print(error) }
                        
                        title = ""
                        type = ""
                        isPresented.toggle()
                    }, label: {
                        Text("Сохранить")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(9)
                    })
                }
                
                //MARK: if-else end
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Добавить", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        title = ""
                                        type = ""
                                        isPresented.toggle()
                                    }, label: { Image(systemName:"xmark.circle").imageScale(.large) })) }
    }
}
