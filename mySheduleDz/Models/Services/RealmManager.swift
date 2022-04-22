//
//  RealmManager.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 05.03.2022.
//

import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
        
        let localRealm = try! Realm()
        
        func saveScheduleModel(model: ScheduleModel) {
            
            try! localRealm.write({
                localRealm.add(model)
            })
        }
    
    
    func deleteScheduleModel(model: ScheduleModel) {
        
        try! localRealm.write({
            localRealm.delete(model)
        })
    }
    
    func updateScheduleModel(oldModel: ScheduleModel, newModel: ScheduleModel) {
        
        try! localRealm.write({
            
            oldModel.scheduleDate = newModel.scheduleDate
            oldModel.scheduleTime = newModel.scheduleTime
            oldModel.scheduleName = newModel.scheduleName
            oldModel.scheduleRepeat = newModel.scheduleRepeat
            oldModel.scheduleType = newModel.scheduleType
            oldModel.scheduleColor = newModel.scheduleColor
            oldModel.scheduleAudience = newModel.scheduleAudience
            oldModel.scheduleWeekDay = newModel.scheduleWeekDay
            oldModel.scheduleTeacher = newModel.scheduleTeacher
            oldModel.scheduleBuilding = newModel.scheduleBuilding
        })
    }
    
    
    func saveTaskModel(model: TaskModel) {
        
        try! localRealm.write({
            localRealm.add(model)
        })
    }
    
    func updateTaskModel(model: TaskModel, bool: Bool) {
        
        try! localRealm.write({
            
            model.taskReady = bool
        })
    }
    
    func updateTaskModel(oldModel: TaskModel, newModel: TaskModel) {
        
        try! localRealm.write({
           
            oldModel.taskDate = newModel.taskDate
            oldModel.taskDescription = newModel.taskDescription
            oldModel.taskLessonName = newModel.taskLessonName
            oldModel.taskColor = newModel.taskColor
            oldModel.taskReady = newModel.taskReady
        })
    }
    
    
    func deleteTaskModel(model: TaskModel) {
        
        try! localRealm.write({
            localRealm.delete(model)
        })
    }
    
    
    func saveContactModel(model: ContactModel) {
        
        try! localRealm.write({
            localRealm.add(model)
        })
    }
    
    func deleteContactModel(model: ContactModel) {
        
        try! localRealm.write({
            localRealm.delete(model)
        })
    }
    
    func updateContactModel(model: ContactModel, nameArray: [String], imageData: Data?) {
        
        try! localRealm.write({
            
            model.contactName = nameArray[0]
            model.contactPhone = nameArray[1]
            model.contactMail = nameArray[2]
            model.contactType = nameArray[3]
            model.contactImage = imageData
            
        })
    }
    
}
