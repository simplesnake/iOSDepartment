//
//  TimeInterval+Extensions.swift
//  iOSDepartment
//
//  Created by Мявкo on 26.10.24.
//  Copyright © 2024 Stroev. All rights reserved.
//

import Foundation

extension TimeInterval {
    func formattedString() -> String {
        guard self.isFinite else { return "00:00" }
        let totalSeconds = Int(self.rounded())
        let minutes = totalSeconds / 60
        let seconds = totalSeconds - minutes * 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
