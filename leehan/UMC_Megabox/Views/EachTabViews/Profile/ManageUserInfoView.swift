//
//  ManageUserInfoView.swift
//  leehan
//
//  Created by 이한결 on 3/25/26.
//

import SwiftUI

struct ManageUserInfoView: View {
    @AppStorage("id") private var id = ""
    @AppStorage("name") private var name = ""
    
    var body: some View {
        VStack {
            Text("Title")
                .font(.PretendardMedium(size: 16))
                .foregroundStyle(.black)
            
            Spacer().frame(height: 60)
            
            HStack {
                Text("기본정보")
                    .font(.PretendardBold(size: 18))
                    .foregroundStyle(.black)
                Spacer()
            }.padding(.bottom, 25)
            
            HStack {
                Text("\(id)")
                    .font(.PretendardMedium(size: 18))
                    .foregroundStyle(.black)
                Spacer()
            }
            Divider()
            
            HStack {
                TextField("\(name)", text: $name)
                    .font(.PretendardMedium(size: 18))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Button( action: { self.name = name } ) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray03, lineWidth: 1)
                        .foregroundStyle(.clear)
                        .overlay(
                            Text("변경")
                                .font(.PretendardMedium(size: 10))
                                .foregroundStyle(.gray03)
                        )
                        .frame(width: 38, height: 20)
                }
            }
            
            Divider()
            
            Spacer()
        }.padding(.horizontal)
    }
}

#Preview {
    ManageUserInfoView()
}
