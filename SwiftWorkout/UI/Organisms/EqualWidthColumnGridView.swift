import SwiftUI

struct EqualWidthColumnGridView<Content: View, Model: Identifiable & Hashable>: View {
    let width: CGFloat
    let columns: (CGFloat) -> Int
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let models: [Model]
    let transform: (Model, CGFloat) -> Content
    
    var body: some View {
        let numColumns = columns(width)
        let totalHorizontalSpacing = CGFloat(numColumns - 1) * horizontalSpacing
        let columnWidth = max((width - totalHorizontalSpacing) / CGFloat(numColumns), 0)
        let rows = models.chunked(into: numColumns)
        
        return VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.element) { offset, row in
                if offset != 0 {
                    Spacer()
                        .frame(height: verticalSpacing)
                }
                
                HStack(alignment: .top, spacing: horizontalSpacing) {
                    ForEach(row) { item in
                        transform(item, columnWidth)
                            .frame(width: columnWidth)
                    }
                    if row.count < numColumns {
                        ForEach(row.count..<numColumns, id: \.self) { _ in
                            Color.clear
                                .frame(width: columnWidth, height: 1)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    struct TestModel: Identifiable, Hashable {
        let id: Int
        init(_ id: Int) {
            self.id = id
        }
    }
    return EqualWidthColumnGridView(
        width: 300,
        columns: {_ in 3 },
        horizontalSpacing: 4,
        verticalSpacing: 4,
        models: [TestModel(1), TestModel(2), TestModel(3), TestModel(4), TestModel(5)],
        transform: { _, width in Color.red.frame(height: width) }
    )
}
