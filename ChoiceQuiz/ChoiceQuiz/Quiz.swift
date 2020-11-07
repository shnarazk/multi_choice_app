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
    var choice: [String]
}

var quizes: [Quiz] = loadJson(filename: "swift")

func loadJson(filename: String) -> [Quiz] {
    guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
        fatalError("Couldn't load \(filename)")
    }
    let url = URL(fileURLWithPath: path)
    return loadJson(url: url)
//    guard let data = try? Data(contentsOf: url) else {
//        fatalError("Couldn't parse \(filename)")
//    }
//    let decoder = JSONDecoder()
//    do {
//         return try decoder.decode([Quiz].self, from: data)
//    }
//    catch {
//        fatalError("Couldn't decode \(filename)")
//    }
}

func loadJson(url: URL) -> [Quiz] {
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Couldn't parse \(url)")
    }
    let decoder = JSONDecoder()
    do {
         return try decoder.decode([Quiz].self, from: data)
    }
    catch {
        fatalError("Couldn't decode \(url)")
    }
}
