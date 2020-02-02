import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import Qt.labs.platform 1.1 as Labs

Kirigami.ApplicationWindow {
    id: root
    title: "KAM Fan and Lighting control"
    height: 625
    width: 650

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    property int isMinimized: 3

    Backend {
        id: backend
    }

    onVisibilityChanged: {
        if (visibility === isMinimized)
            hide()
    }

     Labs.SystemTrayIcon {
        id: sysTrayIcon
        icon.source: "qrc:/icons/kam.png"
        visible: true
        onActivated: {
            if (reason === Labs.SystemTrayIcon.Trigger) {
                if (root.visible == false) {
                    showApp();
                }
                else
                    applicationWindow().hide()
            }
            else if (reason === Labs.SystemTrayIcon.MiddleClick) {
                //showMessage("Message title", "Middle button was clicked.")
            }
        }
        menu: Labs.Menu {
            id: trayMenu
            Labs.MenuItem {
                id: showItem
                text: qsTr("Show")
                onTriggered: showApp()
            }
            Labs.MenuItem {
                id: hideItem
                text: qsTr("Hide")
                onTriggered: applicationWindow().hide();
            }
            Labs.MenuSeparator {}
            Labs.MenuItem {
                id: quitItem
                text: qsTr("Quit")
                onTriggered: Qt.quit();
            }
            
        }
    }

    function showApp() {
        applicationWindow().show()
        applicationWindow().raise()
        applicationWindow().requestActivate()
    }

    globalDrawer: Kirigami.GlobalDrawer {
        title: "KDE KAM"
        actions: [
            Kirigami.Action {
                text: i18n("View")
                iconName: "view-list-icons"
                Kirigami.Action {
                    text: i18n("View Action 1")
                    onTriggered: showPassiveNotification(i18n("View Action 1 clicked"))
                }
                Kirigami.Action {
                    text: i18n("View Action 2")
                    onTriggered: showPassiveNotification(i18n("View Action 2 clicked"))
                }
            },
            Kirigami.Action {
                text: i18n("Action 1")
                onTriggered: showPassiveNotification(i18n("Action 1 clicked"))
            },
            Kirigami.Action {
                text: i18n("Action 2")
                onTriggered: showPassiveNotification(i18n("Action 2 clicked"))
            }
        ]
    }

    pageStack.initialPage: mainPageComponent
    
    MainPageComponent { id: mainPageComponent }
    LightingPageComponent { id: lightingPageComponent }
}
