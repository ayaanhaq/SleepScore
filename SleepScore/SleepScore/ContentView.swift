//
//  ContentView.swift
//  SleepScore
//
//  Created by Ayaan Haq on 2/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var introItems: [Item] = items
    @State private var selectedIndex: Int = 0
    @State private var showIntro: Bool = true

    var body: some View {
        ZStack {
            if showIntro {
                IntroView(introItems: $introItems, selectedIndex: $selectedIndex, showIntro: $showIntro)
                    .transition(.opacity)
            } else {
                MainView()
                    .transition(.opacity)
            }
        }
    }
}

struct IntroView: View {
    @Binding var introItems: [Item]
    @Binding var selectedIndex: Int
    @Binding var showIntro: Bool

    var body: some View {
        VStack(spacing: 0) {
            Button {
                moveBackward()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(.blue.gradient)
                    .contentShape(.rect)
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(selectedIndex > 0 ? 1 : 0)

            ZStack {
                ForEach(introItems) { item in
                    AnimatedIconView(item)
                }
            }
            .frame(height: 250)
            .frame(maxHeight: .infinity)

            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    ForEach(0..<introItems.count, id: \.self) { index in
                        Capsule()
                            .fill(index == selectedIndex ? Color.primary : .gray)
                            .frame(width: index == selectedIndex ? 25 : 4, height: 4)
                    }
                }
                .padding(.bottom, 15)

                Text(introItems[selectedIndex].title)
                    .font(.title.bold())
                    .contentTransition(.numericText())


                Button {
                    if selectedIndex == introItems.count - 1 {
                        withAnimation {
                            showIntro = false
                            selectedIndex = 0
                        }
                    } else {
                        moveForward()
                    }
                } label: {
                    Text(selectedIndex == introItems.count - 1 ? "Continue" : "Next")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 250)
                        .padding(.vertical, 12)
                        .background(.blue.gradient, in: .capsule)
                }
                .padding(.top, 20)
            }
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .frame(maxHeight: .infinity)
        }
    }

    @ViewBuilder
    func AnimatedIconView(_ item: Item) -> some View {
        let isSelected = introItems[selectedIndex].id == item.id
        
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.white.shadow(.drop(radius: 10)))
            .blendMode(.overlay)
            .frame(width: 120, height: 120)
            .background(.blue.gradient, in: .rect(cornerRadius: 32))
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.background)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: 1, y: 1)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: -1, y: -1)
                    .padding(-3)
                    .opacity(isSelected ? 1 : 0)
            }
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: .center)
            .zIndex(isSelected ? 2 : item.zindex)
    }

    func moveForward() {
        if selectedIndex < introItems.count - 1 {
            withAnimation(.bouncy(duration: 0.6)) {
                selectedIndex += 1
            }
        }
    }

    func moveBackward() {
        if selectedIndex > 0 {
            withAnimation(.bouncy(duration: 0.6)) {
                selectedIndex -= 1
            }
        }
    }
}


struct MainView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Greeting
                Text(getGreeting())
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                

                NavigationLink(destination: SleepScoreView()) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(height: 120)
                        .overlay(
                            VStack(alignment: .leading) {
                                Text("Sleep Score")
                                    .font(.title.bold())
                                    .foregroundColor(.black)
                                
                                Text("Tap to view details")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
                

                NavigationLink(destination: WakeUpTimeView()) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(height: 120)
                        .overlay(
                            VStack(alignment: .leading) {
                                Text("Ideal Wake-Up Time")
                                    .font(.title.bold())
                                    .foregroundColor(.black)
                                
                                Text("Tap to calculate")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
                
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }


    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
            
        }
    }
}


    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    

    func sleepDescription(for progress: CGFloat) -> String {
        let score = progress * 100
        switch score {
        case 80...:
            return "You can expect a more or less normal night of sleep."
        case 50..<80:
            return "You might experience a lower quality of sleep than usual."
        case 25..<50:
            return "You might experience a significantly degraded quality of sleep."
        case ..<25:
            return "You might experience a severely degraded quality of sleep."
        default:
            return "No data available."
        }
    }

struct WakeUpTimeView: View {
    @State private var wakeUpTime: Date = Date()
    @State private var showAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Select Your Bed Time")
                    .font(.title2.bold())

                Spacer()

                Button(action: {
                    showAlert.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                }
                .alert("Sleep Cycle Information", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Each sleep cycle generally lasts 90 minutes.\nTo feel the least groggy, it is best to sleep in durations which are multiples of 90 minutes.")
                }
            }
            .padding(.top, 20)

            DatePicker("", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity)


            sleepOption(title: "Quick Nap", time: quickNapTime, color: .orange)
            sleepOption(title: "Ideal Sleep", time: idealSleepTime, color: .green.opacity(0.7))
            sleepOption(title: "Long Sleep", time: longSleepTime, color: .green.opacity(0.9))

            Spacer()
        }
        .padding()
        .navigationTitle("Wake-Up Time")
    }
    

    private var quickNapTime: String { formatTime(hours: 1, minutes: 30) }
    private var idealSleepTime: String { formatTime(hours: 7, minutes: 30) }
    private var longSleepTime: String { formatTime(hours: 9, minutes: 0) }

    private func formatTime(hours: Int, minutes: Int) -> String {
        var components = DateComponents()
        components.hour = hours
        components.minute = minutes
        let newTime = Calendar.current.date(byAdding: components, to: wakeUpTime) ?? wakeUpTime
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: newTime)
    }


    private func sleepOption(title: String, time: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title2.bold())

            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .overlay(
                    Text(time)
                        .font(.title.bold())
                        .foregroundColor(.white)
                )
        }
    }
}




struct SleepScoreView: View {
    var progress: CGFloat = 0
    @State private var caffeineIntake: String = ""
    @State private var caffeineError: Bool = false
    @State private var hoursBeforeBed: String = ""
    @State private var timeBeforeBedError: Bool = false
    @State private var plannedSleepHours: String = ""
    @State private var plannedSleepError: Bool = false

    func calculateSleepScore(hours: Double, caffeine: Double, timeBeforeBed: Double, bedtimeOffset: Double) -> Int {
        var score = 100.0


        if hours >= 9 {
            score *= 1.0
        } else if hours >= 7 {
            score *= 0.92 + 0.08 * ((hours - 7) / 2)
        } else if hours >= 5 {
            score *= 0.6 + 0.32 * ((hours - 5) / 2)
        } else if hours >= 3 {
            score *= 0.3 + 0.3 * ((hours - 3) / 2)
        } else {
            score *= max(0.05, hours / 3 * 30 / 100)
        }

        if caffeine > 0 {
            let caffeinePenalty = min(20, (caffeine / 500) * 20)
            let timeFactor = exp(-timeBeforeBed / 2)
            score -= caffeinePenalty * timeFactor
        }


        score -= min(20, (bedtimeOffset / 3) * 20)

        return max(Int(score.rounded()), 0)
    }



    func updateProgress() -> CGFloat {
        guard let caffeine = Double(caffeineIntake), caffeine >= 0, caffeine <= 500,
              let plannedSleep = Double(plannedSleepHours), plannedSleep >= 0, plannedSleep <= 12,
              let timeBeforeBed = Double(hoursBeforeBed), timeBeforeBed >= 0, timeBeforeBed <= 12 else {
            return 0
        }
        
        let bedtimeOffset = max(0, 12 - plannedSleep)

        let sleepScore = calculateSleepScore(hours: plannedSleep, caffeine: caffeine, timeBeforeBed: timeBeforeBed, bedtimeOffset: bedtimeOffset)

        return CGFloat(sleepScore) / 100.0
    }


    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                        
                        Circle()
                            .trim(from: 0.0, to: updateProgress())
                            .stroke(progressColor(for: updateProgress()), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.0), value: updateProgress())
                        
                        Text("\(Int(updateProgress() * 100))%")
                            .font(.title.bold())
                            .foregroundColor(progressColor(for: updateProgress()))
                    }
                    .frame(width: 200, height: 200)
                    .padding(.top, 40)
                    
                    Text(sleepDescription(for: updateProgress()))
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                    
                    Divider().padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Caffeine Intake (mg)")
                                .frame(width: 180, alignment: .leading)
                                .padding(.leading, 20)
                            
                            VStack {
                                TextField("Enter caffeine (0-500 mg)", text: $caffeineIntake)
                                    .keyboardType(.numberPad)
                                    .onChange(of: caffeineIntake) { value in
                                        validateCaffeineInput(value)
                                        if value == "0" {
                                            hoursBeforeBed = "0"
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(5)
                                    .padding(.horizontal, 10)
                                
                                if caffeineError {
                                    Text("Enter value between 0-500mg")
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                        .padding(.top, 5)
                                }
                            }
                            .frame(width: 150)
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Text("Time Before Bed (hrs)")
                                .frame(width: 180, alignment: .leading)
                                .padding(.leading, 20)
                            
                            VStack {
                                TextField("Enter time before bed (0-12 hrs)", text: $hoursBeforeBed)
                                    .keyboardType(.numberPad)
                                    .onChange(of: hoursBeforeBed) { validateTimeBeforeBedInput($0) }
                                    .padding(8)
                                    .background(caffeineIntake == "0" ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                                    .cornerRadius(5)
                                    .padding(.horizontal, 10)
                                    .disabled(caffeineIntake == "0")
                                
                                if timeBeforeBedError {
                                    Text("Enter value between 0-12 hours")
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                        .padding(.top, 5)
                                }
                            }
                            .frame(width: 150)
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Text("Planned Sleep (hrs)")
                                .frame(width: 180, alignment: .leading)
                                .padding(.leading, 20)
                            
                            VStack {
                                TextField("Enter planned sleep (0-12 hrs)", text: $plannedSleepHours)
                                    .keyboardType(.numberPad)
                                    .onChange(of: plannedSleepHours) { validatePlannedSleepInput($0) }
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(5)
                                    .padding(.horizontal, 10)
                                
                                if plannedSleepError {
                                    Text("Enter value between 0-12 hours")
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                        .padding(.top, 5)
                                }
                            }
                            .frame(width: 150)
                        }
                        .padding(.top, 20)
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.gray)

                            VStack(alignment: .leading, spacing: 3) {
                                Text("7-9 hours is recommended for adults.")
                                Text("Sleep score is calculated taking into parameters, such as sleep duration and caffeine intake, as well as how long before bedtime the caffeine was consumed.")
                                Text("Try to aim for a higher sleep score to enjoy a good night's sleep.")
                            }
                            .font(.footnote)
                            .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
            }
            .navigationTitle("") 
        }
    }
    
    func validateCaffeineInput(_ value: String) {
        caffeineError = !(Int(value) ?? -1).isBetween(0, 500)
    }
    
    func validateTimeBeforeBedInput(_ value: String) {
        timeBeforeBedError = !(Int(value) ?? -1).isBetween(0, 12)
    }
    
    func validatePlannedSleepInput(_ value: String) {
        plannedSleepError = !(Int(value) ?? -1).isBetween(0, 12)
    }

    func progressColor(for progress: CGFloat) -> Color {
        switch progress {
        case 0.5...: return .green
        case 0.25..<0.5: return .orange
        default: return .red
        }
    }
    
    func sleepDescription(for progress: CGFloat) -> String {
        let score = progress * 100
        return score >= 80 ? "Good sleep expected." : score >= 50 ? "Moderate sleep quality." : "Poor sleep quality."
    }
}

extension Int {
    func isBetween(_ lower: Int, _ upper: Int) -> Bool {
        return self >= lower && self <= upper
    }
}

#Preview {
    ContentView()
}
