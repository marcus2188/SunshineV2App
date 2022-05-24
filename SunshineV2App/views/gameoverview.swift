//
//  gameoverview.swift
//  SunshineV2App
//
//  Created by Ksk I on 22/5/22.
//

import SwiftUI

struct gameoverview: View {
    @ObservedObject var gs: gamestate
    var yourscore: Int
    
    var body: some View {
        NavigationView{
            VStack(spacing: 10){
                Spacer()
                modebutton(buttontext: String(describing: gs.mode)+" MODE", buttonbgname: String(describing: gs.mode)=="CLASSIC" ? "classicmode" : String(describing: gs.mode)=="ZEN" ? "zenmode" : String(describing: gs.mode)=="ODDONEOUT" ? "oddmode" : "trainingmode")
                Spacer()
                Text("You scored a points total of :").font(.largeTitle).foregroundColor(gs.mode==modetype.ZEN ? Color.black : Color.white)
                HStack(spacing: 0){
                    Text(String(yourscore)).font(.system(size: 100)).foregroundColor(gs.mode==modetype.ZEN ? Color.black : Color(0xE39FF6))
                    if gs.mode == modetype.ZEN{
                        Text("/10").font(.title).foregroundColor(Color.black)
                    }
                }
                if gs.mode == modetype.ZEN{
                    Text(yourscore==0 ? "That is ridiculous, because even a random guesser can pass on average or get a few points, unlike you." : yourscore<=4 ? "This failure may be tough to swallow, but you have to improve." : (yourscore>=5 && yourscore<=6) ? "You may have just escaped failure, but only by an inch and you can do better than this." : (yourscore>=7 && yourscore<=9) ? "You did great my buddy, keep up the language game!" : "Maximum points for maximum language skills, congrats amigo!").font(.largeTitle).foregroundColor(gs.mode==modetype.ZEN ? Color.black : Color.white)
                }else{
                    if gs.mode == modetype.CLASSIC{
                        Text(yourscore==0 ? "Come on, you have 3 lives to make things right, and somehow you get nothing? At least try." : yourscore<=3 ? "You tried your best, even though your true best is yet to be. You are 1 for 1 on each life. Practice more and you shall fail no more." : (yourscore>=4 && yourscore<=8) ? "You did on par with the average, although I expect more from you next time." : (yourscore>=9 && yourscore<=14) ? "Getting there to perfection, so keep up the winning streak will you please." : "Practice makes perfect, and you left no stones unturned. Great Job.").font(.largeTitle).foregroundColor(gs.mode==modetype.ZEN ? Color.black : Color.white)
                    }
                }
                
                Spacer()
                HStack(spacing: 40){
                    NavigationLink(destination: selectionview()){
                        primarybutton(buttontext: "Menu")
                    }
                    NavigationLink(destination: questionview(gs:gs)){
                        primarybutton(buttontext: "Play Again")
                    }
                    
                }
                Spacer()
                
                
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(gs.mode==modetype.ZEN ? Color(red: 0.984, green: 0.929, blue: 0.847) : Color(0x601A35)).edgesIgnoringSafeArea(.all).navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

struct gameoverview_Previews: PreviewProvider {
    static var previews: some View {
        gameoverview(gs:gamestate(), yourscore: 8)
    }
}
