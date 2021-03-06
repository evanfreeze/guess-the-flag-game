//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Evan Freeze on 11/23/20.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    
    @State private var rotationAmount = 0.0
    @State private var wrongFlagsOpacity = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text("\(countries[correctAnswer])")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }.foregroundColor(.white)
                .padding(EdgeInsets(top: 40, leading: 0, bottom: 10, trailing: 0))
                
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation {
                            rotationAmount += 360.0
                            wrongFlagsOpacity = 0.25
                            flagTapped(number)
                        }
                    }) {
                        FlagImage(country: countries[number])
                            .rotation3DEffect(
                                .degrees(number == correctAnswer ? rotationAmount : 0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                            .opacity(number == correctAnswer ? 1.0 : wrongFlagsOpacity)
                    }
                }
                
                Text("Your score is \(score)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(30)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(
                title: Text(scoreTitle),
                message: Text("Your score is now \(score)"),
                dismissButton: .default(Text("Continue")) {
                    wrongFlagsOpacity = 1.0
                    askQuestion()
                    
                }
            )
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 10
        } else {
            scoreTitle = "Wrong :( That's \(countries[number])"
            score -= 10
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
