//
//  AnimalFilterForm.swift
//  BeMyFamily
//
//  Created by Gucci on 4/13/24.
//

import SwiftUI

struct AnimalFilterForm: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var reducer: FeedListReducer
    @EnvironmentObject var filterReducer: FilterReducer
    @EnvironmentObject var provinceReducer: ProvinceReducer
    @State private var applyFilter = true

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("검색 일자")) {
                    DatePicker("시작일", selection: $filterReducer.beginDate,
                               in: ...filterReducer.endDate.addingTimeInterval(UIConstants.Date.aDayBefore),
                               displayedComponents: .date)
                    DatePicker("종료일", selection: $filterReducer.endDate,
                               in: ...Date(),
                               displayedComponents: .date)
                }

                Section("어떤 종을 보고 싶으신가요?") {
                    Picker("축종", selection: $filterReducer.upkind) {
                        Text(UIConstants.FilterForm.showAll)
                            .tag(nil as Upkind?)

                        ForEach(Upkind.allCases, id: \.self) { upkind in
                            Text(upkind.text)
                                .tag(upkind as Upkind?)
                        }
                    }

                    if let upkind = filterReducer.upkind {
                        Picker("품종", selection: $filterReducer.kind) {
                            let kinds = provinceReducer.kind[upkind, default: []]
                            Text(UIConstants.FilterForm.showAll)
                                .tag(nil as Kind?)

                            ForEach(kinds, id: \.self) { eachKind in
                                Text(eachKind.name)
                                    .tag(eachKind as Kind?)
                            }
                        }
                    }
                }

                Section("지역을 골라주세요") {
                    Picker("시도", selection: $filterReducer.sido) {
                        Text(UIConstants.FilterForm.showAll)
                            .tag(nil as Sido?)

                        ForEach(provinceReducer.sido, id: \.self) { eachSido in
                            Text(eachSido.name)
                                .tag(eachSido as Sido?)
                        }
                    }
                    .onChange(of: filterReducer.sido) { _, _ in
                        filterReducer.sigungu = nil
                    }

                    if let sido = filterReducer.sido {
                        Picker("시군구", selection: $filterReducer.sigungu) {
                            let sigungus = provinceReducer.province[sido, default: []]
                            Text(UIConstants.FilterForm.showAll)
                                .tag(nil as Sigungu?)

                            ForEach(sigungus, id: \.self) { eachSigungu in
                                if let sigunguName = eachSigungu.name {
                                    Text(sigunguName)
                                        .tag(eachSigungu as Sigungu?)
                                }
                            }
                        }
                        .onChange(of: filterReducer.sigungu) { _, _ in
                            filterReducer.shelter = nil
                        }
                    }
                }

                if filterReducer.sido != nil, let sigungu = filterReducer.sigungu {
                    Section("보호소를 선택하세요.") {
                        Picker("보호소", selection: $filterReducer.shelter) {
                            Text(UIConstants.FilterForm.showAll)
                                .tag(nil as Shelter?)

                            let shelter = provinceReducer.shelter[sigungu, default: []]
                            ForEach(shelter, id: \.self) { eachShelter in
                                Text(eachShelter.name)
                                    .tag(eachShelter as Shelter?)
                            }
                        }
                    }
                }

                Section("현재 어떤 상태인가요?") {
                    Picker("처리 상태", selection: $filterReducer.state) {
                        ForEach(ProcessState.allCases, id: \.self) { process in
                            Text(process.text)
                        }
                    }
                }

                Section("중성화 여부") {
                    Picker("중성화 여부", selection: $filterReducer.neutral) {
                        Text(UIConstants.FilterForm.showAll)
                            .tag(nil as Neutralization?)

                        ForEach(Neutralization.allCases, id: \.self) { neutralization in
                            Text(neutralization.text)
                                .tag(neutralization as Neutralization?)
                        }
                    }
                }

                Button {
                    reducer.setMenu(.feed)
                    filterReducer.reset()
                    Task {
                        let sleepTimeNanoSec: UInt64 = 500 * 1_000_000
                        try? await Task.sleep(nanoseconds: sleepTimeNanoSec)

                        await MainActor.run { dismiss() }
                    }
                } label: {
                    Label {
                        Text("필터 초기화")
                    } icon: {
                        Image(systemName: UIConstants.Image.reset)
                    }
                }
            }
            .navigationTitle(UIConstants.FilterForm.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await fetchAnimalsWithFilter()
                        }
                        reducer.setMenu(.filter)
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        reducer.setMenu(.feed)
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

extension AnimalFilterForm {
    func fetchAnimalsWithFilter() async {
        let filter = filterReducer.makeFilter()
        await reducer.fetchAnimalsIfCan(filter)
    }
}

#Preview {
    @StateObject var reducer = FeedListReducer()
    @StateObject var filterReducer = FilterReducer()
    @StateObject var provinceReducer = ProvinceReducer()

    return NavigationStack {
        AnimalFilterForm()
            .environmentObject(reducer)
            .environmentObject(filterReducer)
            .environmentObject(provinceReducer)
    }
}
