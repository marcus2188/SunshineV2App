//
//  progressbar.swift
//  SunshineV2App
//
//  Created by Ksk I on 19/5/22.
//

import SwiftUI

struct progressbar: View {
    var progress: CGFloat
    var desiredColor: Color
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle().frame(maxWidth: 350, maxHeight: 4).foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.564, opacity: 0.327)).cornerRadius(10.0)
            Rectangle().frame(width: progress, height: 4).foregroundColor(desiredColor).cornerRadius(10.0)
        }
    }
}

struct progressbar_Previews: PreviewProvider {
    static var previews: some View {
        progressbar(progress: 60, desiredColor: Color.red)
    }
}
