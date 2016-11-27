//
//  Result.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

/// Result enum
///
/// - success: success
/// - message: success but with a message
/// - error:   error occured
enum Result {
  case success
  case message(String)
  case error(Error)
}
