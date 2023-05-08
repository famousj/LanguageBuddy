import Foundation

extension String {
    static var random: String {
        """
        Lorem ipsum dolor sit amet. Aut quam necessitatibus et soluta neque ut voluptatibus quaerat est tempora accusamus qui consequatur quia. Qui odio atque et dolorem quas aut voluptas quia! Ea nihil omnis eum dolores perferendis sit omnis ullam eos quibusdam fuga et corporis quos. Rem fuga porro cum dolores magnam eum vitae omnis eum minima beatae.
        
        Ut nihil expedita qui voluptatem repudiandae est blanditiis voluptatem. Sed rerum labore eum veniam dolorem et enim laudantium quo nostrum enim ut accusamus optio et sapiente voluptatem qui galisum nostrum. Ex voluptas modi qui quis sapiente non repellat quae.

        Qui eligendi debitis rem tempora esse sed deserunt veniam. Aut repudiandae corrupti qui repellat velit est minima sint et sunt iste in aliquam eaque nam voluptas provident non quia expedita. Ut adipisci consequatur 33 dolorum necessitatibus cum enim repellendus sit laborum voluptatem eos dignissimos voluptatem. In rerum corporis et tenetur voluptate id suscipit consequatur.
        """
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            .randomElement()!
    }
}
