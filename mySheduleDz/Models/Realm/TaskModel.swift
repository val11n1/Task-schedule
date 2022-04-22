//
//  TaskModel.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 08.03.2022.
//

import RealmSwift


class TaskModel: Object {
    
    @Persisted var taskDate : Date?
    @Persisted var taskLessonName : String  = "Unknown"
    @Persisted var taskDescription : String = "Unknown"
    @Persisted var taskColor : String       = "1A4766"
    @Persisted var taskReady : Bool         = false
}
