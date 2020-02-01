import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami

actions {
    /*main: Kirigami.Action {
                    iconName: "go-home"
                    onTriggered: showPassiveNotification(i18n("Main action triggered"))
                }
                left: Kirigami.Action {
                    iconName: "go-previous"
                    onTriggered: showPassiveNotification(i18n("Left action triggered"))
                }
                right: Kirigami.Action {
                    iconName: "go-next"
                    onTriggered: showPassiveNotification(i18n("Right action triggered"))
                }*/
    contextualActions: [
        Kirigami.Action {
            text: i18n("MY PC")
            iconName: "arrow-right"
            onTriggered: pageStack.replace(mainPageComponent)
        },
        Kirigami.Action {
            text: i18n("LIGHTING")
            iconName: "arrow-left"
            onTriggered: pageStack.replace(mainPageComponent)
        },
        Kirigami.Action {
            text: i18n("TUNING")
            iconName: "arrow-right"
            enabled: false
            onTriggered: pageStack.replace(tuningPageComponent)
        }
    ]
}
