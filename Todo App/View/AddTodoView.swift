//
//  AddTodoView.swift
//  Todo App
//
//  Created by Stanly Shiyanovskiy on 18.04.2021.
//

import CoreData
import SwiftUI

struct AddTodoView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State
    private var name: String = ""
    
    @State
    private var priority: String = "Normal"
    
    @State
    private var errorShowing: Bool = false
    
    @State
    private var errorTitle: String = ""
    
    @State
    private var errorMessage: String = ""
    
    @ObservedObject
    var theme = ThemeSettings.shared
    
    var themes = themeData
    
    let priorities = ["High", "Normal", "Low"]
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        if name != "" {
                            let todo = Todo(context: managedObjectContext)
                            todo.name = name
                            todo.priority = priority
                            
                            do {
                                try managedObjectContext.save()
                                
                            } catch {
                                print(error)
                            }
                        } else {
                            errorShowing = true
                            errorTitle = "Invalid Name"
                            errorMessage = "Make sure to enter something for the new todo item."
                            return
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Spacer()
            }
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Image(systemName: "xmark")
                                    }
            )
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .accentColor(themes[theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
