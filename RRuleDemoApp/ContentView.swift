//
//  ContentView.swift
//  RRuleDemoApp
//
//  Created by Justin Honda on 7/3/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var time: String = "8:00"
    @State private var frequency: RRule.Frequency = .daily
    @State private var intervalSelectedIndex: Int = 0
    @State private var days: Set<RRule.Day> = [.sunday]
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time")) {
                    Picker("Remind at", selection: $time) {
                        ForEach(Array(8..<24)
                            .map { "\($0):00" }, id: \.self) {
                                Text("\($0)")
                            }
                    }
                }
                
                Section(header: Text("Repeat")) {
                    Picker("Frequency", selection: $frequency) {
                        Text(RRule.Frequency.daily.rawValue).tag(RRule.Frequency.daily)
                        Text(RRule.Frequency.weekly.rawValue).tag(RRule.Frequency.weekly)
                    }
                    
                    if frequency == .daily {
                        Picker("Every", selection: $intervalSelectedIndex) {
                            ForEach(1..<85) { Text("\($0) day\($0 > 1 ? "s" : "")") }
                        }
                    }
                    
                    if frequency == .weekly {
                        Picker("Every", selection: $intervalSelectedIndex) {
                            ForEach(1..<13) { Text("\($0) week\($0 > 1 ? "s" : "")") }
                        }
                        
                        // TODO: - Need to create a MultiPicker
                        Picker("On the following days", selection: $days) {
                            ForEach(RRule.Day.allCases) { Text("\($0.id)") }
                        }
                    }
                }
            }
            .onChange(of: frequency) {
                viewModel.acceptFreq($0)
                intervalSelectedIndex = 0 // reset when frequency changes
            }
            .onChange(of: time) {
                viewModel.acceptTime($0)
            }
            .onChange(of: intervalSelectedIndex) {
                viewModel.acceptIntervalIndex($0)
            }
            
        }
    }
    
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import Combine

class ContentViewModel: ObservableObject {
    
    @Published private var rRule: RRule = .init(frequency: .daily, byMinute: [], byHour: [])
    private var rRuleCancellable: AnyCancellable?
    
    init() {
        rRuleCancellable = $rRule.sink { print($0) }
    }
    
    func acceptFreq(_ freq: RRule.Frequency) {
        rRule.frequency = freq
    }
    
    func acceptIntervalIndex(_ index: Int) {
        rRule.interval = index + 1
    }
    
    func acceptTime(_ time: String) {
        let timeComponents = time.components(separatedBy: ":")
        
        guard let byMinuteStr = timeComponents.last,
              let byMinute = Int(byMinuteStr),
              let byHourStr = timeComponents.first,
              let byHour = Int(byHourStr)
        else { return }
        
        rRule.byMinute.insert(byMinute)
        rRule.byHour.insert(byHour)
    }
    
}
