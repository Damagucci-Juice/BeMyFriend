//
//  FeedView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//
import Combine
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var service: FriendSearchService
    @State private var animals = [Animal]()
    @State private var filter = AnimalFilter.example
    @State private var page = 1
    var body: some View {
        ScrollView {
            ForEach(animals) { animal in
                AsyncImage(url: URL(string: animal.animalPhotoURL))
            }
        }
        .task {
            do {
                let paginatedAnimal = try await Actions.FetchAnimal(filter: filter, page: page).excute(service)
                animals.append(contentsOf: paginatedAnimal.results)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    @StateObject var service = FriendSearchService()
    
    return FeedView()
        .environmentObject(service)
}
