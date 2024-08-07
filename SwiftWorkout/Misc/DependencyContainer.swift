import Foundation

class Container: @unchecked Sendable {
    var appSettingsRepo: AppSettingsRepo?
    var localWorkoutRepo: LocalWorkoutRepo?
    var remoteWorkoutRepo: RemoteWorkoutRepo?
    
    var appStateInteractor: AppStateInteractor?
    var workoutsInteractor: WorkoutsInteractor?
}

extension Container {
    static var `default`: Container {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = false
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let urlSession = URLSession(configuration: configuration)
        
        let localRepo = UserDefaultsWorkoutRepo()
                
        let container = Container()
        container.appSettingsRepo = AppSettingsRepoImpl()
        container.appStateInteractor = AppStateInteractorImpl(container: container)
        container.localWorkoutRepo = localRepo
        container.remoteWorkoutRepo = WebWorkoutRepo(container: container, requestProvider: HttpRequestProvider(baseUrl: AppConfig.backendUrlBase, urlSession: urlSession))
        let workoutsInteractor = WorkoutsInteractorImpl(container: container)
        container.workoutsInteractor = workoutsInteractor
        
        let initializable: [Initializable] = [localRepo, workoutsInteractor]
        Task {
            for item in initializable {
                try? await item.initialize()
            }
        }
        return container
    }
}

protocol Injectable: AnyObject {
    var container: Container { get }
}

/// A property wrapper injecting a dependency from the container
@propertyWrapper struct Injected<T> {
    private let dependencyKeyPath: KeyPath<Container, T?>
    
    init(_ keyPath: KeyPath<Container, T?>) {
        self.dependencyKeyPath = keyPath
    }

    public static subscript<EnclosingType: Injectable>(
        _enclosingInstance enclosing: EnclosingType,
        wrapped wrappedKeyPath: KeyPath<EnclosingType, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Self>
    ) -> T {
        let keyPath = enclosing[keyPath: storageKeyPath].dependencyKeyPath
        return enclosing.container[keyPath: keyPath]!
    }
    
    var wrappedValue: T {
        fatalError("This property wrapper should only be used on an Injectable parent")
    }
}
