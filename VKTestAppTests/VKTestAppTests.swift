//
//  VKTestAppTests.swift
//  VKTestAppTests
//
//  Created by Илья Востров on 30.11.2024.
//

import XCTest
import RealmSwift
@testable import VKTestApp

final class VKTestAppTests: XCTestCase {
    
    private var storage: RepositoryStorage!
    private var viewModel: RepositoryListViewModel!
    private var realm: Realm!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Настройка in-memory базы данных Realm
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        realm = try Realm(configuration: config)
        storage = RepositoryStorage(realm: realm) // Передаем тестовый Realm

        // Инициализация ViewModel на главном потоке
        Task { @MainActor in
            viewModel = RepositoryListViewModel(storage: storage)
        }
    }

    override func tearDownWithError() throws {
        realm.invalidate() // Освобождаем Realm
        realm = nil
        storage = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    // Тест сохранения и извлечения репозиториев
    func testSaveAndFetchRepositories() throws {
        // Создаем тестовые данные
        let repositories = [
            Repository(id: 1, name: "Repo1", description: "Description1", stars: 50, owner: Owner(avatarURL: "url1")),
            Repository(id: 2, name: "Repo2", description: "Description2", stars: 30, owner: Owner(avatarURL: "url2"))
        ]
        
        // Сохраняем репозитории в хранилище
        storage.save(repositories)
        
        // Извлекаем данные из хранилища
        let fetchedRepositories = storage.fetch()
        
        XCTAssertEqual(fetchedRepositories.count, 2)
        XCTAssertEqual(fetchedRepositories[0].id, 1)
        XCTAssertEqual(fetchedRepositories[0].name, "Repo1")
        XCTAssertEqual(fetchedRepositories[0].stars, 50)
    }
    
    // Тест удаления репозитория
    func testDeleteRepository() throws {
        // Создаем тестовые данные
        let repository = Repository(id: 1, name: "Repo1", description: "Description1", stars: 50, owner: Owner(avatarURL: "url1"))
        storage.save([repository])
        
        // Удаляем репозиторий
        storage.delete(repository)
        
        // Проверяем, что данные удалены
        let fetchedRepositories = storage.fetch()
        XCTAssertTrue(fetchedRepositories.isEmpty)
    }
    
    // Тест ViewModel: загрузка данных из хранилища
    @MainActor func testViewModelFetchingData() throws {
        // Создаем тестовые данные
        let repositories = [
            Repository(id: 1, name: "Repo1", description: "Description1", stars: 50, owner: Owner(avatarURL: "url1")),
            Repository(id: 2, name: "Repo2", description: "Description2", stars: 30, owner: Owner(avatarURL: "url2"))
        ]
        
        // Сохраняем данные в хранилище
        storage.save(repositories)
        
        // Загружаем данные из хранилища через ViewModel
        viewModel.fetchRepositoriesFromStorage()
        
        XCTAssertEqual(viewModel.repositories.count, 2)
        XCTAssertEqual(viewModel.repositories[0].id, 1)
        XCTAssertEqual(viewModel.repositories[1].id, 2)
    }
    
    // Тест ViewModel: сортировка репозиториев
    @MainActor func testViewModelSortingRepositories() throws {
        // Создаем тестовые данные
        let repositories = [
            Repository(id: 1, name: "Repo1", description: "Description1", stars: 50, owner: Owner(avatarURL: "url1")),
            Repository(id: 2, name: "Repo2", description: "Description2", stars: 30, owner: Owner(avatarURL: "url2")),
            Repository(id: 3, name: "Repo3", description: "Description3", stars: 100, owner: Owner(avatarURL: "url3"))
        ]
        
        // Сохраняем данные в хранилище
        storage.save(repositories)
        
        // Загружаем данные через ViewModel
        viewModel.fetchRepositoriesFromStorage()
        
        // Сортируем по убыванию количества звезд
        viewModel.sortRepositories(by: .starsDescending)
        
        XCTAssertEqual(viewModel.repositories[0].stars, 100)
        XCTAssertEqual(viewModel.repositories[1].stars, 50)
        XCTAssertEqual(viewModel.repositories[2].stars, 30)
    }
    
    // Тест ViewModel: обновление репозитория
    @MainActor func testUpdateRepository() throws {
        // Создаем тестовые данные
        let repository = Repository(id: 1, name: "Repo1", description: "Description1", stars: 50, owner: Owner(avatarURL: "url1"))
        storage.save([repository])
        
        // Обновляем репозиторий
        let updatedRepository = Repository(id: 1, name: "UpdatedRepo", description: "UpdatedDescription", stars: 100, owner: Owner(avatarURL: "url1"))
        viewModel.updateRepository(updatedRepository)
        
        // Проверяем обновленные данные
        let fetchedRepositories = storage.fetch()
        XCTAssertEqual(fetchedRepositories.count, 1)
        XCTAssertEqual(fetchedRepositories[0].name, "UpdatedRepo")
        XCTAssertEqual(fetchedRepositories[0].description, "UpdatedDescription")
        XCTAssertEqual(fetchedRepositories[0].stars, 100)
    }
}
