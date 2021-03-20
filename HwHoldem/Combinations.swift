// credit to https://github.com/raywenderlich/swift-algorithm-club/blob/master/Combinatorics/Combinatorics.playground/Contents.swift

import Foundation

struct permuteWirth{
  
  var comb: Array<Array<Poker>> = []
  
  mutating func permuteWirth<Poker>(_ a: Array<Poker>, _ n: Int) -> Array<Array<Poker>> {
    if n == 0 {
      self.comb.append(a)
      print(a)   // display the current permutation
    } else {
      var a = a
      permuteWirth(a, n - 1)
      for i in 0..<n {
        a.swapAt(i, n)
        permuteWirth(a, n - 1)
        a.swapAt(i, n)
      }
    }
    return self.comb
  }
}

