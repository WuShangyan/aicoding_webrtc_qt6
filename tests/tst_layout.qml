import QtCore
import QtQuick
import QtTest
import "../webrtc_client_ui/qml"

TestCase {
    name: "Workbench"
    when: windowShown
    readonly property url testSettingsLocation:
        StandardPaths.writableLocation(StandardPaths.TempLocation)
        + "/webrtc-client-qmltest-" + Date.now() + "-" + Math.random() + ".ini"

    Main {
        id: app
        settingsLocation: testSettingsLocation
    }

    Component {
        id: settingsReader
        Settings {
            category: "ConnectionSettings"
            location: testSettingsLocation
        }
    }

    function cleanupTestCase() {
        app.close()
        tryCompare(app, "visible", false)
    }
    readonly property var buttons: ["devicesButton", "previewButton", "publishButton", "subscribeButton",
                                    "speakerButton", "settingsButton"]

    function initTestCase() {
        const picker = findChild(app.contentItem, "layoutPicker")
        compare(picker.currentText, "9宫格")
        compare(findChild(app.contentItem, "videoStage").tileCount, 9)
    }

    function test_header() {
        if (!app.unifiedTitleBar)
            skip("Qt 或窗口系统未启用合并标题栏")

        app.requestActivate()
        tryCompare(app, "active", true)
        app.width = app.minimumWidth
        app.height = app.minimumHeight
        wait(100)
        compare(app.topPadding, 0)
        const header = findChild(app.contentItem, "roomHeader")
        const stage = findChild(app.contentItem, "videoStage")
        const dragArea = findChild(header, "titleDragArea")
        verify(dragArea.width > 0)
        compare(stage.y, header.height)
        mouseDoubleClickSequence(dragArea)
        tryCompare(app, "visibility", Window.Maximized)
        mouseDoubleClickSequence(dragArea)
        tryCompare(app, "visibility", Window.Windowed)
    }

    function test_layout_data() {
        const result = []
        const sizes = [{tag: "default", w: 1440, h: 900},
                       {tag: "minimum", w: 960, h: 640},
                       {tag: "large", w: 1920, h: 1080}]
        for (const size of sizes) {
            for (const [index, count] of [2, 4, 9, 16].entries()) {
                result.push({tag: size.tag + "-" + count, w: size.w, h: size.h,
                             index: index, count: count})
            }
        }
        return result
    }

    function test_layout(data) {
        app.width = data.w
        app.height = data.h
        const picker = findChild(app.contentItem, "layoutPicker")
        picker.currentIndex = data.index
        wait(60)
        const stage = findChild(app.contentItem, "videoStage")
        const toolbar = findChild(app.contentItem, "controlBar")
        compare(picker.currentText, data.count + "宫格")
        compare(stage.tileCount, data.count)
        const columns = data.count === 2 ? 2 : Math.sqrt(data.count)
        const rows = data.count / columns
        const width = (stage.width - columns + 1) / columns
        const height = (stage.height - rows + 1) / rows
        const stageTop = stage.mapToItem(app.contentItem, 0, 0).y
        const toolbarTop = toolbar.mapToItem(app.contentItem, 0, 0).y
        compare(stage.width, app.width)
        compare(stageTop + stage.height, toolbarTop)
        for (let i = 0; i < data.count; ++i) {
            const tile = findChild(stage, "videoTile" + (i + 1))
            verify(tile !== null)
            fuzzyCompare(tile.width, width, 0.01)
            fuzzyCompare(tile.height, height, 0.01)
            fuzzyCompare(tile.x, (i % columns) * (width + 1), 0.01)
            fuzzyCompare(tile.y, Math.floor(i / columns) * (height + 1), 0.01)
        }
        compare(findChild(stage, "videoTile" + (data.count + 1)), null)

        for (const name of buttons) {
            const button = findChild(app.contentItem, name)
            const p = button.mapToItem(app.contentItem, 0, 0)
            verify(button.availableWidth >= button.implicitContentWidth)
            verify(p.x >= 0 && p.x + button.width <= app.width)
            if (name === "speakerButton" || name === "settingsButton") {
                verify(p.y >= 0 && p.y + button.height <= stageTop)
            } else {
                verify(p.y >= toolbarTop && p.y + button.height <= app.height)
            }
        }
    }

    function test_menu() {
        const picker = findChild(app.contentItem, "layoutPicker")
        const stage = findChild(app.contentItem, "videoStage")
        picker.currentIndex = 2
        app.requestActivate()
        tryCompare(app, "active", true)
        for (const index of [0, 1, 3, 2]) {
            mouseClick(picker)
            tryCompare(picker.popup, "opened", true)
            const list = picker.popup.contentItem
            tryVerify(() => list.itemAtIndex(index) !== null)
            mouseClick(list.itemAtIndex(index))
            tryCompare(picker.popup, "opened", false)
            compare(picker.currentIndex, index)
            compare(stage.tileCount, [2, 4, 9, 16][index])
        }
    }

    function test_placeholder() {
        for (let name of buttons.filter(name => name !== "settingsButton")) {
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
    }

    function test_settings() {
        app.width = app.minimumWidth
        app.height = app.minimumHeight
        app.requestActivate()
        tryCompare(app, "active", true)
        const button = findChild(app.contentItem, "settingsButton")
        const dialog = findChild(app.contentItem, "settingsDialog")
        const form = dialog.contentItem
        const server = findChild(form, "settingsServerAddress")
        const uid = findChild(form, "settingsUid")
        const publish = findChild(form, "settingsPublishName")
        const subscribe = findChild(form, "settingsSubscribeName")
        const camera = findChild(form, "settingsCamera")
        const microphone = findChild(form, "settingsMicrophone")
        const cancel = findChild(dialog.footer, "settingsCancel")
        const save = findChild(dialog.footer, "settingsSave")
        const close = findChild(dialog.header, "settingsClose")

        mouseClick(button)
        tryCompare(dialog, "opened", true)
        compare(server.text, "xrtc://www.str2num.com:9081")
        compare(uid.text, "8888")
        compare(publish.text, "ai100")
        compare(subscribe.text, "ai100")
        for (const device of [camera, microphone]) {
            compare(device.currentText, "无")
            compare(device.count, 1)
            mouseClick(device)
            tryCompare(device.popup, "opened", true)
            keyClick(Qt.Key_Escape)
            tryCompare(device.popup, "opened", false)
            verify(dialog.opened)
        }

        uid.text = "discarded"
        mouseClick(cancel)
        tryCompare(dialog, "opened", false)

        button.forceActiveFocus(Qt.TabFocusReason)
        tryCompare(button, "activeFocus", true)
        keyClick(Qt.Key_Space)
        tryCompare(dialog, "opened", true)
        compare(uid.text, "8888")
        server.text = "xrtc://example.test:9081"
        uid.text = "00123"
        publish.text = "local"
        subscribe.forceActiveFocus(Qt.TabFocusReason)
        tryCompare(subscribe, "activeFocus", true)
        const inputY = subscribe.mapToItem(form, 0, 0).y
        verify(inputY >= 0 && inputY + subscribe.height <= form.height)
        subscribe.text = "remote"
        mouseClick(save)
        tryCompare(dialog, "opened", false)

        const stored = createTemporaryObject(settingsReader, this)
        verify(stored !== null)
        compare(stored.value("serverAddress", ""), "xrtc://example.test:9081")
        compare(stored.value("uid", ""), "00123")
        compare(stored.value("publishName", ""), "local")
        compare(stored.value("subscribeName", ""), "remote")
        compare(stored.value("camera", ""), "无")
        compare(stored.value("microphone", ""), "无")

        mouseClick(button)
        tryCompare(dialog, "opened", true)
        compare(subscribe.text, "remote")
        uid.text = "discard-close"
        mouseClick(close)
        tryCompare(dialog, "opened", false)
        mouseClick(button)
        tryCompare(dialog, "opened", true)
        compare(uid.text, "00123")
        uid.text = "discard-escape"
        keyClick(Qt.Key_Escape)
        tryCompare(dialog, "opened", false)
        mouseClick(button)
        tryCompare(dialog, "opened", true)
        compare(uid.text, "00123")
        mouseClick(cancel)
        tryCompare(dialog, "opened", false)
    }
}
