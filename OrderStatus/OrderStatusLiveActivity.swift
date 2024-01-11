//
//  OrderStatusLiveActivity.swift
//  OrderStatus
//
//  Created by Doris Wen on 2023/12/27.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderStatusLiveActivity: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderAttributes.self) { context in
            // MARK: Live Activity View
            // NOTE: Live Activity Max Height = 220 pixels
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.white.gradient)
                
                VStack {
                    HStack {
                        Image(systemName: "fork.knife.circle")
                            .resizable()
                            .foregroundStyle(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .padding()
                        
                        Text("In store pickup")
                            .foregroundStyle(.black.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: -2) {
                            ForEach(["burger", "fries"], id: \.self) { image in
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                                    .background {
                                        Circle()
                                            .fill(Color.white.gradient)
                                            .padding(-4)
                                    }
                                    .background {
                                        Circle()
                                            .stroke(.black, lineWidth: 1.5)
                                            .padding(-4)
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message(status: context.state.status))
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Text(subMessage(status: context.state.status))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                        
                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(Status.allCases, id: \.self) { type in
                                Image(systemName: type.rawValue)
                                    .font(context.state.status == type ? .title2 : .body)
                                    .foregroundStyle(context.state.status == type ? Color.black : Color.gray)
                                    .frame(width: context.state.status == type ? 45 : 32, height: context.state.status == type ? 45 : 32)
                                    .background {
                                        Circle()
                                            .fill(context.state.status == type ? Color.white : Color.black.opacity(0.1))
                                    }
                                    .frame(width: 50)
                                // MARK: Buttom Arrow To Look Like Bubble
                                    .background(alignment: .bottom, content: {
                                        BottomArrow(status: context.state.status, type: type)
                                    })
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .overlay(alignment: .bottom, content: {
                            Rectangle()
                                .fill(.white.opacity(0.6))
                                .frame(height: 2)
                                .offset(y: 14)
                                .padding(.horizontal, 31.5)
                        })
                    }
                    .offset(y: -10)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .padding(15)
            }
        } dynamicIsland: { context in
            // Expand when long press
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "fork.knife.circle")
                            .font(.title3)
                            .frame(width: 40, height: 40)
                        
                        Text("Store Pickup")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(spacing: -6) {
                        ForEach(["burger", "fries"], id: \.self) { image in
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .background {
                                    Circle()
                                        .fill(Color.white.gradient)
                                        .padding(-4)
                                }
                                .background {
                                    Circle()
                                        .stroke(.black, lineWidth: 1.5)
                                        .padding(-4)
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                DynamicIslandExpandedRegion(.center) {
                    //                    Text("center")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    DynamicIslandStatusView(context: context)
                }
            } compactLeading: {
                Image(systemName: "fork.knife.circle")
                    .font(.title3)
            } compactTrailing: {
                Image(systemName: context.state.status.rawValue)
                    .font(.title3)
            } minimal: {
                Image(systemName: context.state.status.rawValue)
                    .font(.body)
            }
        }
    }
    
    @ViewBuilder
    func DynamicIslandStatusView(context: ActivityViewContext<OrderAttributes>) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(message(status: context.state.status))
                    .font(.callout)
                    .foregroundStyle(.primary)
                Text(subMessage(status: context.state.status))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(Status.allCases, id: \.self) { type in
                    Image(systemName: type.rawValue)
                        .font(context.state.status == type ? .title2 : .body)
                        .foregroundStyle(context.state.status == type ? Color.black : Color.gray)
                        .frame(width: context.state.status == type ? 32 : 23, height: context.state.status == type ? 32 : 23)
                        .background {
                            Circle()
                                .fill(context.state.status == type ? Color.white : Color.black.opacity(0.1))
                        }
                        .frame(width: 40, height: 20)
                    // MARK: Buttom Arrow To Look Like Bubble
                        .background(alignment: .bottom, content: {
                            BottomArrow(status: context.state.status, type: type)
                        })
                        .frame(maxWidth: .infinity)
                }
            }
            .background(alignment: .bottom, content: {
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(height: 2)
                    .offset(y: 13)
                    .padding(.horizontal, 32.5)
            })
        }
    }
    
    @ViewBuilder
    func BottomArrow(status: Status, type: Status) -> some View {
        ZStack(alignment: .bottom) { // Use ZStack for better layer control
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 15))
                .scaleEffect(x: 1.3)
                .offset(y: 6)
                .opacity(status == type ? 1 : 0)
                .foregroundStyle(.white)
            
            Circle() // Move the circle outside of the overlay
                .fill(.white)
                .frame(width: 5, height: 5)
                .offset(y: 15)
        }
    }
    
    // MARK: Main Title
    func message(status: Status) -> String {
        switch status {
        case .recieved:
            return "Order Recieved"
        case .progress:
            return "Order In Progress"
        case .ready:
            return "Order Ready"
        }
    }
    
    // MARK: Sub Title
    func subMessage(status: Status) -> String {
        switch status {
        case .recieved:
            return "We just recieved your order."
        case .progress:
            return "We are making your order."
        case .ready:
            return "Your order is ready."
        }
    }
}
