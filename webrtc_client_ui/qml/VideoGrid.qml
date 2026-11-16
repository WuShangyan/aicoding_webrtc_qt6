import QtQuick

Rectangle {
    id: grid
    objectName: "videoGrid"
    required property int tileCount

    readonly property int columns: tileCount === 2 ? 2 : Math.sqrt(tileCount)
    readonly property int rows: Math.ceil(tileCount / columns)
    readonly property real gap: 1
    readonly property real tileWidth: (width - (columns - 1) * gap) / columns
    readonly property real tileHeight: (height - (rows - 1) * gap) / rows
    color: "#485361"

    Repeater {
        model: grid.tileCount
        VideoTile {
            required property int index
            readonly property int row: Math.floor(index / grid.columns)
            readonly property int column: index % grid.columns
            channelNumber: index + 1
            alternate: (row + column) % 2 !== 0
            x: column * (grid.tileWidth + grid.gap)
            y: row * (grid.tileHeight + grid.gap)
            width: grid.tileWidth
            height: grid.tileHeight
        }
    }
}
