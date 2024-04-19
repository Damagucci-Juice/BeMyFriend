//
//  FeedView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//
import NukeUI
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var service: FriendSearchService
    @State private var animals = [Animal]()
    @State private var filter = AnimalFilter.example
    @State private var page = 1
    var body: some View {
        ScrollView {
            VStack(spacing: UIConstants.Spacing.interFeedItem) {
                ForEach(animals) { animal in
                    FeedItemView(animal: animal)
                }
            }
        }
        .task {
            do {
                let sido = try await Actions.FetchSido(service: service).excute()
                dump(sido.results)
            } catch {
                print("Failed at fetching Sido")
                print(error.localizedDescription)
            }
        }
        .task {
            do {
                let sigungu = try await Actions.FetchSigungu(service: service).excute(6500000)
                dump(sigungu.results)
            } catch {
                print("Failed at fetching Sigungu")
                print(error.localizedDescription)
            }
        }
        .task {
            do {
                let shelter = try await Actions.FetchShelter(service: service).excute(6110000, 3220000)
                dump(shelter.results)
            } catch {
                print("Failed at fetching Shelter")
                print(error.localizedDescription)
            }
        }
        .task {
            do {
                let kind = try await Actions.FetchKind(service: service).excute(417000)
                dump(kind.results)
            } catch {
                print("Failed at fetching Kind")
                print(error.localizedDescription)
            }
        }
        .task {
            do {
                let animal = try await Actions
                    .FetchAnimal(service: service,
                                 filter: filter,
                                 page: page).excute()
                animals.append(contentsOf: animal.results)
            } catch let error {
                print("Failed at fetching Animal")
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    @StateObject var service = FriendSearchService()

    return FeedView()
        .environmentObject(service)
        .preferredColorScheme(.dark)
}
