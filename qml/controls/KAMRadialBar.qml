import QtQuick 2.15
import CustomControls 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

RadialBar {
    width: 100
    height: 100
    penStyle: Qt.FlatCap
    progressColor: PlasmaCore.Theme.highlightColor
    foregroundColor: PlasmaCore.Theme.disabledTextColor
    dialWidth: 8
    minValue: 0
    maxValue: 100
    value: 16
    suffixText: "%"
    startAngle: 350
    textFont.family: PlasmaCore.Theme.defaultFont
    textFont.pointSize: Math.max(PlasmaCore.Theme.smallestFont.pointSize, Math.round(width / 4))
    textColor: progressColor
    labelFont.family: PlasmaCore.Theme.defaultFont
    labelFont.pointSize: Math.max(PlasmaCore.Theme.smallestFont.pointSize, Math.round(width / 10))
    labelColor: PlasmaCore.Theme.disabledTextColor
}
