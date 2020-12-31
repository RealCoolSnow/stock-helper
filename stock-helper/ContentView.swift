//
//  ContentView.swift
//  stock-helper
//
//  Created by CoolSnow on 2020/12/31.
//

import SwiftUI

struct ContentView: View {
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var body: some View {
        VStack {
            Spacer()
            AppTabView()
            Text("v \(appVersion)")
                .foregroundColor(Color.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AppTabView: View {
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            List{
                
            }.tabItem { Text("股票") }.tag(1)
            Text("设置").tabItem { Text("设置") }.tag(2)
        }
    }
}
