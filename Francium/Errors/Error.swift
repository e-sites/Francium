//
//  Error.swift
//  Francium
//
//  Created by Bas van Kuijck on 13/07/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
    case alreadyExists
    case cannotCreateFile
    case directoryNotEmpty
}
