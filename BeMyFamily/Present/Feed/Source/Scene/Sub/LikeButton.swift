//
//  FavoriteButtonView.swift
//  BeMyFamily
//
//  Created by Gucci on 4/30/24.
//

import SwiftUI

struct FavoriteButtonView: View {
    let animal: Animal
    var favoriteToggled: (Animal) -> Void

    var body: some View {
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
    }
}

#Preview {
    let animal = ModelData().animals.items

    return FavoriteButtonView(animal: animal[0]) { animal in
        print(animal.specialMark)
    }
}
