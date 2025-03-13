//
//  menu.swift
//  rsvp_test
//
//  Created by 小松昴 on 2025/01/30.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("メニュー")
                .font(.title)
                .padding(.top, 50)
            
            Button(action: {
                // メニューの項目をタップしたときの処理
            }) {
                HStack {
                    Image(systemName: "house.fill")
                    Text("ホーム")
                }
                .padding()
            }

            Button(action: {
                // メニューの項目をタップしたときの処理
            }) {
                HStack {
                    Image(systemName: "gear")
                    Text("設定")
                }
                .padding()
            }

            Spacer()
        }
        .frame(width: 250) // メニューの幅
        .background(Color(.systemGray6)) // メニューの背景色
        .edgesIgnoringSafeArea(.all)
    }
}
