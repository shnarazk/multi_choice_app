//
//  ContentView.swift
//  ChoiceQuiz
//
//  Created by 楢崎修二 on 2020/11/06.
//

import SwiftUI

let good_symbol = "⭕️"
let bad_symbol = "❌"

struct ContentView: View {
    @State var quizes: [Quiz]
    @State var quiz: Quiz
    @State var problems = 1
    @State var corrects = 0
   
    var body: some View {
        NavigationView {
            List {
                Text(quiz.text)
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(.red)
                    .padding(.vertical, 20)
                if let code = quiz.code {
                    Text(code)
                        .font(.system(.headline, design: .monospaced))
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                        .foregroundColor(.gray)
                }
                ForEach(quiz.choice.shuffled(), id: \.self) { c in
                    NavigationLink(
                        destination:
                            ZStack {
                                Text(c.correct() ? good_symbol : bad_symbol)
                                    .font(Font.system(size: 300))
                                    .blur(radius: 4.0)
                                    .opacity(0.6)
                                    .padding()
                                Text("\(c.correct() ? corrects + 1 : 0)問連続正解")
                                    .font(.title)
                            }
                            .onAppear {
                                self.quiz = quizes.randomElement()!
                                self.problems += 1
                                self.corrects = c.correct() ? self.corrects + 1 : 0
                            },
                        label: {
                            HStack {
                                Image(systemName: "arrow.forward.circle.fill")
                                Text(c.dropFirst())
                                    .font(.system(.body, design: .monospaced))
                            }
                        }
                    )
                }
            }
            .navigationBarTitle("\(problems)問目")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDrop(of: ["public.json"], isTargeted: nil) {
            providers, location in
            if let item = providers.first {
                item.loadItem(forTypeIdentifier: "public.json", options: nil) { (urlData, _) in
                    if let url = urlData as? URL {
                        quizes = loadJson(url: url)
                        quiz = quizes.randomElement()!
                        corrects = 0
                        problems = 1
                    }
                }
                return true
            }
            return false
        }
    }
}

extension String {
    func correct() -> Bool {
        if let c = self.first {
            return c == Character(good_symbol)
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(quizes: quizes, quiz: quizes.randomElement()!)
    }
}
