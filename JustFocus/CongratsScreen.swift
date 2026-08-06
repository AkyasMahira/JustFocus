//
//  ContentView.swift
//  justfocus4
//
//  Created by Mac on 04/08/26.
//

import SwiftUI

struct CongratsScreen: View {
    var body: some View {
        NavigationStack{
            
            VStack{
                
                Text("Selamat!")
                    .font(.system(size:40))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: "flame")
                        .resizable()
                        .frame(width: 100, height: 120)
                        .imageScale(.large)
                        .foregroundStyle(.orange)
                    
                    VStack{
                        Text("12")
                            .font(.system(size:50))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Streak!")
                            .font(.system(size:25))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                    }
                }
                .padding()
                Text("Konsistensi yang hebat! anda")
                Text(" sedang membangun kebiasaan")
                Text(" yang luar biasa.")
            }
            .toolbar {
                Button {
                } label: {Image(systemName: "xmark")
                    
                }
                .buttonStyle(.glass)
            }
        }
    }
}


#Preview {
    CongratsScreen()
}
