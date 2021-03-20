//
//  WinnerSheet.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/24.
//

import SwiftUI

struct WinnerSheet: View {
  
  @Binding var leaderboard: Dictionary<String, winnerRank>
  
  @State var leaderboardSortedKeys: [String] = []
  
  var body: some View {
    Text("Round result")
      .onAppear(perform: {
        leaderboardSortedKeys = leaderboard.keys.sorted(by: { (r1, r2) -> Bool in
          return Int(leaderboard[r1]!.description)! > Int(leaderboard[r2]!.description)!
        })
      })
    //    ForEach(Array(leaderboard.keys), id: \.self){ key in
    //      HStack{
    //        Text(key).padding(.leading, 100)
    //        Spacer()
    //        Text("\(rankMeta[leaderboard[key]!]!)").padding(.trailing, 100)
    //      }
    //    }
    //
    if(leaderboardSortedKeys.count != 0){
      ForEach(leaderboardSortedKeys, id: \.self){ (key) in
        HStack{
          Text("\(key) \(_isWinner(rank: leaderboard[key]!))").padding(.leading, 50)
          Spacer()
          Text("\(rankMeta[leaderboard[key]!]!)").padding(.trailing, 50)
        }
      }
    }
  }
  
  func _isWinner(rank: winnerRank) -> String{
    let hRank = leaderboard[leaderboardSortedKeys[0]]
    if (rank == hRank){
      return "Winner!"
    }
    return ""
  }
}
