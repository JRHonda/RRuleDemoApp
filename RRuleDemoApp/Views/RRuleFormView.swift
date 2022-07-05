//
//  RRuleFormView.swift
//  RRuleDemoApp
//
//  Created by Justin Honda on 7/3/22.
//

import SwiftUI

struct RRuleFormView: View {
    
    @State private var frequency: RRule.Frequency = .daily
    @State private var repeatEveryDaySelectedIndex: Int = 0
    @State private var repeatEveryWeekSelectedIndex: Int = 0
    @State private var days: Set<RRule.Day> = [.sunday]
    
    var body: some View {
        Form {
            Section(header: Text("Repeat")) {
                Picker("Frequency", selection: $frequency) {
                    Text(RRule.Frequency.daily.rawValue).tag(RRule.Frequency.daily)
                    Text(RRule.Frequency.weekly.rawValue).tag(RRule.Frequency.weekly)
                }
                
                if frequency == .daily {
                    Picker("Every", selection: $repeatEveryDaySelectedIndex) {
                        ForEach(1..<85) { Text("\($0) day\($0 > 1 ? "s" : "")") }
                    }
                }
                
                if frequency == .weekly {
                    Picker("Every", selection: $repeatEveryDaySelectedIndex) {
                        ForEach(1..<13) { Text("\($0) week\($0 > 1 ? "s" : "")") }
                    }
                    
                    // TODO: - Need to create a MultiPicker
                    Picker("On the following days", selection: $days) {
                        ForEach(RRule.Day.allCases) { Text("\($0.id)") }
                    }
                }
            }
        }
        .onChange(of: frequency) { _ in
            // reset indexes when frequency changes
            repeatEveryDaySelectedIndex = 0
            repeatEveryWeekSelectedIndex = 0
        }
    }
}

struct RRuleFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RRuleFormView()
        }
        
    }
}
