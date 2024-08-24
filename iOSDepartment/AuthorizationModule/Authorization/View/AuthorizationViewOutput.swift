//
//  AuthorizationViewOutput.swift
//  iOSDepartment
//
//  Created by Fox on 24.08.2024.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation
import UIKit

protocol AuthorizationViewOutput: BaseViewOutput {
	func backButtonWasTapped()
}

extension AuthorizationPresenter: AuthorizationViewOutput {
	func backButtonWasTapped() {
		router.back()
	}
}
