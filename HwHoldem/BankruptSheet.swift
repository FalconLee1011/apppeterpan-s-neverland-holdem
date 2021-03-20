//
//  BankruptSheet.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/25.
//

import SwiftUI

struct BankruptSheet: View {
    var body: some View {
      Text("[̲̅$̲̅(̲̅ ͡° ͜ʖ ͡°̲̅)̲̅$̲̅] 你破產了！ [̲̅$̲̅(̲̅ ͡° ͜ʖ ͡°̲̅)̲̅$̲̅]")
      Text("您沒有足夠的資金參與本系統的活動，請儘速離開。")
    }
}

struct BankruptSheet_Previews: PreviewProvider {
    static var previews: some View {
        BankruptSheet()
    }
}
