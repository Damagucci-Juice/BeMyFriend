//
//  FeedItemView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/9/24.
//
import NukeUI
import SkeletonUI
import SwiftUI

struct FeedItemView: View {
    @Environment(\.displayScale) var displayScale
    @State private var loadedImage: Image?
    @State private var renderedImage: Image?
    let animal: Animal
    var favoriteToggled: (Animal) -> Void
    private var hasImage: Bool { loadedImage != nil ? false : true }

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
                        .onAppear { self.loadedImage = image }
                }
                if state.isLoading || hasError {
                    roundedRectangle
                        .stroke(.windowBackground, lineWidth: UIConstants.Line.feedItem)
                        .skeleton(with: hasImage,
                                  animation: .linear(),
                                  appearance: .solid(color: .gray, background: .clear),
                                  shape: .rounded(.radius(UIConstants.Radius.mainImagePlaceholder, style: .circular)))
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
            .onChange(of: loadedImage) { _, newValue in
                guard let newValue else { return }
                Task {
                    self.renderedImage = render(object: animal, img: newValue, displayScale: displayScale)
                }
            }

            HStack {
                Spacer()

                // favortie button
                // TODO: - 컴포넌트화 3
                Button {
                    favoriteToggled(animal)
                } label: {
                    Image(systemName: UIConstants.Image.heart)
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(animal.isFavorite ? .red.opacity(UIConstants.Opacity.border) : .secondary)
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
                // TODO: - 컴포넌트화 4
                ShareLink(item: renderedImage ?? Image(.bemyfamilyIconTrans),
                          preview: SharePreview(Text(UIConstants.App.shareMessage),
                                                image: Image(.bemyfamilyIconTrans)))
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .symbolVariant(.fill)
                .tint(.secondary)
                .disabled(hasImage)
            }
        }
        .padding(.horizontal, UIConstants.Padding.feedImemViewHorizontal)
    }
}

extension FeedItemView: Sharable { }

#Preview {
    @StateObject var reducer = FeedListReducer()
    let animals = ModelData().animals.items

    return ScrollView {
        VStack(spacing: UIConstants.Spacing.interFeedItem) {
            FeedItemView(animal: animals[0], favoriteToggled: reducer.updateFavorite)
            FeedItemView(animal: animals[1], favoriteToggled: reducer.updateFavorite)
        }
        .environmentObject(reducer)
    }
    .preferredColorScheme(.dark)
}
