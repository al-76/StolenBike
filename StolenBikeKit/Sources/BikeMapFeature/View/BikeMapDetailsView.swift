//
//  BikeMapDetailsView.swift
//  
//
//  Created by Vyacheslav Konopkin on 21.03.2023.
//

import ComposableArchitecture
import SwiftUI

import BikeClient
import Utils

struct BikeMapDetailsView: View {
    let id: Int
    let store: StoreOf<BikeMapDetails>

    private let titlePadding = 4.0

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    switch viewStore.details {
                    case .loading:
                        ProgressView("Fetch details 🚲...")

                    case let .failure(error):
                        ErrorView(title: "Error",
                                  error: error.error) {
                            viewStore.send(.fetch(id))
                        }

                    case let .success(bikeDetails):
                        viewDetailsFirst(bikeDetails)
                        BikeGalleryView(images: bikeDetails.publicImages)
                        viewDetailsSecond(bikeDetails)

                        if let stolenRecord = bikeDetails.stolenRecord {
                            view(stolenRecord: stolenRecord)
                        }

                        if let url = URL(string: "https://bikeindex.org/bikes/\(id)") {
                            Link("Visit bikeindex.org", destination: url)
                                .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                viewStore.send(.fetch(id))
            }
        }
    }

    private func view(label: String, text: String) -> some View {
        HStack(alignment: .top) {
            Text(label).bold()
            Text(text).textSelection(.enabled)
        }
        .font(.subheadline)
    }

    @ViewBuilder
    private func viewDetailsFirst(_ details: BikeDetails) -> some View {
        if let status = details.status, !status.isEmpty {
            Group {
                if details.stolen ?? false {
                    Text(status.uppercased())
                        .foregroundColor(.red)
                } else {
                    Text(status.uppercased())
                        .foregroundColor(.green)
                }
            }
            .font(.headline)
        }

        if let title = details.title, !title.isEmpty {
            Text(title)
                .font(.title2)
                .padding([.bottom], titlePadding)
        }

        if let date = details.dateStolen,
           let location = details.stolenLocation {
            view(label: "Stolen",
                 text: date.formatted(date: .abbreviated,
                                      time: .shortened))
            view(label: "from", text: location)
        }
    }

    @ViewBuilder
    private func viewDetailsSecond(_ details: BikeDetails) -> some View {
        if let serial = details.serial, !serial.isEmpty {
            view(label: "Serial:", text: serial)
        }
        if let extraRegistrationNumber = details.extraRegistrationNumber,
           !extraRegistrationNumber.isEmpty {
            view(label: "Other serial:",
                 text: extraRegistrationNumber)
        }
        if let manufacturerName = details.manufacturerName,
           !manufacturerName.isEmpty {
            view(label: "Manufacturer:", text: manufacturerName)
        }
        if let frameModel = details.frameModel,
           !frameModel.isEmpty {
            view(label: "Model:", text: frameModel)
        }
        if let frameColors = details.frameColors,
           !frameColors.isEmpty {
            view(label: "Primary colors:",
                 text: frameColors.joined(separator: ", "))
        }
        if let frameSize = details.frameSize,
           !frameSize.isEmpty {
            view(label: "Frame size:",
                 text: frameSize)
        }
        if let frameMaterialSlug = details.frameMaterialSlug,
           !frameMaterialSlug.isEmpty {
            view(label: "Frame material:",
                 text: frameMaterialSlug)
        }

        if let paintDescription = details.paintDescription,
           !paintDescription.isEmpty {
            Text("Distinguishing features").font(.title2)
            Text(paintDescription)
                .font(.subheadline)
        }
    }

    @ViewBuilder
    private func view(stolenRecord: BikeStolenRecord) -> some View {
        Text("Theft details")
            .font(.title2)
            .padding([.top, .bottom], titlePadding)
        if let location = stolenRecord.location,
           !location.isEmpty {
            view(label: "Location:",
                 text: location)
        }
        if let dateStolen = stolenRecord.dateStolen {
            view(label: "Stolen at:",
                 text: dateStolen.formatted(date: .abbreviated,
                                            time: .shortened))
        }
        if let policeReportNumber = stolenRecord.policeReportNumber,
           !policeReportNumber.isEmpty {
            view(label: "Police report #:",
                 text: policeReportNumber)
        }
        if let policeReportDepartment = stolenRecord.policeReportDepartment,
           !policeReportDepartment.isEmpty {
            view(label: "Department & city:",
                 text: policeReportDepartment)
        }
    }
}

struct BikeMapDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapDetailsView(id: BikeDetails.stub.id,
                           store: .init(
                            initialState: .init(),
                            reducer: BikeMapDetails()
                           ))
    }
}
