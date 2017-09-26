//
//  ClientError.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

internal enum TwitterClientError: Error {
    case requestError(Error)
}
