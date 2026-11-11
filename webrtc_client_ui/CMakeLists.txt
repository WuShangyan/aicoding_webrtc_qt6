qt_add_executable(webrtc_client main.cpp)
set_target_properties(webrtc_client PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.webrtcclient.desktop"
    MACOSX_BUNDLE_BUNDLE_NAME "webrtc_client"
    MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
)
qt_add_qml_module(webrtc_client
    URI WebrtcClient
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/VideoGrid.qml
        qml/VideoTile.qml
        qml/ActionButton.qml
        qml/ControlBar.qml
    RESOURCES
        icons/devices.svg
        icons/speaker.svg
        icons/preview.svg
        icons/upload.svg
        icons/download.svg
        icons/settings.svg
        icons/video.svg
)
target_link_libraries(webrtc_client PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Svg)
include(GNUInstallDirs)
install(TARGETS webrtc_client
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
qt_generate_deploy_qml_app_script(
    TARGET webrtc_client
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})
