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
    @State private var beginDate = Date.now.addingTimeInterval(-(86400*10)) // 10일 전
    @State private var endDate = Date()
    @State private var upkind: Upkind?
    @State private var kind: Kind?
    @State private var sido: Sido?
    @State private var sigungu: Sigungu?
    @State private var shelter: Shelter?
    @State private var state = ProcessState.all
    @State private var neutral: Neutralization?
    @State private var applyFilter = true

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - 필터 적용 & 해제하는 토글 스위치
                Toggle("filter 적용", isOn: $applyFilter)
                    .onChange(of: applyFilter) { _, newValue in
                        let nextMenu: FriendMenu = newValue ? .filter : .feed
                        reducer.setMenu(nextMenu)
                        if !newValue {
                            dismiss()
                        }
                    }

                Section(header: Text("검색 일자")) {
                    // TODO: - 오늘 날짜 다음에는 선택 못하게 막기
                    DatePicker("시작일", selection: $beginDate, displayedComponents: .date)
                    DatePicker("종료일", selection: $endDate, displayedComponents: .date)
                }

                Section("어떤 종을 보고 싶으신가요?") {
                    Picker("축종", selection: $upkind) {
                        Text("Empty")
                            .tag(nil as Upkind?)

                        ForEach(Upkind.allCases, id: \.self) { upkind in
                            Text(upkind.text)
                                .tag(upkind as Upkind?)
                        }
                    }

                    if let upkind {
                        Picker("품종", selection: $kind) {
                            let kinds = reducer.kind[upkind, default: []]
                            Text("Empty")
                                .tag(nil as Kind?)

                            ForEach(kinds, id: \.self) { eachKind in
                                Text(eachKind.name)
                                    .tag(eachKind as Kind?)
                            }
                        }
                    }
                }

                Section("지역을 골라주세요") {
                    Picker("시도", selection: $sido) {
                        Text("Empty")
                            .tag(nil as Sido?)

                        ForEach(reducer.sido, id: \.self) { eachSido in
                            Text(eachSido.name)
                                .tag(eachSido as Sido?)
                        }
                    }
                    .onChange(of: sido) { _, _ in
                        sigungu = nil
                    }

                    if let sido {
                        Picker("시군구", selection: $sigungu) {
                            let sigungus = reducer.province[sido, default: []]
                            Text("Empty")
                                .tag(nil as Sigungu?)

                            ForEach(sigungus, id: \.self) { eachSigungu in
                                if let sigunguName = eachSigungu.name {
                                    Text(sigunguName)
                                        .tag(eachSigungu as Sigungu?)
                                }
                            }
                        }
                        .onChange(of: sigungu) { _, _ in
                            shelter = nil
                        }
                    }
                }

                if sido != nil, let sigungu {
                    Section("보호소를 선택하세요.") {
                        Picker("보호소", selection: $shelter) {
                            Text("Emtpy")
                                .tag(nil as Shelter?)

                            let shelter = reducer.shelter[sigungu, default: []]
                            ForEach(shelter, id: \.self) { eachShelter in
                                Text(eachShelter.name)
                                    .tag(eachShelter as Shelter?)
                            }
                        }
                    }
                }

                Section("현재 어떤 상태인가요?") {
                    Picker("처리 상태", selection: $state) {
                        ForEach(ProcessState.allCases, id: \.self) { process in
                            Text(process.text)
                        }
                    }
                }

                Section("중성화 여부") {
                    Picker("중성화 여부", selection: $neutral) {
                        Text("전체")
                            .tag(nil as Neutralization?)

                        ForEach(Neutralization.allCases, id: \.self) { neutralization in
                            Text(neutralization.text)
                                .tag(neutralization as Neutralization?)
                        }
                    }
                }
            }
            .navigationTitle("Filter Animals")
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
        let filter = AnimalFilter(beginDate: beginDate,
                                  endDate: endDate,
                                  upkind: upkind?.id,
                                  kind: kind?.id,
                                  sido: sido?.id,
                                  sigungu: sigungu?.id,
                                  shelterNumber: shelter?.id,
                                  processState: state.id,
                                  neutralizationState: neutral?.id)
        await reducer.fetchAnimals(filter)
    }
}

#Preview {
    @StateObject var reducer = FeedListReducer()

    return NavigationStack {
        AnimalFilterForm()
            .environmentObject(reducer)
    }
}
