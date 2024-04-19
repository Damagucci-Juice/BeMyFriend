//
//  FeedItemView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//
import NukeUI
import SwiftUI

struct FeedItemView: View {
    @State private var isLiked = false
    let animal: Animal

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

                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIConstants.Frame.screenWidthWithPadding,
                               height: UIConstants.Frame.feedImageHeight)
                        .clipShape(roundedRectangle)
                }
                if state.isLoading {
                    roundedRectangle
                        .stroke(.windowBackground, lineWidth: UIConstants.Line.feedItem)
                        .fill(.gray)
                        .frame(width: UIConstants.Frame.screenWidthWithPadding,
                               height: UIConstants.Frame.feedImageHeight)
                }
            }

            HStack {
                Spacer()

                // favortie button
                Button {
                    isLiked.toggle()
                } label: {
                    Image(systemName: UIConstants.Image.heart)
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(isLiked ? .red.opacity(UIConstants.Opacity.border) : .gray)
                        .frame(width: UIConstants.Frame.heartHeight,
                               height: UIConstants.Frame.heartHeight)
                        .overlay {
                            Image(systemName: UIConstants.Image.heartWithStroke)
                                .resizable()
                                .scaledToFill()
                                .foregroundStyle(isLiked ? .pink : .white.opacity(UIConstants.Opacity.border))
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
    let animals = ModelData().animals.items

    return ScrollView {
        VStack(spacing: UIConstants.Spacing.interFeedItem) {
            FeedItemView(animal: animals[0])
            FeedItemView(animal: animals[1])
        }
    }
    .preferredColorScheme(.dark)
}
