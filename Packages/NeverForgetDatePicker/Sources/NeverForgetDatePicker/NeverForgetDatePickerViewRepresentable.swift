import FSCalendar
import SwiftUI

public struct NeverForgetDatePickerViewRepresentable: UIViewRepresentable {
  public typealias UIViewType = NeverForgetDatePickerView

  @Environment(\.colorScheme) var colorScheme
  @Binding var selectedDate: Date
  var datesOfEvents: Set<Date>

  public init(selectedDate: Binding<Date>, datesOfEvents: Set<Date>) {
    _selectedDate = selectedDate
    self.datesOfEvents = datesOfEvents
  }

  public func makeUIView(context: Context) -> NeverForgetDatePickerView {
    let calendar = NeverForgetDatePickerView(colorScheme: colorScheme)
    calendar.myDelegate = context.coordinator
    calendar.select(selectedDate, scrollToDate: true)
    return calendar
  }

  public func updateUIView(_ picker: NeverForgetDatePickerView, context: Context) {
    picker.updateColorScheme(colorScheme)
    context.coordinator.datesOfEvents = datesOfEvents
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(selectedDate: $selectedDate, datesOfEvents: datesOfEvents)
  }

  public class Coordinator: NSObject, NeverForgetDatePickerViewMyDelegate {

    @Binding var selectedDate: Date
    var datesOfEvents: Set<Date>

    public init(selectedDate: Binding<Date>, datesOfEvents: Set<Date>) {
      _selectedDate = selectedDate
      self.datesOfEvents = datesOfEvents
    }

    func customCalendar(_: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
      selectedDate = date
    }

    func customCalendar(_: FSCalendar, eventExists date: Date) -> Bool {
      datesOfEvents.contains { eventDate in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM:dd"
        return dateFormatter.string(from: date) == dateFormatter.string(from: eventDate)
      }
    }

  }

}

// MARK: - Preview

struct NeverForgetDatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    NeverForgetDatePickerViewRepresentable(selectedDate: .constant(.now), datesOfEvents: [Date.now])
      .environment(\.colorScheme, .dark)
  }
}
