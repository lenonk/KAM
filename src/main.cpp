#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <QIcon>
#include <KLocalizedContext>

#include "radialbar.h"
#include "backend.h"
#include "storagemodel.h"
#include "processmodel.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName("KDE");
    QCoreApplication::setOrganizationDomain("kde.org");
    QCoreApplication::setApplicationName("KAM");

    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    qmlRegisterType<Backend>("CustomControls", 1, 0, "Backend");
    qmlRegisterType<StorageModel>("CustomControls", 1, 0, "StorageModel");
    qmlRegisterType<ProcessModel>("CustomControls", 1, 0, "ProcessModel");

    QFont f("MrEavesXLModOT-Book");
    f.setPixelSize(12);
    app.setFont(f);
    
    QQmlApplicationEngine engine;
    
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    app.setWindowIcon(QIcon(QStringLiteral(":/icons/kam.png")));
    
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
