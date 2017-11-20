//
//  Constants.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 31.10.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//
import UIKit

public enum Level: Int {
    case Easy = 0, Middle, Hard, VeryHard
}

public enum Grade: Int {
    case Kaplumbaga = 0, Sincap, Koala, Tavsan, Geyik, Kanguru, Kedi, Zurafa, Zebra, Devekusu, Antilop, Aslan, Cita, Sahin
}
public enum LoginMethod : String {
    case Facebook = "Facebook"
    case NewUser = "NewUser"
    case Guest = "Guest"
}

public enum UserDefaultKeys  : String {
    case DefaultsSetted = "DefaultsSetted"
    case LoginMethod = "LoginMethod"
    case Username = "Username"
    case Email = "Email"
    case PhotoUrl = "PhotoUrl"
}

typealias FBLoginCompleted = () -> ()
typealias FBGetProfileCompleted = () -> ()
typealias DBOperationCompleted = () -> ()

public var isWebApiAvailable = false
public let GuestUserNamePrefix = "Misafir_"
public let starterTimerInMinutes = 4
public let countDownTimerInSeconds = 1
public enum Alphabet: Int { case A = 0, B, C, Ç, D, E, F, G, Ğ, H, I, İ, J, K, L, M, N, O, Ö, P, R,
    S, Ş, T, U, Ü, V, Y, Z }
public let hintCountForCurrentGame = 5

public enum UserInsertResult : String {
    case SuccessfullyInserted
    case UsernameAlreadyExists
    case EmailAlreadyExists
    case Unidentified
}
public let HeartTotal = 5


