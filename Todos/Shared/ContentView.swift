//
//  ContentView.swift
//  Shared
//
//  Created by Chris Eidhof on 05.04.22.
//

import SwiftUI
import CRDTs

struct Todo: Codable, Identifiable, Equatable, Mergable {
    var id = UUID()
    var done: LWW<Bool> = LWW(siteID: siteID, false)
    var title: String
    
    mutating func merge(_ other: Todo) {
        assert(id == other.id)
        assert(title == other.title)
        done.merge(other.done)
    }
}

struct TodoList: View {
    @Binding var model: LSeq<Todo>
    @State var newItem = ""
    @State var online = true
    
    var body: some View {
        VStack {
            HStack {
                Toggle("Online", isOn: $online)
                if online {
                    SessionView(model: $model)
                }
            }
            TextField("New Item", text: $newItem)
                .onSubmit {
                    add()
                }
            List($model) { $todo in
                HStack {
                    Toggle("Done", isOn: $todo.done.value)
                        .toggleStyle(.checkmark)
                    TextField("Title", text: .constant(todo.title))
                }
                .labelsHidden()
            }
        }
    }
    
    func add() {
        let todo = Todo(title: newItem)
        model.insert(todo, at: 0)
    }
}

let siteID = UUID().uuidString

struct ContentView: View {
    @State var model: LSeq<Todo> = LSeq(siteID: siteID)
    var body: some View {
        TodoList(model: $model)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
