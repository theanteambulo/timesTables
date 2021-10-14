//
//  ContentView.swift
//  TimesTables
//
//  Created by Jake King on 29/07/2021.
//

import SwiftUI

struct Questions {
    var questions = [String]()
    var answers = [Int]()
    
    mutating func generateQuestionsAnswers(timesTable: Int) {
        for number in 1...12 {
            questions.append("\(number) x \(timesTable)")
            answers.append(number * timesTable)
        }
    }
}

struct HeadingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2.bold())
            .padding(.bottom,
                     2)
    }
}

struct BodyTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.bottom,
                     15)
    }
}

struct FixedSizeButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 100,
                   height: 35)
            .font(.body.bold())
            .foregroundColor(.white)
    }
}

struct ResizeableButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body.bold())
            .foregroundColor(.white)
    }
}

extension View {
    func headingStyle() -> some View {
        self.modifier(HeadingStyle())
    }
    
    func bodyTextStyle() -> some View {
        self.modifier(BodyTextStyle())
    }
    
    func fixedSizeButtonStyle() -> some View {
        self.modifier(FixedSizeButtonStyle())
    }
    
    func resizeableButtonStyle() -> some View {
        self.modifier(ResizeableButtonStyle())
    }
}

struct ContentView: View {
    @State private var gameActive = false
    @State private var timesTable = Int.random(in: 1...12)
    @State private var allQuestions = false
    @State private var questionCountChosen = 7
    @State private var timesTableQuestions = [String]()
    @State private var timesTableAnswers = [Int]()
    @State private var userAnswer = ""
    @State private var userCorrect = true
    @State private var questionCount = 0
    @State private var questionsAsked = [Int]()
    @State private var userScore = 0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertDisplay = false
    @State private var easyButtonsFade = false
    @State private var mediumButtonsFade = false
    @State private var hardButtonsFade = false
    @State private var flashWarning = false
    
    var questionToAsk: Int {
        
        if userCorrect {
            var questionToAsk = Int.random(in: 0..<12)
            
            if questionsAsked.contains(questionToAsk) {
                while questionsAsked.contains(questionToAsk) {
                    questionToAsk = Int.random(in: 0..<12)
                }
            }
            
            return questionToAsk
        } else {
            return questionsAsked.last!
        }
    }
    
    let difficultyLevels = ["Easy", "Medium", "Hard"]
    let easy = [2, 5, 10]
    let medium = [3, 4, 9, 11]
    let hard = [6, 7, 8, 12]

    var body: some View {
        NavigationView {
            ZStack {
                if gameActive == false {
                    Group {
                        VStack(alignment: .center) {
                            Section(header: Text("What do you want to practice?")
                                        .headingStyle()) {
                                Text("Select a times table to practice to begin.")
                                    .bodyTextStyle()
                                    .foregroundColor(flashWarning ? .red : .primary)
                            }
                         
                            VStack {
                                HStack {
                                    Button(action: {
                                        self.timesTable = 0
                                        self.easyButtonsFade = false
                                        self.mediumButtonsFade = true
                                        self.hardButtonsFade = true
                                    }) {
                                        Text("Easy")
                                            .fixedSizeButtonStyle()
                                            .background(Color.green)
                                            .clipShape(Capsule())
                                            .padding(.bottom,
                                                     15)
                                    }
                                    
                                    Button(action: {
                                        self.timesTable = 0
                                        self.easyButtonsFade = true
                                        self.mediumButtonsFade = false
                                        self.hardButtonsFade = true
                                    }) {
                                        Text("Medium")
                                            .fixedSizeButtonStyle()
                                            .background(Color.yellow)
                                            .clipShape(Capsule())
                                            .padding(.bottom,
                                                     15)
                                    }
                                    
                                    Button(action: {
                                        self.timesTable = 0
                                        self.easyButtonsFade = true
                                        self.mediumButtonsFade = true
                                        self.hardButtonsFade = false
                                    }) {
                                        Text("Hard")
                                            .fixedSizeButtonStyle()
                                            .background(Color.red)
                                            .clipShape(Capsule())
                                            .padding(.bottom,
                                                     15)
                                    }
                                }
                                
                                HStack {
                                    ForEach(2..<13) { number in
                                        Button(action: {
                                            self.timesTable = number
                                            self.easyButtonsFade = true
                                            self.mediumButtonsFade = true
                                            self.hardButtonsFade = true
                                            self.flashWarning = false
                                        }) {
                                            Image(systemName: "\(number).circle.fill")
                                                .resizable()
                                                .foregroundColor(easy.contains(number) ? .green : (medium.contains(number) ? .yellow : .red))
                                                .frame(width: 25,
                                                       height: 25)
                                                .padding(.bottom,
                                                         10)
                                                .opacity(
                                                    timesTable == number ? 1.0 :
                                                        easy.contains(number) && easyButtonsFade ? 0.25 :
                                                        medium.contains(number) && mediumButtonsFade ? 0.25 :
                                                        hard.contains(number) && hardButtonsFade ? 0.25 : 1.0)
                                        }
                                    }
                                }
                                
                                Text("Let's practice the \(timesTable)s!")
                                    .bodyTextStyle()
                            }
                            
                            VStack {
                                Section(header: Text("How many questions?")
                                            .headingStyle()) {
                                    Text("""
                                        Select a number of questions to be asked.
                                        Feeling brainy? Try all the questions!
                                        """)
                                        .bodyTextStyle()
                                    
                                    Picker(selection: $questionCountChosen, label: Text("Select a number of questions"), content: {
                                        Group {
                                            Text("1 question").tag(1)
                                            Text("2 questions").tag(2)
                                            Text("3 questions").tag(3)
                                            Text("4 questions").tag(4)
                                            Text("5 questions").tag(5)
                                            Text("6 questions").tag(6)
                                            Text("7 questions").tag(7)
                                            Text("8 questions").tag(8)
                                            Text("9 questions").tag(9)
                                            Text("10 questions").tag(10)
                                        }
                                        
                                        Group {
                                            Text("11 questions").tag(11)
                                            Text("12 questions").tag(12)
                                        }
                                    })
                                    
                                    Button(action: {
                                        self.questionCountChosen = 12
                                        self.allQuestions.toggle()
                                    }) {
                                        Text("All questions!")
                                            .resizeableButtonStyle()
                                            .frame(width: 175,
                                                   height: 35)
                                            .background(Color.blue)
                                            .clipShape(Capsule())
                                            .padding(.bottom,
                                                     10)
                                    }
                                }
                            }
                                
                            Section(header: Text("Ready to pracice?")
                                        .headingStyle()) {
                                Button(action: {
                                    if timesTable == 0 {
                                        flashWarning = true
                                    } else {
                                        self.gameActive.toggle()
                                        startGame()
                                        print(timesTableQuestions)
                                        print(timesTableAnswers)
                                        print("Question Count: \(questionCount)")
                                        print("Question Count Chosen: \(questionCountChosen)")
                                    }
                                }) {
                                    Text("Let's go!")
                                        .resizeableButtonStyle()
                                        .frame(width: 175,
                                               height: 35)
                                        .background(Color.blue)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                } else {
                    Group {
                        let questionIndex = questionToAsk
                        
                        VStack {
                            Section(header: Text("Question \(questionCount) of \(questionCountChosen)")
                                        .bodyTextStyle()) {

                                Text("\(timesTableQuestions[questionIndex])")
                                    .headingStyle()
                                    .padding(.bottom,
                                             25)

                                TextField("Answer",
                                          text: $userAnswer)
                                    .keyboardType(.numberPad)
                                    .frame(width: 150,
                                           height: 35,
                                           alignment: .center)
                                    .frame(width: 175,
                                           height: 35,
                                           alignment: .center)
                                    .background(Color.blue.opacity(0.2))
                                    .clipShape(Capsule())
                            
                            Button(action: {
                                questionsAsked.append(questionIndex)
                                answerSubmitted(questionIndex: questionsAsked.last!)
                            }) {
                                Text("Submit")
                                    .resizeableButtonStyle()
                                    .frame(width: 175,
                                           height: 35)
                                    .background(Color.blue)
                                    .clipShape(Capsule())
                                    .padding(.bottom,
                                             25)
                            }
                                
                            Text("Score: \(userScore)")
                                .headingStyle()
                            }
                        }
                        .alert(isPresented: $alertDisplay) {
                            Alert(title: Text("\(alertTitle)"),
                                  message: Text("\(alertMessage)"),
                                  dismissButton: .default(Text("OK")) {
                                    if questionCount > questionCountChosen {
                                        gameReset()
                                    }
                                  })
                        }
                    }
                }
            }
            .navigationBarTitle(Text("TimesTables"))
        }
        .background(Color.primary)
        .foregroundColor(.primary)
        .padding(.leading,
                 15)
        .padding(.trailing,
                 15)
    }
    
    func startGame() {
        var questionsAnswers = Questions()
        questionsAnswers.generateQuestionsAnswers(timesTable: timesTable)
        timesTableQuestions = questionsAnswers.questions
        timesTableAnswers = questionsAnswers.answers
        
        questionCount += 1
    }
    
    func answerSubmitted(questionIndex: Int) {
        if Int(userAnswer) == timesTableAnswers[questionIndex] {
            userScore += 1
            alertTitle = "Correct"
            alertMessage = """
            Well done!
            Your score is \(userScore).
            Keep up the good work.
            """
            questionCount += 1
            userCorrect = true
        } else {
            alertTitle = "Incorrect"
            alertMessage = """
                Unlucky!
                Have another go.
                """
            userCorrect = false
        }
        
        userAnswer = ""
        questionsDone(questionsDone: questionCount > questionCountChosen)
        alertDisplay = true
    }
    
    func questionsDone(questionsDone: Bool) {
        if questionsDone {
            alertMessage = """
                You've finished all the questions!
                Your score was \(userScore).
                Play again?
                """
        }
    }
    
    func gameReset() {
        self.gameActive.toggle()
        timesTable = Int.random(in: 1...12)
        allQuestions = false
        questionCountChosen = 1
        timesTableQuestions = [String]()
        timesTableAnswers = [Int]()
        userAnswer = ""
        userCorrect = true
        questionCount = 0
        questionsAsked = [Int]()
        userScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
