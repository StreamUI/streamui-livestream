//
//  File.swift
//
//
//  Created by Jordan Howlett on 6/29/24.
//

import Foundation
import LinkPresentation
import Observation
import SwiftUI
import UniformTypeIdentifiers

public struct LinkPreview: View {
    let url: URL?

    @State private var metaData: LPLinkMetadata? = nil

    var backgroundColor: Color = .init(.gray)
    var primaryFontColor: Color = .primary
    var secondaryFontColor: Color = .secondary
    var titleLineLimit: Int = 3
    var type: LinkPreviewType = .auto

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        if let url = url {
            if let metaData = metaData {
                LinkPreviewDesign(metaData: metaData, type: type, backgroundColor: backgroundColor, primaryFontColor: primaryFontColor, secondaryFontColor: secondaryFontColor, titleLineLimit: titleLineLimit)
                    .animation(.spring(), value: metaData)
            } else {
                HStack(spacing: 10) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: secondaryFontColor))

                    Text(url.host ?? "")
                        .font(.caption)
                        .foregroundColor(primaryFontColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .foregroundColor(backgroundColor)
                )
                .onAppear {
                    getMetaData(url: url)
                }
            }
        }
    }

    func getMetaData(url: URL) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { meta, _ in
            guard let meta = meta else { return }
            withAnimation(.spring()) {
                self.metaData = meta
            }
        }
    }
}

public enum LinkPreviewType {
    case large
    case auto
}

struct LinkPreviewDesign: View {
    let metaData: LPLinkMetadata
    let type: LinkPreviewType

    @State private var image: NSImage? = nil
    @State private var icon: NSImage? = nil
    @State private var isPresented: Bool = false

    private let backgroundColor: Color
    private let primaryFontColor: Color
    private let secondaryFontColor: Color
    private let titleLineLimit: Int

    init(metaData: LPLinkMetadata, type: LinkPreviewType = .auto, backgroundColor: Color, primaryFontColor: Color, secondaryFontColor: Color, titleLineLimit: Int) {
        self.metaData = metaData
        self.type = type
        self.backgroundColor = backgroundColor
        self.primaryFontColor = primaryFontColor
        self.secondaryFontColor = secondaryFontColor
        self.titleLineLimit = titleLineLimit
    }

    var body: some View {
        Group {
            switch type {
            case .large:
                largeType
            case .auto:
                largeType
            }
        }
        .onAppear {
            getIcon()
            getImage()
        }
    }

    @ViewBuilder
    var largeType: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let img = image {
                ZStack(alignment: .bottomTrailing) {
                    Image(nsImage: img)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
//                        .position(x: (NSScreen.main?.frame.width ?? 0) / 2, y: 75)

                    if let icon = icon {
                        Image(nsImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32, alignment: .center)
                            .cornerRadius(6)
                            .padding(.all, 8)
                    }
                }
            }
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    if let title = metaData.title {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(primaryFontColor)
                            .lineLimit(titleLineLimit)
                            .padding(.bottom, image == nil ? 0 : 4)
                    }

                    if let url = metaData.url?.host {
                        Text("\(url)")
                            .foregroundColor(secondaryFontColor)
                            .font(.footnote)
                    }
                }

                if image != nil {
                    Spacer()
                } else {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .resizable()
                        .foregroundColor(secondaryFontColor)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Rectangle()
                    .foregroundColor(backgroundColor)
            )
        }
        .cornerRadius(12)
    }

    func getImage() {
        let IMAGE_TYPE = kUTTypeImage as String
        metaData.imageProvider?.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier, completionHandler: { url, imageProviderError in
            print("LOADING IMAGE", url, imageProviderError)
            if imageProviderError != nil {}
            guard let data = url?.path else { return }
            print("data", data)
            self.image = NSImage(contentsOfFile: data)
        })
    }

    func getIcon() {
        let IMAGE_TYPE = kUTTypeImage as String
        metaData.iconProvider?.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier, completionHandler: { url, imageProviderError in
            if imageProviderError != nil {}
            guard let data = url?.path else { return }
            self.icon = NSImage(contentsOfFile: data)
        })
    }
}
