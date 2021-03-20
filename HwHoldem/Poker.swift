//
//  Poker.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/20.
//

import Foundation

enum Suit{
  case diamonds // ♦
  case clubs    // ♣
  case hearts   // ♥
  case spades   // ♠
}

enum assetType{
  case front, back, frame, blank, invisible
}

class Poker{
  let suit: Suit
  let point: Int
  let frontAsset: String
  let backAsset: String = "card"
  let frameAsset: String = "card-frame"
  let blankAsset: String = "card-blank"
  let invisibleAsset: String = "card-invisible"
  
  init(suit: Suit, point: Int){
    self.suit = suit
    self.point = point
    self.frontAsset = "\(suit)-\(point)"
//    self._point = point + (13 * suit)
  }
  
  func toString(){
    print(self.frontAsset)
  }
  
  func getFrontAsset(_ type: assetType = .front) -> String{
    switch type {
    case .front:
      return self.frontAsset
    case .back:
      return self.backAsset
    case .frame:
      return self.frontAsset
    case .blank:
      return self.blankAsset
    case .invisible:
      return self.invisibleAsset
    }
  }
}
