
import Foundation


@MainActor
class RepositoryListViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    private var page = 1
    private var hasMoreData = true
    
    private let perPage = 20
    private let apiClient: APIClient
    private let storage: RepositoryStorage
        

        init(storage: RepositoryStorage = RepositoryStorage(), apiClient: APIClient = APIClient()) {
            self.storage = storage
            self.apiClient = apiClient
            loadFromStorage()
        }
    
    
    func fetchRepositories() {
        guard !isLoading, hasMoreData else { return }
        isLoading = true
        Task {
            do {
                let newRepositories = try await apiClient.fetchRepositories(query: "swift", page: page, perPage: perPage)
                if newRepositories.isEmpty {
                    hasMoreData = false
                } else {
                    repositories.append(contentsOf: newRepositories)
                    storage.save(repositories)
                    page += 1
                }
            } catch {
                print("Error loading repositories: \(error)")
            }
            isLoading = false
        }
    }
    
    
    func sortRepositories(by option: SortOption) {
        let sortedRepositories: [Repository]
        
        switch option {
        case .starsAscending:
            sortedRepositories = repositories.sorted(by: { $0.stars < $1.stars })
        case .starsDescending:
            sortedRepositories = repositories.sorted(by: { $0.stars > $1.stars })
        case .nameAscending:
            sortedRepositories = repositories.sorted(by: { $0.name < $1.name })
        case .nameDescending:
            sortedRepositories = repositories.sorted(by: { $0.name > $1.name })
        }
        
        repositories = sortedRepositories
    }
    
    private func loadFromStorage() {
        let localData = storage.fetch()
        if !localData.isEmpty {
            self.repositories = localData
        } else {
            self.fetchRepositories()
        }
    }
    
    func fetchRepositoriesFromStorage() {
        repositories = storage.fetch()
    }
    
    func updateRepository(_ updatedRepository: Repository) {
        if let index = repositories.firstIndex(where: { $0.id == updatedRepository.id }) {
            repositories[index] = updatedRepository
            storage.save(repositories)
        }
    }

        
    func deleteRepository(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let repositoryToDelete = repositories[index]
            
            repositories.remove(at: index)
            storage.delete(repositoryToDelete)
        }
        self.repositories = repositories
    }

        
    
}
