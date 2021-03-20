//
//  xHoldem.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/20.
//

import Foundation
import Algorithms

enum GameState: CustomStringConvertible {
  case Preflop, Flop, Turn, River, Showdown
  
  var description : String {
    switch self {
    case .Preflop: return "Preflop"
    case .Flop: return "Flop"
    case .Turn: return "Turn"
    case .River: return "River"
    case .Showdown: return "Showdown"
    }
  }
}

enum winnerRank: CustomStringConvertible {
  case RoyalFlush, StraightFlush, FourOfAKind, FullHouse, Flush, Straight, ThreeOfAKind, TwoPair, Pair, HighCard, Fold
  
  var description: String{
    switch self {
    case .RoyalFlush: return "10"
    case .StraightFlush: return "9"
    case .FourOfAKind: return "8"
    case .FullHouse: return "7"
    case .Flush: return "6"
    case .Straight: return "5"
    case .ThreeOfAKind: return "4"
    case .TwoPair: return "3"
    case .Pair: return "2"
    case .HighCard: return "1"
    case .Fold: return "0"
    }
  }
}

let rankMeta: Dictionary<winnerRank, String> = [
  .RoyalFlush: "RoyalFlush",
  .StraightFlush: "StraightFlush",
  .FourOfAKind: "FourOfAKind",
  .FullHouse: "FullHouse",
  .Flush: "Flush",
  .Straight: "Straight",
  .ThreeOfAKind: "ThreeOfAKind",
  .TwoPair: "TwoPair",
  .Pair: "Pair",
  .HighCard: "HighCard",
  .Fold: "Fold"
]

class xHoldem{
  
  var showdown: Bool = false
  
  func generatePokerSets(shuffle: Bool = false) -> Array<Poker>{
    var pokers = Array<Poker>()
    for point in 1...13{
      pokers.append( Poker(suit: .clubs, point: point) )
      pokers.append( Poker(suit: .spades, point: point) )
      pokers.append( Poker(suit: .hearts, point: point) )
      pokers.append( Poker(suit: .diamonds, point: point) )
    }
    if(shuffle) { pokers.shuffle() }
    return pokers
  }
  
  func deal(stash: inout Array<Poker>) -> Poker? {
    if((stash.count == 0)) { return nil }
    let pick = stash[0]
    stash.remove(at: 0)
    return pick
  }
  
  func detectWinner(cards: Array<Poker>, players: Array<Player>) -> Dictionary<String, winnerRank>{
    
    let straightStringPattern: String = "123456789101112131";
    
    var playerRanks = Dictionary<String, winnerRank>()
    
    for player in players{
      
      var playerRank: winnerRank = .HighCard
      
      if(player.hasFold){
        playerRank = .Fold
        continue
      }
      
      var compareCards = cards + player.cards
      
      compareCards.sort { (PokerA, PokerB) -> Bool in
        return PokerA.point < PokerB.point
      }
      
      for c in compareCards.combinations(ofCount: 5) {
        var combo = c
        
        combo.sort { (PokerA, PokerB) -> Bool in
          return PokerA.point < PokerB.point
        }
        
        var pointCounts = Dictionary<Int, Int>()
        var suitCount: Dictionary<Suit, Int> = [ .clubs: 0, .diamonds: 0, .hearts: 0, .spades: 0 ]
        
        for card in combo{
          pointCounts[card.point] = _countPoints(cards: combo, point: card.point)
          suitCount[card.suit]! += 1
        }
        
        var pairs = 0
        var threeKind = 0
        var fourKind = 0
        
        for pointCount in pointCounts{
          if( pointCount.value == 2 ){ pairs += 1 }
          if( pointCount.value == 3 ){ threeKind += 1 }
          if( pointCount.value == 4 ){ fourKind += 1 }
        }
        
        let concatedPoints = _concatPoints(cards: combo)
        
        // Royal
        if( cards[0].point == 1 && cards[1].point == 10 && cards[2].point == 11 && cards[3].point == 12 && cards[4].point == 13 ){
          playerRank = _canGrantRank(cRank: playerRank, nRank: .RoyalFlush)
        }
        
        // Straight Flush
        // Flush
        // Straight
        for suitCnt in suitCount{
          if (suitCnt.value == 5 && straightStringPattern.contains(concatedPoints)){
            playerRank = _canGrantRank(cRank: playerRank, nRank: .StraightFlush)
          }
          else if(suitCnt.value == 5){
            playerRank = _canGrantRank(cRank: playerRank, nRank: .Flush)
          }
          else if(straightStringPattern.contains(concatedPoints)){
            playerRank = _canGrantRank(cRank: playerRank, nRank: .Straight)
          }
        }

        // FourOfAKind
        if(fourKind == 1){ playerRank = _canGrantRank(cRank: playerRank, nRank: .FourOfAKind) }
        
        // FullHouse
        if(threeKind == 1 && pairs == 1){ playerRank = _canGrantRank(cRank: playerRank, nRank: .FullHouse) }
        
        // ThreeOfAKind
        if(threeKind == 1){ playerRank = _canGrantRank(cRank: playerRank, nRank: .ThreeOfAKind) }
        
        // TwoPair
        if(pairs == 2){ playerRank = _canGrantRank(cRank: playerRank, nRank: .TwoPair) }
        
        //Pair
        if(pairs == 1){ playerRank = _canGrantRank(cRank: playerRank, nRank: .Pair) }
      }
      
      playerRanks[player.name] = playerRank
    }
    
    for rank in playerRanks{
      print(rank)
    }
    
    return playerRanks
  }
  
  func _canGrantRank(cRank: winnerRank, nRank: winnerRank) -> winnerRank{
    if Int(nRank.description)! > Int(cRank.description)! { return nRank }
    return cRank
  }
  
  func _countPoints(cards: Array<Poker>, point: Int) -> Int{
    var cnt = 0
    for card in cards{
      if(card.point) == point{ cnt += 1 }
    }
    return cnt
  }
  
  func _concatPoints(cards: Array<Poker>) -> String{
    var concat = ""
    for card in cards{
      concat += String(card.point)
    }
    return concat
  }
  
  func setShowdown() {
    self.showdown = true
  }
  
  func resetGame() {
    self.showdown = false
  }
}
