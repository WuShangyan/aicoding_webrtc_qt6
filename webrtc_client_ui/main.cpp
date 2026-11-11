#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QUrl>

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName("webrtc_client");
    QCoreApplication::setOrganizationName("webrtc_client");
    QCoreApplication::setApplicationVersion("0.1.0");
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    const QUrl main_url(QStringLiteral("qrc:/qt/qml/WebrtcClient/qml/Main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [main_url](QObject* object, const QUrl& url) {
            if (object == nullptr && url == main_url) {
                QCoreApplication::exit(1);
            }
        },
        Qt::QueuedConnection);
    engine.load(main_url);
    return app.exec();
}
