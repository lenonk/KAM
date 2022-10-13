#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QLocale>
#include <QTranslator>
#include <QIcon>
#include <QtQml>

#include <KService>

#include <iostream>

#include "radialbar.h"
#include "backend.h"
#include "processmodel.h"

class PixmapBuilder : public QQuickImageProvider {
public:
    explicit PixmapBuilder(ProcessList *plist) :
        QQuickImageProvider(QQuickImageProvider::Pixmap),
        m_plist(plist) {};

    const QString icon_path { "/usr/share/icons/hicolor/16x16/apps/" };
    const QVector<QString> formats { ".svg", ".jpg", ".png", ".xpm" };

    QPixmap requestPixmap(const QString &id, QSize *, const QSize &) override {
        for (int32_t i = 0; i < m_plist->items().size(); i++) {
            if (m_plist->items()[i].process == id) {
                auto proc = m_plist->items()[i];
                QPixmap pmap = QIcon::fromTheme(proc.icon).pixmap(16, 16);
                return pmap;
            }
        }

        return QPixmap();
    }

private:
    ProcessList *m_plist;
};

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);
    //ProcessModel processModel;
    Backend backend; // CHANGED

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "KAM_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    //qmlRegisterType<ProcessModel>("ProcessModel", 1, 0, "ProcessModel");
    // CHANGED
    //qmlRegisterType<Backend>("Backend", 1, 0, "Backend");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    //engine.rootContext()->setContextProperty("ProcessModel", &processModel);
    // CHANGED
    engine.rootContext()->setContextProperty("backend", &backend);
    //engine.addImageProvider(QLatin1String("icons"), new PixmapBuilder(processModel.get_list()));
    engine.addImageProvider(QLatin1String("icons"), new PixmapBuilder(backend.m_model->get_list()));
    engine.load(url);

    app.setWindowIcon(QIcon(QStringLiteral(":/qml/images/png_icons/kam.png")));
    return app.exec();
}
