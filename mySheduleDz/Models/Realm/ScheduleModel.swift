//
//  ScheduleModel.swift
//  mySheduleDz
//
//  Created by Valeriy Trusov on 05.03.2022.
//

import RealmSwift

class ScheduleModel: Object {
    
    @Persisted var scheduleDate : Date?
    @Persisted var scheduleTime : Date?
    @Persisted var scheduleName: String = "Unknown"
    @Persisted var scheduleType: String = "Unknown"
    @Persisted var scheduleBuilding: String = "Unknown"
    @Persisted var scheduleAudience: String = "Unknown"
    @Persisted var scheduleTeacher: String = "Unknown"
    @Persisted var scheduleColor: String = "1A4766"
    @Persisted var scheduleRepeat: Bool = true
    @Persisted var scheduleWeekDay: Int = 1

}
