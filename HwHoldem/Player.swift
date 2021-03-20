//
//  Player.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/21.
//

import Foundation

enum Role: CustomStringConvertible{
  case SmallBlind, BigBlind, Dealer, Player
  
  var description : String {
    switch self {
      case .SmallBlind: return "SmallBlind"
      case .BigBlind: return "BigBlind"
      case .Dealer: return "Dealer"
      case .Player: return "Player"
    }
  }
}

enum PlayerType{
  case NonPlayer, Player
}

class Player: ObservableObject {
  var name: String
  var role: Role
  var cards: Array<Poker>
  var chip: Int = 1000
  var currentBet: Int = 0
  var hasFold: Bool = false
  var playerType: PlayerType
  var hasPlayedFirstRoundAsBigBlind: Bool = false
  
  init(name: String, role: Role, cards: Array<Poker> = [], playerType: PlayerType) {
    self.name = name
    self.role = role
    self.cards = cards
    self.playerType = playerType
    self.hasPlayedFirstRoundAsBigBlind = false
  }
  
  func bet(_ bet: Int) -> Int{
    var bet = 100
    if(self.role == .BigBlind && !self.hasPlayedFirstRoundAsBigBlind){
      bet *= 2
    }
    self.currentBet = bet
    self.chip -= bet
    self.hasPlayedFirstRoundAsBigBlind = true
    return self.currentBet
  }
  
  func fold(){
    self.hasFold = true
  }
  
  func newGame(role: Role){
    self.hasFold = false
    self.currentBet = 0
    self.role = role
    self.hasPlayedFirstRoundAsBigBlind = false
  }
  
}
