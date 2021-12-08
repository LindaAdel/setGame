//
//  Extensions.swift
//  SetGame
//
//  Created by Linda adel on 12/2/21.
//

import Foundation

extension  Set {
    
    mutating public func removeRandomElement() -> Element?{
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex , offsetBy : n)
        if self.count > 0  {
            let element = self.remove(at : index)
            return element
        }else {
            return nil
        }
    }

}
