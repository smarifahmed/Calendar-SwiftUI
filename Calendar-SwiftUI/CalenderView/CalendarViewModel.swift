//
//  CalendarViewModel.swift
//  Calander-SwiftUI
//
//  Created by SM Arif Ahmed on 9/9/22.
//

import Foundation
import SwiftUI

class CalendarViewModel : ObservableObject{
    @Published var dateArray : [String] = []
    @Published var title : String = ""
    @Published var showMonthGrid : Bool = false
    
    let daysArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let monthsArray = ["January", "February","March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let dateCollumns = [GridItem](repeating: GridItem(.flexible()), count: 7 )
    let monthsCollumns = [GridItem](repeating: GridItem(.flexible()), count: 3 )
    
    private var visibleMonth = Date()
    
    init(){
        getDateArray(visible: visibleMonth)
    }
    
    func updateTitle(){
        if showMonthGrid{
            let monthString = date(format: "yyyy", date: visibleMonth)
            self.title = monthString
        }else{
            let monthString = date(format: "MMMM yyyy", date: visibleMonth)
            self.title = monthString
        }
    }
    
    func prev(){
        let date = Calendar.current.date(byAdding: showMonthGrid ? .year : .month,
                                         value: -1,
                                         to: visibleMonth)
        if let date = date {
            visibleMonth = date
            getDateArray(visible: date)
        }
    }
    
    func next(){
        let date = Calendar.current.date(byAdding: showMonthGrid ? .year : .month,
                                         value: +1,
                                         to: visibleMonth)
        if let date = date {
            visibleMonth = date
            getDateArray(visible: date)
        }
    }
    
    func getPickedDate(_ day : Int) -> String{
        let tempString = date(format: "MMM yyyy", date: visibleMonth)
        return String(day)+" "+tempString
    }
    
    func getPickedMonth(_ month : Int){
        let year = self.date(format: "yyyy", date: visibleMonth)
        let month = String(format: "%02d", month)
        let dateString = month+"-"+year
        let date = self.date(format: "MM-yyyy", dateString: dateString)
        visibleMonth = date
        updateTitle()
        getDateArray(visible: date)
    }
    
    /// This fuction generates dates of a specific month from the given Date() object
    /// - Parameter visible: a Date() object
    private func getDateArray(visible : Date){
        let currentDateString = date(format: "dd-MM-yyyy", date: visible)
        let stringComp = currentDateString.components(separatedBy: "-")
        let startDateString = "01-"+stringComp[1]+"-"+stringComp[2]
        let startDate = date(format: "dd-MM-yyyy", dateString: startDateString)
        
        let components = Calendar.current.dateComponents([.day,.month,.year,.weekday,], from: startDate)
        let calender = Calendar.current
        let range = calender.range(of: .day, in: .month, for: visible)
        
        var dateArrayTemp : [String] = []
        for _ in 1..<components.weekday!{
            dateArrayTemp.append("")
        }
        
        for i in 1...(range?.last ?? 1){
            dateArrayTemp.append("\(i)")
        }
        
        self.dateArray = dateArrayTemp
        updateTitle()
    }
    
    
    /// For generating Date String of a specing fromat from a Date() object
    /// - Parameters:
    ///   - format: Date format in String , ex. "DD-MM-yyyy"
    ///   - date: The Date() object to convert
    /// - Returns: Converted DateString
    private func date(format : String, date : Date = Date()) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let string = formatter.string(from: date)
        return string
    }
    
    /// For generating Date() object a DateString
    /// - Parameters:
    ///   - format: Date format in String , ex. "DD-MM-yyyy"
    ///   - dateString: DateString of the given format
    /// - Returns: Converted Date Object
    private func date(format : String, dateString : String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: dateString)
        return date ?? Date()
    }
}
