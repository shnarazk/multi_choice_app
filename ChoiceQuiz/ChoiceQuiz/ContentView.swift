//
//  ContentView.swift
//  ChoiceQuiz
//
//  Created by 楢崎修二 on 2020/11/06.
//

import SwiftUI

struct ContentView: View {
    @State var quizes: [Quiz]
    @State var quiz: Quiz
    @State var problems = 1
    @State var corrects = 0
    @State var title: String = "swift"
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                NavigationView {
                    List {
                        Text(quiz.text)
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding(.bottom, 8)
                        ForEach(quiz.choice.shuffled(), id: \.self) { c in
                            NavigationLink(
                                destination:
                                    ZStack {
                                        Text(c.first! == "⭕️" ? "⭕️" : "❌")
                                            .font(Font.system(size: 300))
                                            .padding()
                                        Text(c.first! == "⭕️" ? "\(corrects + 1)問連続正解" : " 0問連続正解")
                                            .font(.title)
                                    }
                                    .onAppear {
                                        self.quiz = quizes.randomElement()!
                                        self.problems += 1
                                        if c.first! == "⭕️" {
                                            self.corrects += 1
                                        } else {
                                            self.corrects = 0
                                        }
                                    },
                                label: {
                                    HStack {
                                        Image(systemName: "arrow.forward.circle.fill")
                                        Text(c.dropFirst())
                                    }
                                }
                            )
                        }
                    }
                    .navigationBarTitle("\(problems)問目")
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .onDrop(of: ["public.json"], isTargeted: nil) {
                providers, location in
                if let item = providers.first {
                    item.loadItem(forTypeIdentifier: "public.json", options: nil) { (urlData, error) in
                        if let url = urlData as? URL {
                            quizes = loadJson(url: url)
                            quiz = quizes.randomElement()!
                            corrects = 0
                            problems = 1
                            title = "新規問題セット"
                        } else {
                            title = "couldn't convert url: \(String(describing: urlData))"
                        }
                    }
                    return true
                }
                return false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(quizes: quizes, quiz: quizes.randomElement()!)
    }
}
