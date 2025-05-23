//
//  GameModelView.swift
//  CupCup
//
//  Created by Muhammad Ardiansyah Asrifah on 23/05/25.
//

import SwiftUI
import Combine

class GameModelView: ObservableObject {
    @Published var cups: [Int] = [0, 1, 2]
    @Published var ballIndex = 1
    @Published var selectedCup: Int? = nil
    @Published var showResult = false
    @Published var showInitialBall = false
    @Published var score = 0
    @Published var level = 1
    @Published var isShuffling = false
    @Published var remainingTime = 5
    @Published var gameActive = false

    let cupCount = 3
    private var shuffleTimer: Timer?
    private var cancellableTimer: AnyCancellable?

    init() {
        startInitialRound()
        startCountdownTimer()
    }

    private func startCountdownTimer() {
        cancellableTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerTick()
            }
    }

    private func timerTick() {
        if gameActive && !showResult {
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                selectedCup = nil
                evaluateGuess()
            }
        }
    }

    func liftOffset(for index: Int) -> CGFloat {
        if showResult && index == selectedCup {
            return -15
        }
        return 0
    }

    func startInitialRound() {
        showInitialBall = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showInitialBall = false
            self.shuffleCups()
        }
    }

    func shuffleCups() {
        isShuffling = true
        gameActive = false
        showResult = false
        remainingTime = 5
        selectedCup = nil

        var count = 0
        shuffleTimer?.invalidate()

        shuffleTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            count += 1

            var newCups = self.cups
            let i = Int.random(in: 0..<self.cupCount)
            var j = Int.random(in: 0..<self.cupCount)
            while j == i {
                j = Int.random(in: 0..<self.cupCount)
            }
            newCups.swapAt(i, j)
            self.cups = newCups

            if self.ballIndex == i {
                self.ballIndex = j
            } else if self.ballIndex == j {
                self.ballIndex = i
            }

            if count >= 6 {
                timer.invalidate()
                self.isShuffling = false
                self.gameActive = true
            }
        }
    }

    func selectCup(_ index: Int) {
        guard gameActive && !showResult else { return }
        withAnimation {
            selectedCup = index
        }
        evaluateGuess()
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
            self.startNewRound()
        }
    }

    func startNewRound() {
        selectedCup = nil
        showResult = false
        showInitialBall = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showInitialBall = false
            self.shuffleCups()
        }
    }
}
