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
    @State private var beginDate = Date.now.addingTimeInterval(-(86400*3)) // 3일 전
    @State private var endDate = Date()
    @State private var upkind = Upkind.dog
    @State private var kind = Kind.example
    @State private var sido = Sido.example
    @State private var sigungu = Sigungu.example
    @State private var shelter = Shelter.example
    @State private var state = ProcessState.all
    @State private var neutral = Neutralization.all

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("검색 일자")) {
                    // TODO: - 오늘 날짜 다음에는 선택 못하게 막기
                    DatePicker("시작일", selection: $beginDate, displayedComponents: .date)
                    DatePicker("종료일", selection: $endDate, displayedComponents: .date)
                }

                Section("어떤 \(upkind.text)를 보고 싶으신가요?") {
                    Picker("축종", selection: $upkind) { // TODO: - 축종 전체를 보고 싶으면 어떻게 해야할까?
                        ForEach(Upkind.allCases, id: \.self) { upkind in
                            Text(upkind.text)
                        }
                    }

                    Picker("품종", selection: $kind) {
                        let kinds = reducer.kind[upkind, default: []]
                        ForEach(kinds, id: \.self) { eachKind in
                            Text(eachKind.name)
                        }
                    }
                }

                Section("지역을 골라주세요") {
                    // TODO: - 시도, 시군구, 차례대로 보호소가 열리게끔 할 수 있나?
                    // TODO: - 시도가 너무 늦게 열림...
                    Picker("시도", selection: $sido) {    // TODO: - 시도 전체를 보고 싶으면 어떻게 해야할까?
                        ForEach(reducer.sido, id: \.self) { eachSido in
                            Text(eachSido.name)
                                .foregroundStyle(.primary)
                        }
                    }
                    .onChange(of: sido) { _, newSido in
                        if let firstSigugn = reducer.province[newSido, default: []].first {
                            sigungu = firstSigugn
                        }
                    }

                    Picker("시군구", selection: $sigungu) {
                        let sigungus = reducer.province[sido, default: []]
                        ForEach(sigungus, id: \.self) { eachSigungu in
                            Text(eachSigungu.name)
                                .foregroundStyle(.primary)
                        }
                    }
                    .onChange(of: sigungu) { _, newSigungu in
                        if let firstShelter = reducer.shelter[newSigungu, default: []].first {
                            shelter = firstShelter
                        }
                    }
                }

                Section("보호소를 선택하세요.") {
                    Picker("보호소", selection: $shelter) {
                        let shelter = reducer.shelter[sigungu, default: []]
                        ForEach(shelter, id: \.self) { eachShelter in
                            Text(eachShelter.name)
                                .foregroundStyle(.primary)
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
                        ForEach(Neutralization.allCases, id: \.self) { neutralization in
                            Text(neutralization.text)
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
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
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
                                  upkind: upkind.id,
                                  kind: kind.id,
                                  sido: sido.id,
                                  sigungu: sigungu.id,
                                  shelterNumber: shelter.id,
                                  processState: state.id,
                                  neutralizationState: neutral.id)
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
