//
//  RepositoryListView.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel = RepositoryListViewModel()
    @State private var selectedSortOption: SortOption = .starsAscending
    @State private var selectedRepository: Repository? = nil
    @State private var isEditSheetPresented = false
    @State private var refreshID = UUID()

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.displayName).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(viewModel.repositories, id: \.id) { repository in
                        RepositoryCell(repository: repository)
                            .onTapGesture {
                                selectedRepository = repository
                                isEditSheetPresented = true
                            }
                            .onAppear {
                                if repository == viewModel.repositories.last {
                                    viewModel.fetchRepositories()
                                }
                            }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteRepository(at: indexSet)
                    }
                    
                    if viewModel.isLoading {
                        LoadingView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .id(refreshID)

            }
            .navigationTitle("Repositories")
            .onChange(of: selectedSortOption) { newValue in
                viewModel.sortRepositories(by: newValue)
            }
            .sheet(isPresented: $isEditSheetPresented,
                   onDismiss: {
                selectedRepository = nil
            }) {
                if let repository = selectedRepository {
                    RepositoryEditView(
                        repository: repository,
                        onSave: { updatedRepository in
                            viewModel.updateRepository(updatedRepository)
                            refreshList()
                        },
                        onClose: {
                            isEditSheetPresented = false
                        }
                    )
                }
            }
            .id(selectedRepository?.id)

        }
    }
    private func refreshList() {
        refreshID = UUID() 
    }
}

