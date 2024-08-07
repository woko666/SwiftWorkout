import Foundation
import SwiftUI

struct DurationPickerView: View {
    @Binding var durationSeconds: Int
    let width: CGFloat
    var hourSelection: Binding<Int> {
        .init(get: { durationSeconds / 3600 }, set: { durationSeconds = $0 * 3600 + minuteSelection.wrappedValue * 60 })
    }
    var minuteSelection: Binding<Int> {
        .init(get: { (durationSeconds % 3600) / 60 }, set: { durationSeconds = $0 * 60 + hourSelection.wrappedValue * 3600 })
    }
    
    static private let maxHours = 24
    static private let maxMinutes = 60
    private let hours: [Int] = Array(0...24)
    private let minutes: [Int] = (0...11).map { $0 * 5 }
    
    var body: some View {
        HStack(spacing: 0) {
            Picker(selection: hourSelection, label: Text("")) {
                ForEach(hours, id: \.self) { value in
                    Text("\(value) hr")
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: max(width / 2, 0), alignment: .center)
            
            Picker(selection: minuteSelection, label: Text("")) {
                ForEach(minutes, id: \.self) { value in
                    Text("\(value) min")
                        .tag(value)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .pickerStyle(.wheel)
            .frame(width: max(width / 2, 0), alignment: .center)
        }
    }
}

#Preview {
    @State var durationSeconds = 6000
    
    return DurationPickerView(durationSeconds: $durationSeconds, width: 300)
}
