//
//  ContentView.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/09.
//

import ARKit
import Combine
import DiceContent
import RealityKit
import simd
import SwiftUI

struct ContentView: View {

    let session = ARKitSession()
    let worldInfoProvider = WorldTrackingProvider()
    @State var scene = Entity()
    @State var enlarge = false
    @State var sceneUpdateSubscription : Cancellable? = nil

    var body: some View {
        
        
        
        VStack {
            RealityView {  content in
                
                try? await session.run([worldInfoProvider])
                
                // Called per every frame
                sceneUpdateSubscription = content.subscribe(to: SceneEvents.Update.self) { event in
                    guard let pose = worldInfoProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else { return }
                    let dt = event.deltaTime
                    let toDeviceTransform = pose.originFromAnchorTransform
                    print("dt: \(dt), toDeviceTransform: \(toDeviceTransform)")
//                    let devicePosition = toDeviceTransform.translation
//                    deviceRotation = toDeviceTransform.upper3x3
//                    scene.position = devicePosition
                    scene.transform = .init(
                        matrix: 
                                .init(toDeviceTransform.columns.0,
                                      toDeviceTransform.columns.1,
                                      toDeviceTransform.columns.2,
                                      .init(
                                        x: toDeviceTransform.columns.3.x, 
                                        y: toDeviceTransform.columns.3.y,
                                        z: toDeviceTransform.columns.3.z - 1.0, w: toDeviceTransform.columns.3.w)
                                     )
                    )
                    
                } as? any Cancellable
                
                // Add the initial RealityKit content
                if let scene = try? await Entity(named: "Scene", in: diceContentBundle) {
                    self.scene = scene
                    content.add(scene)
                }
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
                if let scene = content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    scene.transform.scale = [uniformScale, uniformScale, uniformScale]
                }
            }
            .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
                enlarge.toggle()
            })

            VStack {
                Toggle("Enlarge RealityView Content", isOn: $enlarge)
                    .toggleStyle(.button)
            }.padding().glassBackgroundEffect()
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
