//
//  CheckmarkStyle.swift
//  Todos
//
//  Created by Chris Eidhof on 05.04.22.
//

import SwiftUI

extension ToggleStyle where Self == Checkmark {
    static var checkmark: Checkmark { Checkmark() }
}

struct Checkmark: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.isOn ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
        }.onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
