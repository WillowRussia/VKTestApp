//
//  RealmStorage.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import RealmSwift

final class RepositoryStorage {
    
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    func save(_ repositories: [Repository]) {
        let objects = repositories.map { RealmRepository(from: $0) }
        try! realm.write {
            realm.add(objects, update: .modified)
        }
    }
    
    func fetch() -> [Repository] {
        let objects = realm.objects(RealmRepository.self)
        return objects.map { $0.toRepository() }
    }
    
    func delete(_ repository: Repository) {
            guard let objectToDelete = realm.object(
                ofType: RealmRepository.self,
                forPrimaryKey: repository.id
            ) else {
                print("Repository not found in storage for ID: \(repository.id)")
                return
            }

            do {
                try realm.write {
                    realm.delete(objectToDelete)
                }
            } catch {
                print("Error deleting repository: \(error.localizedDescription)")
            }
        }
    
    func deleteAll() {
        realm.deleteAll()
    }
    

}

func configureRealmMigration() {
    let config = Realm.Configuration(
        schemaVersion: 1, // Увеличьте номер версии схемы при каждом изменении модели
        migrationBlock: { _, _ in
                // Миграция
            }
    )
    
    Realm.Configuration.defaultConfiguration = config
}



