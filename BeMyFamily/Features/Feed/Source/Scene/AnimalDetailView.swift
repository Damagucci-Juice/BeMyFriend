//
//  AnimalDetailView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/18/24.
//

import SwiftUI
import NukeUI

struct AnimalDetailView: View {
    let animal: Animal
    var favoriteToggled: (Animal) -> Void

    var body: some View {
        ScrollView {
            VStack {
                imageSection
                Group {
                    actionButtons
                    detailSection
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("상세 정보")
        }
    }

    @MainActor
    @ViewBuilder
    private var imageSection: some View {
        LazyImage(url: URL(string: animal.animalPhotoURL)) { state in
            let roundedRectangle = RoundedRectangle(cornerRadius: UIConstants.Radius.mainImagePlaceholder)
            let hasError = state.error != nil

            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIConstants.Frame.screenWidth,
                           height: UIConstants.Frame.feedImageHeight)
//                    .clipShape(roundedRectangle)
            }
            if state.isLoading || hasError {
                roundedRectangle
                    .stroke(.windowBackground, lineWidth: UIConstants.Line.feedItem)
                    .fill(.gray)
                    .frame(width: UIConstants.Frame.screenWidth,
                           height: UIConstants.Frame.feedImageHeight)
                    .overlay {
                        if hasError {
                            Text(Constants.Error.responseHadError)
                                .font(.caption)
                        }
                    }
            }
        }
    }

    @ViewBuilder
    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                detailRow(label: "특이사항:", value: animal.specialMark)
                detailRow(label: "실종일:", value: animal.happenDt)
                detailRow(label: "발견장소:", value: animal.happenPlace)
                detailRow(label: "품종:", value: animal.kindCD)
                detailRow(label: "색:", value: animal.colorCD)
                detailRow(label: "나이:", value: animal.age)
                detailRow(label: "무게:", value: animal.weight)
                detailRow(label: "처리 상태:", value: animal.processState)
                detailRow(label: "성별:", value: animal.sexCD)
                detailRow(label: "중성화 여부:", value: animal.neuterYn)
                detailRow(label: "보호소 이름:", value: animal.careNm)
                detailRow(label: "보호소 연락처:", value: animal.careTel)
            }
        }
    }

    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .bold()
            Text(value)
            Spacer()
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        HStack {
            Spacer()
            // TODO: - 컴포넌트화 1
            Button {
                favoriteToggled(animal)
            } label: {
                Image(systemName: UIConstants.Image.heart)
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(animal.isFavorite ? .red.opacity(UIConstants.Opacity.border) : .gray)
                    .frame(width: UIConstants.Frame.heartHeight,
                           height: UIConstants.Frame.heartHeight)
                    .overlay {
                        Image(systemName: UIConstants.Image.heartWithStroke)
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(animal.isFavorite ? .pink : .white.opacity(UIConstants.Opacity.border))
                            .frame(width: UIConstants.Frame.heartBorderHeight,
                                   height: UIConstants.Frame.heartBorderHeight)
                    }
            }
            // TODO: - 컴포넌트화 2
            Button {
                // Sharing functionality or other actions can be implemented here
            } label: {
                Image(systemName: UIConstants.Image.share)
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.white)
                    .frame(width: UIConstants.Frame.shareHeight,
                           height: UIConstants.Frame.shareHeight)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    let animals = ModelData().animals.items
    @StateObject var reducer = FeedListReducer()

    return NavigationView {
        AnimalDetailView(animal: animals[0], favoriteToggled: reducer.updateFavorite)
    }
}
