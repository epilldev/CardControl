//
//  ContentView.swift
//  CardControl
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "creditcard.fill")
                .font(.system(size: 72))
                .foregroundColor(.blue)

            Text("CardControl")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Em breve, um novo jeito de gerenciar seus cartões e acompanhar seus gastos.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
