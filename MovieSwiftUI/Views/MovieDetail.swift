//
//  MovieDetail.swift
//  MovieSwiftUI
//
//  Created by Alfian Losari on 06/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MovieDetail : View {
    
    @State var movieData: MovieItemData
    
    var movie: Movie {
        return movieData.movie
    }
    
    var body: some View {
        List {
            ZStack(alignment: .bottom) {
                PosterImage(imageData: ImageData(movieURL: movie.posterURL))
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.25)
                    .blur(radius: 5)
                    .frame(height: 80)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        if (movie.genreText != nil) {
                            Text(movie.genreText!)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        HStack {
                            Text(movie.yearText)
                                .foregroundColor(.white)
                                .font(.subheadline)
                            
                            if (movie.durationText != nil) {
                                Text(movie.durationText!)
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            
                            Text(movie.voteAveragePercentText)
                                .foregroundColor(.white)
                                .font(.subheadline)
                            
                        }
                        
                    }
                    .padding(.leading)
                    .padding(.bottom)
                    Spacer()
                }
            }
                
            .listRowInsets(EdgeInsets())
            
            
            
            VStack(alignment: .leading, spacing: 4.0) {
                
                if (movie.tagline != nil) {
                    Text(movie.tagline!)
                        
                        .foregroundColor(.primary)
                        .font(.headline)
                        .lineLimit(2)
                    
                }
                
                Text(movie.overview)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(nil)
                
                
                
            }.padding()
                .listRowInsets(EdgeInsets())
            
            
            if movie.casts != nil {
                CastRow(casts: movie.casts!.filter { $0.profilePath != nil })
                    .listRowInsets(EdgeInsets())
            }
            
            if movie.crews != nil {
                CrewRow(crews: movie.crews!.filter { $0.profilePath != nil })
                    .listRowInsets(EdgeInsets())
            }
            
            
            if movie.productionCompanies != nil {
                ProductionCompanyRow(productionCompanies: movie.productionCompanies!)
                    .listRowInsets(EdgeInsets())
            }
            
            if movie.spokenLanguages != nil {
                SpokenLanguageRow(languages: movie.spokenLanguages!)
                    .listRowInsets(EdgeInsets())
            }
            
            if movie.homepage != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Homepage")
                        .foregroundColor(.primary)
                        .font(.headline)
                    
                    
                    
                    LinkRow(name: movie.homepage!, url: movie.homepageURL)
                }
                .padding()
                .listRowInsets(EdgeInsets())
                
                
            }
            
            
            if movie.movieVideos != nil {
                
                Text("Videos")
                    .foregroundColor(.primary)
                    .font(.headline)
                    .padding()
                    .listRowInsets(EdgeInsets())
                
                ForEach(movie.movieVideos ?? [], id: \.name) { video in
                    LinkRow(name: video.name, url: video.youtubeURL)
                        .padding()
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .onAppear {
            self.movieData.loadMovie()
        }
    }
}

fileprivate struct LinkRow: View {
    
    var name: String
    var url: URL?
    @State var showLink = false
    
    var body: some View {
        Button(action: {
            self.showLink.toggle()
        }) {
            Text(name)
            .font(.caption)
            .foregroundColor(.primary)
        }
        .sheet(isPresented: self.$showLink) {
            SafariView(url: self.url!)
        }
        .edgesIgnoringSafeArea(.bottom)

    }
}

fileprivate struct CastRow: View {
    
    var casts: [MovieCast]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Casts")
                .foregroundColor(.primary)
                .font(.headline)
                .padding()
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 8) {
                    ForEach(self.casts, id: \.name) { cast in
                        VStack(spacing: 8) {
                            if cast.profileURL != nil {
                                CreditImage(imageData: ImageData(movieURL: cast.profileURL!))
                            }
                            
                            VStack(spacing: 4) {
                                Text(cast.name)
                                    .foregroundColor(.primary)
                                    .font(.caption)
                                
                                Text(cast.character)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                
                            }
                        }.padding(.trailing)
                    }
                }.padding(.leading, 16)
            }.frame(height: 165)
        }
    }
}

fileprivate struct CrewRow: View {
    
    var crews: [MovieCrew]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Crews")
                .foregroundColor(.primary)
                .font(.headline)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 8) {
                    ForEach(self.crews, id: \.name) { crew in
                        VStack(spacing: 8) {
                            if crew.profileURL != nil {
                                CreditImage(imageData: ImageData(movieURL: crew.profileURL!))
                            }
                            
                            VStack(spacing: 4) {
                                Text(crew.name)
                                    .foregroundColor(.primary)
                                    .font(.caption)
                                
                                Text(crew.job)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                
                            }
                        }.padding(.trailing)
                    }
                }.padding(.leading, 16)
            }.frame(height: 165)
        }
    }
}

fileprivate struct ProductionCompanyRow: View {
    
    var productionCompanies: [ProductionCompany]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Produced by")
                .foregroundColor(.primary)
                .font(.headline)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 8) {
                    ForEach(self.productionCompanies, id: \.name) { company in
                        VStack(spacing: 8) {
                            if company.logoURL != nil {
                                CreditImage(imageData: ImageData(movieURL: company.logoURL!))
                            } else {
                                Circle()
                                    .foregroundColor(.gray)
                                    .frame(width: 100.0, height: 100.0)
                            }
                            
                            Text(company.name)
                                .foregroundColor(.primary)
                                .font(.caption)
                            
                        }.padding(.trailing)
                    }
                }.padding(.leading, 16)
            }.frame(height: 150)
        }
    }
}

fileprivate struct SpokenLanguageRow: View {
    
    var languages: [SpokenLanguage]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Languages")
                .foregroundColor(.primary)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(self.languages, id: \.name) {
                    language in
                    Text(language.name)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
    }
}


fileprivate struct CreditImage: View {
    
    @State var imageData: ImageData
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.gray)
                .frame(width: 100.0, height: 100.0)
            
            if imageData.image != nil {
                Image(uiImage: imageData.image!)
                    .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.secondary, lineWidth: 1))
                    .frame(width: 100.0, height: 100.0)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear {
            self.imageData.downloadImage()
        }
    }
}

fileprivate struct PosterImage: View {
    
    @State var imageData: ImageData
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .aspectRatio(500/750, contentMode: .fit)
            
            if imageData.image != nil {
                Image(uiImage: imageData.image!)
                    .resizable()
                    .aspectRatio(500/750, contentMode: .fit)
            }
        }
        .onAppear {
            self.imageData.downloadImage()
        }
    }
}


#if DEBUG
struct MovieDetail_Previews : PreviewProvider {
    static var previews: some View {
        MovieDetail(movieData: MovieItemData(movieService: MovieStore.shared, movie: Movie.fake))
    }
}
#endif
