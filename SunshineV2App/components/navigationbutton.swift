//
//  navigationbutton.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import SwiftUI

struct navigationbutton: View {
    var buttontext: String
    var body: some View {
        Text(buttontext).font(.title).fontWeight(.bold).padding().border(Color.black, width: 3)
    }
}

struct navigationbutton_Previews: PreviewProvider {
    static var previews: some View {
        navigationbutton(buttontext: "hey hey")
    }
}
