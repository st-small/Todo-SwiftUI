//
//  ContentView.swift
//  Todo App
//
//  Created by Stanly Shiyanovskiy on 18.04.2021.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext)
    var managedObjectContext
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)])
    var todos: FetchedResults<Todo>
    
    @EnvironmentObject
    var iconSettings: IconNames
    
    @State
    private var showingSettingsView = false
    
    @State
    private var showingAddTodoView = false
    
//
    
    @ObservedObject
    var theme = ThemeSettings.shared
    
    var themes = themeData
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteTodo)
                }
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(themes[theme.themeSettings].themeColor),
                    trailing:
                        Button(action: {
                            showingSettingsView.toggle()
                        }) {
                            Image(systemName: "paintbrush")
                                .imageScale(.large)
                        }
                        .accentColor(themes[theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView().environmentObject(iconSettings)
                        }
                )
                
                if todos.count == 0 {
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[theme.themeSettings].themeColor)
                            .opacity(0.2)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[theme.themeSettings].themeColor)
                            .opacity(0.15)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    
                    Button(action: {
                        showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                    .accentColor(themes[theme.themeSettings].themeColor)
                }
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
