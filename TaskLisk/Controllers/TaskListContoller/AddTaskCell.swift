import UIKit

class AddTaskCell: UITableViewCell {
    var textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddTaskCell {
    
    func configure() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "New task"
    }
    
    func layout() {
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
}
