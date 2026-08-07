//
//  Calendar.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import SwiftUI

struct CalendarReal: View {
    @State private var currentMonth: Date = Date()
    
    let completedDates: Set<DateComponents> = [
        DateComponents(year: 2026, month: 7, day:1)
    ]
    
    let columns = Array(repeating: GridItem(.flexible()), count:7)
    let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        VStack{
            Text("Your Streaks")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.bottom, 25)
            
            Spacer()
            
            ZStack{
                Circle()
                    .frame(width: 290, height: 300)
                    .foregroundStyle(.brown)
                VStack{
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 150)
                        .foregroundStyle(.orange)
                        .padding(7)
                    Text("12")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(5)
                    
                }
                
            }
            
            Spacer()
                .padding(.vertical, 10)
            
            VStack(spacing: 12){
                HStack{
                    Menu{
                        Picker("Month", selection: Binding(
                            get: { Calendar.current.component(.month, from: currentMonth)},
                            set: { newMonth in updateMonth(to: newMonth)}
                        )) {
                            ForEach((1...12).reversed(), id: \.self) { month in Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                        }
                    }
                    let startYear = 2026
                        let futureLimit = Calendar.current.component(.year, from: Date()) + 5
                        let yearRange = startYear...max(startYear, futureLimit)
                        
                    Picker("Year", selection: Binding(
                        get: { Calendar.current.component(.year, from: currentMonth)},
                        set: { newYear in updateYear(to: newYear)}
                    )) {
                        ForEach(yearRange.reversed(), id: \.self) { year in Text(String(format: "%d", year)).tag(year)
                        }
                    }
                    } label: {
                        HStack(spacing: 4) {
                            Text(monthYearFormatter.string(from:currentMonth))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .fixedSize(horizontal: true, vertical: false)
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        .frame(width: 170, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    
                    Button(action: { changeMonth(by: -1)}) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing, 12)
                    
                    Button(action: { changeMonth(by: 1)}) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(daysOfWeek, id: \.self) { day in Text(day)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                }
                
                LazyVGrid(columns: columns, spacing: 12) {
                    let offset = firstWeekdayOffset()
                    let daysInMonth = numberOfDaysInMonth()
                    
                    let currentYear = Calendar.current.component(.year, from: currentMonth)
                    let currentMonthInt = Calendar.current.component(.month, from: currentMonth)
                    
                    ForEach(0..<42, id: \.self) { index in let dayNumber = index - offset + 1
                        
                        if dayNumber >= 1 && dayNumber <= daysInMonth {
                            
                            let targetComponents = DateComponents(year: currentYear, month: currentMonthInt, day: dayNumber)
                            let isCompleted = completedDates.contains(targetComponents)
                            
                            ZStack {
                                if isCompleted {
                                    Circle()
                                        .fill(Color.orange.opacity(0.3))
                                        .frame(width: 32, height: 32)
                                }
                                
                                Text("\(dayNumber)")
                                    .font(.system(size:16, weight: isCompleted ? .bold: .regular))
                                    .foregroundColor(isCompleted ? .orange: .primary)
                            }
                            .frame(height: 32)
                        } else {
                            Text("")
                                .frame(height: 32)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
            
            private var monthYearFormatter: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM yyyy"
                return formatter
            }
            
            private func changeMonth(by value: Int) {
                if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
                    currentMonth = newDate
                }
            }
            
            private func numberOfDaysInMonth() -> Int {
                let range = Calendar.current.range(of: .day, in: .month, for: currentMonth)
                return range?.count ?? 30
            }
            
            private func firstWeekdayOffset() -> Int {
                let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
                guard let firstDay = Calendar.current.date(from: components) else { return 0 }
                return Calendar.current.component(.weekday, from: firstDay) - 1
            }
            
            private func updateMonth(to newMonth: Int) {
                var components = Calendar.current.dateComponents([.year, .month, .day], from: currentMonth)
                components.month = newMonth
                if let newDate = Calendar.current.date(from: components) {
                    currentMonth = newDate
                }
            }
            
            private func updateYear(to newYear: Int) {
                var components = Calendar.current.dateComponents([.year, .month, .day], from: currentMonth)
                components.year = newYear
                if let newDate = Calendar.current.date(from: components) {
                    currentMonth = newDate
                }
            }
        }
#Preview {
    CalendarReal()
}
