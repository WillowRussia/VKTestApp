//
//  RepositoryEditView.swift
//  VKTestApp
//
//  Created by Илья Востров on 04.12.2024.
//
import SwiftUI



struct RepositoryEditView: View {
    @State private var name: String
    @State private var description: String?
    @State private var stars: Int

    let repository: Repository
    let onSave: (Repository) -> Void
    let onClose: () -> Void 

    init(repository: Repository, onSave: @escaping (Repository) -> Void, onClose: @escaping () -> Void) {
        self.repository = repository
        _name = State(initialValue: repository.name)
        _description = State(initialValue: repository.description)
        _stars = State(initialValue: repository.stars)
        self.onSave = onSave
        self.onClose = onClose
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: Binding(
                        get: { description ?? "" },
                        set: { description = $0.isEmpty ? nil : $0 }
                    ))
                    Stepper("Stars: \(stars)", value: $stars, in: 0...Int.max)
                }
            }
            .navigationTitle("Edit Repository")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updatedRepository = Repository(
                            id: repository.id,
                            name: name,
                            description: description,
                            stars: stars,
                            owner: repository.owner
                        )
                        onSave(updatedRepository)
                        onClose()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onClose()
                    }
                }
            }
        }
    }
}

