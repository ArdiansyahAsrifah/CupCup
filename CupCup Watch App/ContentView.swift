//
//  ContentView.swift
//  CupCup Watch App
//
//  Created by Muhammad Ardiansyah Asrifah on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var ballPosition = Int.random(in: 0..<3)
    @State private var currentCups = [0, 1, 2]
    @State private var score = 0
    @State private var gameOver = false
    @State private var canGuess = false
    @State private var showBall = true
    @State private var resultMessage = ""
    @State private var showResult = false
    @State private var cupOffsets: [CGFloat] = [0, 0, 0]

    let shuffleDuration = 0.6

    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)

            VStack(spacing: 15) {
                Text(gameOver ? "Game Over" : (canGuess ? "Pick the Cup!" : "Watch the Ball"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                HStack(spacing: 20) {
                    ForEach(0..<3) { index in
                        let cupIndex = currentCups[index]
                        Button(action: {
                            if canGuess {
                                cupTapped(cupIndex)
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 50, height: 100)

                                if showBall && cupIndex == ballPosition {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 20, height: 20)
                                        .offset(y: 30)
                                }
                            }
                            .offset(x: cupOffsets[index])
                            .animation(.easeInOut(duration: shuffleDuration), value: cupOffsets[index])
                        }
                        .disabled(!canGuess || gameOver)
                    }
                }

                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .padding(.top, 10)

                if gameOver {
                    Button("Restart Game") {
                        resetGame()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
            .onAppear {
                startRound()
            }
            .alert(isPresented: $showResult) {
                Alert(title: Text(resultMessage), dismissButton: .default(Text("OK"), action: {
                    if !gameOver {
                        startRound()
                    }
                }))
            }
        }
    }

    func startRound() {
        showBall = true
        canGuess = false
        ballPosition = Int.random(in: 0..<3)
        currentCups = [0, 1, 2]
        cupOffsets = [0, 0, 0]

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showBall = false
            shuffleCups(times: 5)
        }
    }

    func shuffleCups(times: Int) {
        guard times > 0 else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + shuffleDuration) {
                cupOffsets = [0, 0, 0]
                withAnimation {
                    canGuess = true
                }
            }
            return
        }

        let first = Int.random(in: 0..<3)
        var second = Int.random(in: 0..<3)
        while second == first {
            second = Int.random(in: 0..<3)
        }

        
        withAnimation(.easeInOut(duration: shuffleDuration)) {
            cupOffsets[first] += (first < second ? 30 : -30)
            cupOffsets[second] += (second < first ? 30 : -30)
        }

    
        DispatchQueue.main.asyncAfter(deadline: .now() + shuffleDuration) {
            cupOffsets = [0, 0, 0]
            currentCups.swapAt(first, second)
            shuffleCups(times: times - 1)
        }
    }

    func cupTapped(_ guessedCup: Int) {
        canGuess = false
        if guessedCup == ballPosition {
            score += 1
            resultMessage = "Correct!"
        } else {
            resultMessage = "Wrong! Game Over."
            gameOver = true
        }
        showResult = true
    }

    func resetGame() {
        score = 0
        gameOver = false
        startRound()
    }
}

#Preview {
    ContentView()
}
