//
//  explainview.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import SwiftUI

struct explainview: View {
    @ObservedObject var gs: gamestate
    var body: some View {
        NavigationView{
            VStack(spacing: 50){
                Text(gs.mode==modetype.CLASSIC ? "Classic Quiz" : (gs.mode==modetype.ZEN ? "Zen Mode" : (gs.mode==modetype.ODDONEOUT ? "Odd One Out" : (gs.mode==modetype.TRAINING ? "Training" : "None Mode")))).font(.largeTitle).fontWeight(.heavy).foregroundColor(gs.mode==modetype.CLASSIC ? Color.white : Color.black)
                Text(gs.mode==modetype.CLASSIC ? "Test your ability to its potential, by getting as many points of correct answers as you can. You have only 3 lives in total, with no time limit. Good Luck." : (gs.mode==modetype.ZEN ? "This is the mode for you to relax and enjoy the quiz. 10 questions are given at random, and you have unlimited lives and unlimited time to get the best score you can. Go." : (gs.mode==modetype.ODDONEOUT ? "Push yourself to the ultimate challenge to find the wrong imposter amongst the correct options. Race against the clock to score and extend the timer. Survive as long as you can. All the best. " : (gs.mode==modetype.TRAINING ? "Learn at your own pace with a library of languages and text. No pressures, only lessons learnt." : "Test your ability to its potential, by getting as many points of correct answers as you can. You have only 3 lives in total, with no time limit. Good Luck.")))).font(.largeTitle).foregroundColor(gs.mode==modetype.CLASSIC ? Color.white : Color.black)
                Text("Language: " + String(describing: gs.lang)).font(.largeTitle).foregroundColor(gs.mode==modetype.CLASSIC ? Color(0xE39FF6) : Color("AccentColor"))
                HStack(spacing: 40){
                    NavigationLink(destination: selectionview()){
                        primarybutton(buttontext: "Back")
                    }
                    NavigationLink(destination: questionview(gs:gs)){
                        primarybutton(buttontext: "Lets GO")
                    }
                }
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(gs.mode==modetype.ZEN ? Color(red: 0.984, green: 0.929, blue: 0.847) :gs.mode==modetype.CLASSIC ? Color(0x601A35) : Color(0xF6CA97)).edgesIgnoringSafeArea(.all).navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

struct explainview_Previews: PreviewProvider {
    static var previews: some View {
        explainview(gs:gamestate())
    }
}
