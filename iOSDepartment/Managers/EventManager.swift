//
//  EventManager.swift
//  iOSDepartment
//
//  Created by 7winds on 06.03.2022.
//  Copyright © 2022 Stroev. All rights reserved.
//

import Foundation

class EventManager {
    public static var events: [EMEvent] = []
    
    public static func reactionBy(eventId: EMEventId, subject: EMSubject) {
        let foundEvent: [EMEvent] = events.filter { $0.id == eventId }
        if !foundEvent.isEmpty {
            foundEvent[0].addSubject(subject: subject)
        } else {
            let newEvent = EMEvent(id: eventId, subjects: [subject])
            events.append(newEvent)
        }
    }
    
    public static func reactionBy(_ eventId: EMEventId, reaction: @escaping ((Any) -> Void)) {
        reactionBy(eventId: eventId, subject: EMSubject(reaction: reaction))
    }
    
    public static func event(_ eventId: EMEventId, message: Any? = nil, to: [String] = []) {
        let foundEvent: [EMEvent] = events.filter { $0.id == eventId }
        guard !foundEvent.isEmpty else {
            print("RealReactive: событие \(eventId) не зарегистрировано")
            return
        }
        
        if to.isEmpty {
            foundEvent.first?.subjects.forEach { $0.reaction(message) }
        } else {
            to.forEach({ subjectId in
                foundEvent.first?.subjects.filter { $0.id == subjectId }.forEach { $0.reaction(message) }
            })
        }
    }
}

class EMEvent {
    public var id: EMEventId?
    public var subjects: [EMSubject]
    
    init(id: EMEventId) {
        self.id = id
        self.subjects = []
    }
    
    init(id: EMEventId, subjects: [EMSubject]) {
        self.id = id
        self.subjects = subjects
    }
    
    public func addSubject(subject: EMSubject) {
        subjects.append(subject)
    }
    
    public func removeSubject(subjectId: String) {
        subjects.removeAll { $0.id == subjectId }
    }
}

class EMSubject {
    private static var subjectCount: Int64 = 0
    private static let autoIdPrefix:String = "RealReactiveSubject"
    
    public var id: String?
    public var reaction: ((Any?) -> Void)
    
    init(id: String, reaction: @escaping ((Any?) -> Void)) {
        self.id = id
        self.reaction = reaction
    }
    
    init(reaction: @escaping ((Any?) -> Void)) {
        self.id = "\(EMSubject.autoIdPrefix)\(EMSubject.subjectCount)"
        self.reaction = reaction
        EMSubject.subjectCount += 1
    }
}

enum EMEventId {
    case logout
}
