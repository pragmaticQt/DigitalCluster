#include <QApplication>
#include <QQuickView>
#include <QSurfaceFormat>
#include <q3dsruntimeglobal.h>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    QSurfaceFormat::setDefaultFormat(Q3DS::surfaceFormat());

    QQuickView viewer;
    viewer.setSource(QUrl("qrc:/main.qml"));

    viewer.setTitle(QStringLiteral("State of the art digital cluster"));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.resize(1280, 480);
    viewer.show();

    return app.exec();
}