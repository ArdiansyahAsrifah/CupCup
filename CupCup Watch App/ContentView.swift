//
//  ContentView.swift
//  CupCup Watch App
//
//  Created by Muhammad Ardiansyah Asrifah on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameModelView()
    @Namespace private var cupNamespace

    var body: some View {
        VStack(spacing: 10) {
            Text("🎯 Heat and Ball")
                .font(.headline)

            Text("Level \(viewModel.level) | Skor: \(viewModel.score)")
                .font(.subheadline)

            HStack {
                ForEach(viewModel.cups, id: \.self) { index in
                    ZStack {
                        if ((viewModel.showResult && index == viewModel.cups[viewModel.ballIndex]) ||
                            (viewModel.showInitialBall && index == viewModel.cups[viewModel.ballIndex])) {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 20, height: 20)
                                .offset(y: 18)
                                .transition(.scale.combined(with: .opacity))
                        }

                        Button(action: {
                            viewModel.selectCup(index)
                        }) {
                            Text("🎩")
                                .font(.system(size: 30))
                                .padding()
                                .offset(y: viewModel.liftOffset(for: index))
                        }
                        .matchedGeometryEffect(id: index, in: cupNamespace)
                        .disabled(!viewModel.gameActive || viewModel.showResult)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.4), value: viewModel.cups)

            if viewModel.isShuffling {
                Text("🔄 Mengacak...")
                    .foregroundColor(.gray)
            } else if viewModel.gameActive && !viewModel.showResult {
                Text("⏳ Waktu: \(viewModel.remainingTime)s")
                    .foregroundColor(.orange)
            }

            if viewModel.showResult {
                Text(viewModel.selectedCup == viewModel.cups[viewModel.ballIndex] ? "✅ Benar!" : "❌ Salah!")
                    .font(.title3)
                    .padding(.top, 5)
            }
        }
    }
}

#Preview {
    ContentView()
}

