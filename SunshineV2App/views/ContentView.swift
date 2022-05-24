//
//  ContentView.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack(spacing: 40){
                VStack(spacing: 20){
                    Image("sunicon").shadowedformattedimage().frame(width: 300.0, height: 300.0, alignment: .center)
                    Text("Sunshine 2").screenmaintitle()
                    Text("Languages are universal, just like Sunshines").screensubtitle()
                    NavigationLink(destination: selectionview(gs: gamestate())){
                        primarybutton(buttontext: "PLAY")
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(red: 0.984, green: 0.929, blue: 0.847)).edgesIgnoringSafeArea(.all).navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
