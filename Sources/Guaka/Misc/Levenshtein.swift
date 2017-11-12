//
//  Levenshtein.swift
//  Guaka
//
//  Created by Jose Narvaez on 19/11/2016.
//
//

/// Calculates the distance between two strings
enum Levenshtein {
  static func distance(source: String, target: String) -> Int {
    if source == target { return 0 }

    let sourceLen = source.count
    let targetLen = target.count

    if sourceLen == 0 { return targetLen }
    if targetLen == 0 { return sourceLen }

    var v0 = [Int](repeating: 0, count: targetLen + 1)
    var v1 = [Int](repeating: 0, count: targetLen + 1)

    for i in 0..<v0.count { v0[i] = i }

    for i in 0..<sourceLen {
      v1[0] = i + 1
        for j in 0..<targetLen {
          var cost = 1
          if source[source.index(source.startIndex, offsetBy: i)] == target[target.index(target.startIndex, offsetBy: j)] {
            cost = 0
          }
          v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
        }
        for j in 0..<v0.count { v0[j] = v1[j] }
      }

      return v1[targetLen]
  }

  static func shortestDistance(forSource source: String, withChoices choices: [String]) -> String {
    return choices.map { choice in
      return (distance(source: source, target: choice), choice)
    }.sorted { first, second in
      return first.0 < second.0
    }.first?.1 ?? source
  }

}
