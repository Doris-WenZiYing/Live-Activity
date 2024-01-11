//
//  ContentView.swift
//  LiveActivity
//
//  Created by Doris Wen on 2023/12/27.
//

import SwiftUI
import ActivityKit

struct ContentView: View {

    @State var currentID: String = ""
    @State var currentSelection: Status = .recieved

    var body: some View {
        NavigationStack {
            VStack {

                Picker(selection: $currentSelection) {
                    Text("Recieved")
                        .tag(Status.recieved)
                    Text("Progress")
                        .tag(Status.progress)
                    Text("Ready")
                        .tag(Status.ready)
                } label: {

                }
                .labelsHidden()
                .pickerStyle(.segmented)

                HStack {
                    // MARK: Initializing Activity
                    Button("Start Activity") {
                        addLiveActivity()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)

                    // MARK: Removing Activity
                    Button("Remove Activity") {
                        removeActivity()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
            }
            .navigationTitle("Live Activity")
            .padding(15)
            .onChange(of: currentSelection) { _, newValue in
                if let activity = Activity.activities.first(where: { (activity: Activity<OrderAttributes>) in
                    activity.id == currentID
                }) {
                    print("Activity Found")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        var updateState = activity.content.state
                        updateState.status = currentSelection
                        Task {
                            await activity.update(using: updateState)
                        }
                    }
                }
            }
        }
    }

    // NOTE: Need to add key in info.plist
    func addLiveActivity() {
        let orderAttributes = OrderAttributes(orderNum: 1234, orderItem: "Burger")
        let initialContentState = OrderAttributes.ContentState()
        let content = ActivityContent(state: initialContentState, staleDate: nil)

        do {
            let activity = try Activity<OrderAttributes>.request(attributes: orderAttributes, content: content, pushType: nil)

            // MARK: Store current data for updating activity
            currentID = activity.id
            print("Activity Added Successfully. id: \(activity.id)")
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeActivity() {
        if let activity = Activity.activities.first(where: { (activity: Activity<OrderAttributes>) in
            activity.id == currentID
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Task {
                    await activity.end(using: activity.contentState, dismissalPolicy: .immediate)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
