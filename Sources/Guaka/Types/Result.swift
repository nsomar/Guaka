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
  case error(CommandType, Error)
}
