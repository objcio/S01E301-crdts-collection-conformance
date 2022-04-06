//
//  SessionView.swift
//  DietQualityScore
//
//  Created by Chris Eidhof on 18.03.22.
//

import Foundation
import SwiftUI
import CRDTs

struct SessionView<M>: View where M: Mergable & Codable & Equatable {
    @StateObject private var session = Session<M>()
    @Binding var model: M

    var body: some View {
        Circle().frame(width: 20, height: 20)
            .foregroundColor(session.connected ? .green : .red)
            .onChange(of: model) { newValue in
                try! session.send(newValue)
            }
            .onChange(of: session.connected) { _ in
                try! session.send(model)
            }
            .task {
                for await newValue in session.receiveStream {
                    model.merge(newValue)
                }
            }
    }
}
