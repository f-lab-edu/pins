//
//  LoginView.swift
//  pins
//
//  Created by 주동석 on 2023/11/02.
//

import SwiftUI

struct LoginView: View {
    var appleLoginAction: () -> Void
    var googleLoginAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Image(.pinsIcon) // 로고 이미지
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Image(.pinsTitle) // 타이틀 이미지
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 50)
                .padding([.top], 30)

            Spacer()

            Button(action: {
                googleLoginAction()
            }, label: {
                Image(.googleLogin) // 구글 로그인 버튼 이미지
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            })
            .padding(.bottom, 10)

            Button(action: {
                appleLoginAction()
            }, label: {
                Image(.appleLogin) // 구글 로그인 버튼 이미지
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            })
            .padding(.bottom, 30)
        }
        .padding()
    }
}
