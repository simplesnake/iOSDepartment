//
//  PaginationResponse.swift
//  iOSDepartment
//
//  Created by Александр Строев on 29.08.2021.
//  Copyright © 2021 Stroev. All rights reserved.
//

import Foundation

class PaginationResponse<ResponseData: Decodable>: Decodable {
    var data: [ResponseData]
    var total: Int
}
