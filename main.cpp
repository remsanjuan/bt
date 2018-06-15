#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include "scanner.h"
#include <QDebug>

#include <QQmlContext>
#include "fileio.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Scanner>("io.qt.Scanner", 1, 0, "Scanner");
    typedef QList<int> IntList;
    qRegisterMetaType< IntList >( "IntList" );

    QQmlApplicationEngine engine;
//    qDebug()<<engine.importPathList();
    engine.rootContext()->setContextProperty("FileIO", new FileIO());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
