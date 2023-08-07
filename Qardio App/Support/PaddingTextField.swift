//
//  PaddingTextField.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PaddingTextField: UITextField {
  
  var inset: CGFloat = 0.0
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    var bounds = bounds
    bounds.origin.x += inset
    bounds.size.width -= inset
    return bounds
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    var bounds = bounds
    bounds.origin.x += inset
    bounds.size.width -= inset
    return bounds
  }
  
}
