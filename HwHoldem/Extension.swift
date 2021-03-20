//
//  Extension.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/21.
//

import Foundation

extension Array{
  mutating func _RR() -> [Element] {
    let tr = self[0]
    self.remove(at: 0)
    self.append(tr)
    return self
  }
  mutating func RR(){
    self = _RR()
  }
  
  mutating func _RL() -> [Element] {
    let tr = self[self.count - 1]
    self.remove(at: self.count - 1)
    self.insert(tr, at: 0)
    return self
  }
  mutating func RL(){
    self = _RL()
  }
}
