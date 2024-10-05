//
//  ViewController.swift
//  ReactorKitTodo-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources
import SnapKit

class TodoViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<TodoSection>(
        configureCell: { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as! TodoCell
            cell.configure(with: item.title)
            cell.backgroundColor = item.isCompleted ? .lightGray : .white
            return cell
        }
    )
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
            let config = self.createListConfiguration()
            let layout = UICollectionViewCompositionalLayout.list(using: config)
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(TodoCell.self, forCellWithReuseIdentifier: "TodoCell")
            return collection
        }()
    
    private let inputField: UITextField = {
        let field = UITextField()
        field.placeholder = "할 일을 입력하세요"
        field.borderStyle = .roundedRect
        return field
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.tintColor = .systemBlue
        return button
    }()
    
    // MARK: - Initialization
    init(reactor: TodoReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Method
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(inputField)
        view.addSubview(addButton)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(inputField.snp.top).offset(-20)
        }
        
        inputField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalTo(addButton.snp.left).offset(-10)
        }
        
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(inputField)
            make.width.height.equalTo(44)
        }
    }
    
    private func createListConfiguration() -> UICollectionLayoutListConfiguration {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self else { return nil }
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
                let todo = self.dataSource[indexPath]
                self.reactor?.action.onNext(.remove(todo))
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return config
    }
    
    // MARK: - Binding
    func bind(reactor: TodoReactor) {
        addButton.rx.tap
            .withLatestFrom(inputField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .map { Todo(id: Int.random(in: 0...10000), title: $0, isCompleted: false) }
            .do(onNext: { [weak self] _ in self?.inputField.text = "" })
            .map { Reactor.Action.add($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { state -> [TodoSection] in
            let todos = state.todos.map { Todo(id: $0.id, title: $0.title, isCompleted: $0.isCompleted) }
            return [TodoSection(items: todos)]
        }
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        reactor.action.onNext(.loadTodos)
    }
}
