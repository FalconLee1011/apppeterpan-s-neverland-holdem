//
//  TableView.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/20.
//

import SwiftUI

struct TableView: View {
  
  var boardCards: Array<Poker> = []
  var gameState: GameState = .Preflop
  
  var body: some View {
    VStack{
      Text("Board")
      HStack{
        VStack{
          HStack{
            if(gameState == .Flop || gameState == .Turn || gameState == .River || gameState == .Showdown){
              ZStack{
                Image(boardCards[0].blankAsset).resizable().aspectRatio(contentMode: .fit)
                Image(boardCards[0].frontAsset).resizable().aspectRatio(contentMode: .fit)
              }
            }
            else{
              Image("card-frame").resizable().aspectRatio(contentMode: .fit)
            }
            if(gameState == .Flop || gameState == .Turn || gameState == .River || gameState == .Showdown){
              ZStack{
                Image(boardCards[1].blankAsset).resizable().aspectRatio(contentMode: .fit)
                Image(boardCards[1].frontAsset).resizable().aspectRatio(contentMode: .fit)
              }
            }
            else{
              Image("card-frame").resizable().aspectRatio(contentMode: .fit)
            }
          }.frame(maxHeight: 90)
          HStack{
            if(gameState == .Flop || gameState == .Turn || gameState == .River || gameState == .Showdown){
              ZStack{
                Image(boardCards[2].blankAsset).resizable().aspectRatio(contentMode: .fit)
                Image(boardCards[2].frontAsset).resizable().aspectRatio(contentMode: .fit)
              }
            }
            else{
              Image("card-frame").resizable().aspectRatio(contentMode: .fit)
            }
            if(gameState == .River || gameState == .Turn ||  gameState == .Showdown){
              ZStack{
                Image(boardCards[3].blankAsset).resizable().aspectRatio(contentMode: .fit)
                Image(boardCards[3].frontAsset).resizable().aspectRatio(contentMode: .fit)
              }
            }
            else{
              Image("card-frame").resizable().aspectRatio(contentMode: .fit)
            }
          }.frame(maxHeight: 90)
          HStack{
            if(gameState == .River || gameState == .Showdown){
              ZStack{
                Image(boardCards[4].blankAsset).resizable().aspectRatio(contentMode: .fit)
                Image(boardCards[4].frontAsset).resizable().aspectRatio(contentMode: .fit)
              }
            }
            else{
              Image("card-frame").resizable().aspectRatio(contentMode: .fit)
            }
          }.frame(maxHeight: 90)
        }
      }.padding(.leading, 20).padding(.trailing, 20)
    }
  }
}

struct TableView_Previews: PreviewProvider {
  static var previews: some View {
    TableView()
      .preferredColorScheme(.dark)
  }
}
