//
//  ContentView.swift
//  CupCup Watch App
//
//  Created by Muhammad Ardiansyah Asrifah on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    @Namespace private var cupNamespace

    @State private var cups: [Int] = [0, 1, 2]
    @State private var ballIndex = 1
    @State private var selectedCup: Int? = nil
    @State private var showResult = false
    @State private var showInitialBall = false
    @State private var score = 0
    @State private var level = 1
    @State private var isShuffling = false
    @State private var remainingTime = 5
    @State private var gameActive = false

    let cupCount = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 10) {
            Text("🎯 Heat and Ball")
                .font(.headline)

            Text("Level \(level) | Skor: \(score)")
                .font(.subheadline)

            HStack {
                ForEach(cups, id: \.self) { index in
                    ZStack {
                        if ((showResult && index == cups[ballIndex]) || (showInitialBall && index == cups[ballIndex])) {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 20, height: 20)
                                .offset(y: 18)
                                .transition(.scale.combined(with: .opacity))
                        }

                        Button(action: {
                            if gameActive && !showResult {
                                withAnimation {
                                    selectedCup = index
                                }
                                evaluateGuess()
                            }
                        }) {
                            Text("🎩")
                                .font(.system(size: 30))
                                .padding()
                                .offset(y: liftOffset(for: index))
                        }
                        .matchedGeometryEffect(id: index, in: cupNamespace)
                        .disabled(!gameActive || showResult)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.4), value: cups)

            if isShuffling {
                Text("🔄 Mengacak...")
                    .foregroundColor(.gray)
            } else if gameActive && !showResult {
                Text("⏳ Waktu: \(remainingTime)s")
                    .foregroundColor(.orange)
            }

            if showResult {
                Text(selectedCup == cups[ballIndex] ? "✅ Benar!" : "❌ Salah!")
                    .font(.title3)
                    .padding(.top, 5)
            }
        }
        .onAppear {
            showInitialBall = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showInitialBall = false
                shuffleCups()
            }
        }
        .onReceive(timer) { _ in
            if gameActive && !showResult {
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    selectedCup = nil
                    evaluateGuess()
                }
            }
        }
    }

    func liftOffset(for index: Int) -> CGFloat {
        if showResult && index == selectedCup {
            return -15
        }
        return 0
    }

    func shuffleCups() {
        isShuffling = true
        gameActive = false
        showResult = false
        remainingTime = 5
        selectedCup = nil

        var count = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            count += 1

            var newCups = cups
            let i = Int.random(in: 0..<cupCount)
            var j = Int.random(in: 0..<cupCount)
            while j == i {
                j = Int.random(in: 0..<cupCount)
            }
            newCups.swapAt(i, j)
            cups = newCups

            if ballIndex == i {
                ballIndex = j
            } else if ballIndex == j {
                ballIndex = i
            }

            if count >= 6 {
                timer.invalidate()
                isShuffling = false
                gameActive = true
            }
        }
    }

    func evaluateGuess() {
        showResult = true
        gameActive = false

        if selectedCup == cups[ballIndex] {
            score += 1
            if score % 3 == 0 {
                level += 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            startNewRound()
        }
    }

    func startNewRound() {
        selectedCup = nil
        showResult = false
        showInitialBall = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showInitialBall = false
            shuffleCups()
        }
    }
}


#Preview {
    ContentView()
}

