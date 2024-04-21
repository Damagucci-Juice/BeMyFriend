//
//  FeedItemView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//
import NukeUI
import SwiftUI

struct FeedItemView: View {
    let animal: Animal
    var favoriteToggled: (Animal) -> Void

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                Text(animal.specialMark)
                    .font(.animalName)
                    .lineLimit(1)
                Spacer()
                Text(animal.processState)
                    .font(.processState)
            }
            
            LazyImage(url: URL(string: animal.animalPhotoURL)) { state in
                let roundedRectangle = RoundedRectangle(cornerRadius: UIConstants.Radius.mainImagePlaceholder)
                let hasError = state.error != nil

                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIConstants.Frame.screenWidthWithPadding,
                               height: UIConstants.Frame.feedImageHeight)
                        .clipShape(roundedRectangle)
                }
                if state.isLoading || hasError {
                    roundedRectangle
                        .stroke(.windowBackground, lineWidth: UIConstants.Line.feedItem)
                        .fill(.gray)
                        .frame(width: UIConstants.Frame.screenWidthWithPadding,
                               height: UIConstants.Frame.feedImageHeight)
                        .overlay {
                            if hasError {
                                Text(Constants.Error.responseHadError)
                                    .font(.processState)
                            }
                        }
                }
            }

            HStack {
                Spacer()

                // favortie button
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

                // share button
                Button {

                } label: {
                    Image(systemName: UIConstants.Image.share)
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.white)
                        .frame(width: UIConstants.Frame.shareHeight,
                               height: UIConstants.Frame.shareHeight)
                }
            }
        }
        .padding(.horizontal, UIConstants.Padding.feedImemViewHorizontal)
    }
}

#Preview {
    @StateObject var reducer = FeedListReducer()
    let animals = ModelData().animals.items

    return ScrollView {
        VStack(spacing: UIConstants.Spacing.interFeedItem) {
            FeedItemView(animal: animals[0]) { target in
                reducer.updateFavorite(target)
            }
            FeedItemView(animal: animals[1]) { target in
                reducer.updateFavorite(target)
            }
        }
        .environmentObject(reducer)
    }
    .preferredColorScheme(.dark)
}
