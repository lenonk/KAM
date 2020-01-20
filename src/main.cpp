#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <QIcon>
#include <KLocalizedContext>

#include "radialbar.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName("KDE");
    QCoreApplication::setOrganizationDomain("kde.org");
    QCoreApplication::setApplicationName("KAM");

    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    
    QFont f("MrEavesXLModOT-Book", 12);
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
