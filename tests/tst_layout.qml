import QtQuick
import QtTest
import "../webrtc_client_ui/qml"

TestCase {
    name: "Workbench"
    when: windowShown
    Main { id: app }
    readonly property var buttons: ["devicesButton", "speakerButton", "previewButton", "publishButton", "subscribeButton", "settingsButton"]

    function test_layout_data() {
        return [{tag: "default", w: 1440, h: 900},
                {tag: "minimum", w: 960, h: 640},
                {tag: "large", w: 1920, h: 1080}]
    }
    function test_layout(data) {
        app.width = data.w
        app.height = data.h
        wait(150)
        for (let i = 1; i <= 9; ++i) {
            let tile = findChild(app.contentItem, "videoTile" + i)
            verify(tile !== null)
            let p = tile.mapToItem(app.contentItem, 0, 0)
            verify(tile.width > 0 && tile.height > 0)
            verify(p.x >= 0 && p.y >= 0)
            verify(p.x + tile.width <= app.width + 1)
            verify(p.y + tile.height <= app.height - 108 + 1)
        }
        let previousRight = 0
        for (let name of buttons) {
            let button = findChild(app.contentItem, name)
            verify(button !== null)
            let p = button.mapToItem(app.contentItem, 0, 0)
            verify(p.x >= previousRight)
            verify(p.x + button.width <= app.width)
            verify(p.y >= app.height - 108)
            previousRight = p.x + button.width
        }
    }
    function test_placeholder() {
        for (let name of buttons) {
            let button = findChild(app.contentItem, name)
            let original = button.text
            mouseClick(button)
            let toast = findChild(app.contentItem, "placeholderToast")
            verify(toast !== null)
            tryCompare(toast, "opened", true)
            compare(toast.contentItem.text, original + "尚未接入，当前仅展示 UI")
            compare(button.text, original)
        }
        let toast = findChild(app.contentItem, "placeholderToast")
        tryCompare(toast, "opened", false, 4000)
        let settings = findChild(app.contentItem, "settingsButton")
        app.requestActivate()
        tryCompare(app, "active", true)
        settings.forceActiveFocus(Qt.TabFocusReason)
        tryCompare(settings, "activeFocus", true)
        keyClick(Qt.Key_Space)
        tryCompare(toast, "opened", true)
        app.close()
    }
}
