//
//  Result.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

enum Result {
  case success
  case message(String)
  case commandError(CommandType, Error)
  case flagError(Error)
}
