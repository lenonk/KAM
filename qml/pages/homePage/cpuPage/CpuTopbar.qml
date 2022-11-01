import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectTopbar

    ToggleButton {
        id: toggleButton
        width: 40
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 10
        btnIconSource: "../../../images/svg_icons/chevron-lefticonImage24px.svg"
        btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
        btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
        btnColorClicked: PlasmaCore.Theme.buttonFocusColor

        onClicked: (mouse)=> {
                       stackView.push(Qt.resolvedUrl("../homePage.qml"))
                   }
    }

    Label {
        id: label
        text: qsTr("CPU Details")
        anchors.left: toggleButton.right
        anchors.top: parent.top
        anchors.topMargin: 7
        font.pointSize: 16
    }
}
