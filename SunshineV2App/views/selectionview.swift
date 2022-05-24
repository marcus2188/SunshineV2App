//
//  selectionview.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import SwiftUI

struct selectionview: View {
    @StateObject var gs: gamestate = gamestate()
    var body: some View {
        NavigationView{
            VStack(spacing: 50){
                Text("Choose your game").screenmaintitle()
                modebutton(buttontext: "Classic", buttonbgname: "classicmode").shadow(color: gs.mode==modetype.CLASSIC ? Color("AccentColor") : .white, radius: 30).onTapGesture {
                    gs.mode = modetype.CLASSIC
                }
                modebutton(buttontext: "Zen Mode", buttonbgname: "zenmode").shadow(color: gs.mode==modetype.ZEN ? Color("AccentColor") : .white, radius: 30).onTapGesture {
                    gs.mode = modetype.ZEN
                }
                modebutton(buttontext: "Odd One Out", buttonbgname: "oddmode").shadow(color: gs.mode==modetype.ODDONEOUT ? Color("AccentColor") : .white, radius: 30).onTapGesture {
                    gs.mode = modetype.ODDONEOUT
                }
                modebutton(buttontext: "Practice", buttonbgname: "trainingmode").shadow(color: gs.mode==modetype.TRAINING ? Color("AccentColor") : .white, radius: 30).onTapGesture {
                    gs.mode = modetype.TRAINING
                }
                navigationbutton(buttontext: "Language: " + String(describing: gs.lang)).onTapGesture {
                    gs.lang = gs.lang.next()
                }
                HStack(spacing: 40){
                    NavigationLink(destination: ContentView()){
                        primarybutton(buttontext: "Back")
                    }
                    NavigationLink(destination: explainview(gs:gs)){
                        primarybutton(buttontext: "Lets GO")
                    }.disabled(gs.mode==modetype.NONE)
                }
                
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(red: 0.984, green: 0.929, blue: 0.847)).edgesIgnoringSafeArea(.all).navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

struct selectionview_Previews: PreviewProvider {
    static var previews: some View {
        selectionview()
    }
}
