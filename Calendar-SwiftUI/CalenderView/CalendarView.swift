//
//  ContentView.swift
//  Calander-SwiftUI
//
//  Created by SM Arif Ahmed on 9/9/22.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject private var vm = CalendarViewModel()
    
    var body: some View {
        ZStack{
            VStack(spacing : 20){
                HStack{
                    prevButton
                    Spacer()
                    title
                    Spacer()
                    nextButton
                }
                .padding(.top)
                
                
                if !vm.showMonthGrid{
                    VStack{
                        weekDays
                        Spacer()
                        dateGrid
                        Spacer()
                    }
                    .transition(.moveAndFade)
                }else{
                    VStack{
                        Spacer()
                        monthGrid
                        Spacer()
                    }
                    .transition(.moveAndFade)
                }
                Spacer()
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.36)
        .border(.black, width: 1)
        .padding([.leading, .trailing])
        .shadow(color: .gray.opacity(0.5), radius: 1.5, x: 5, y: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

extension CalendarView{
    
    private var title : some View{
        Text(vm.title)
            .animation(nil, value: vm.showMonthGrid)
            .onTapGesture {
                withAnimation {
                    vm.showMonthGrid.toggle()
                    vm.updateTitle()
                }
            }
    }
    
    private var prevButton : some View{
        Button {
            vm.prev()
        } label: {
            Image(systemName: "chevron.backward")
                .tint(Color.black)
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.leading)
        }
    }
    
    private var nextButton : some View{
        Button {
            vm.next()
        } label: {
            Image(systemName: "chevron.backward")
                .tint(Color.black)
                .frame(width: 30, height: 30, alignment: .center)
                .rotationEffect(.radians(.pi))
                .padding(.trailing)
        }
    }
    
    private var weekDays : some View{
        HStack{
            ForEach(vm.daysArray, id : \.self) { days in
                Text(days)
                    .frame(maxWidth : .infinity)
            }
        }
    }
    
    private var dateGrid : some View{
        LazyVGrid(columns: vm.dateCollumns, spacing: 10) {
            ForEach(0..<vm.dateArray.count , id : \.self) { i in
                Text(vm.dateArray[i])
                    .frame(maxWidth : .infinity)
                    .onTapGesture {
                        if let day = Int(vm.dateArray[i]){
                            print("Picked Date : ", vm.getPickedDate(day))
                        }
                    }
            }
        }
    }
    
    private var monthGrid : some View{
        LazyVGrid(columns: vm.monthsCollumns, spacing: 10) {
            ForEach(0..<vm.monthsArray.count , id : \.self) { i in
                Text(vm.monthsArray[i])
                    .frame(height : 40)
                    .frame(maxWidth : .infinity)
                    .border(.black, width: 1)
                    .onTapGesture {
                        withAnimation {
                            vm.showMonthGrid.toggle()
                        }
                        vm.getPickedMonth(i + 1)
                        vm.updateTitle()
                    }
            }
        }
        .padding([.leading,.trailing])
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}
