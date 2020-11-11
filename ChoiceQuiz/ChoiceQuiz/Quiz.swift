//
//  Quiz.swift
//  ChoiceQuiz
//
//  Created by 楢崎修二 on 2020/11/06.
//

import Foundation

struct Quiz: Codable, Identifiable {
    var id: Int
    var text: String
    var code: String?
    var choice: [String]
}

var quizes: [Quiz] = loadJson(filename: "swift")

func loadJson(filename: String) -> [Quiz] {
    guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
        fatalError("Couldn't load \(filename)")
    }
    return loadJson(url: URL(fileURLWithPath: path))
}

func loadJson(url: URL) -> [Quiz] {
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Couldn't parse \(url)")
    }
    do {
         return try JSONDecoder().decode([Quiz].self, from: data)
    }
    catch {
        fatalError("Couldn't decode \(url)")
    }
}
