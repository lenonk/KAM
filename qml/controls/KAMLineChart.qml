import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.15

import org.kde.kcoreaddons 1.0 as KCoreAddons
import org.kde.quickcharts 1.0 as QuickCharts
import org.kde.quickcharts.controls 1.0 as QuickChartControls
import org.kde.kirigami 2.15 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: lineChart

    property alias value: valueSource.value
    property alias minValue: plotter.yRange.from
    property alias maxValue: plotter.yRange.to

    property string name: "Set Me Please!"
    property string axisSuffix: "%"


    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
        bottom: parent.bottom
        // Align plotter lines with labels.
        topMargin: speedMetrics.height / 2 + PlasmaCore.Units.smallSpacing
        leftMargin: speedMetrics.width  + PlasmaCore.Units.smallSpacing
        rightMargin: 20
        bottomMargin: 10
    }

    // @disable-check M300
    QuickCharts.LineChart {
        id: plotter

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            // Align plotter lines with labels.
            //topMargin: speedMetrics.height / 2 + PlasmaCore.Units.smallSpacing
        }

        //height: PlasmaCore.Units.gridUnit * 4
        height: parent.height

        smooth: false
        direction: QuickCharts.XYChart.ZeroAtEnd

        yRange {
            automatic: false
            from: 0
            to: 0
        }

        valueSources: [
            // @disable-check M300
            QuickCharts.ValueHistorySource {
                id: valueSource
                maximumHistory: 40
            }
        ]

        // @disable-check M300
        nameSource: QuickCharts.ArraySource {
            array: [i18n(lineChart.name)]
        }

        // @disable-check M300
            colorSource: QuickCharts.ArraySource {
            id: colorSource
            array: colors.colors.reverse()
        }

        // @disable-check M300
        QuickCharts.ColorGradientSource {
            id: colors
            baseColor:  PlasmaCore.Theme.highlightColor
            itemCount: 2
        }
    }

    // @disable-check M300
    QuickCharts.GridLines {
        anchors.fill: plotter
        direction: QuickCharts.GridLines.Vertical
        minor.visible: false
        major.count: 2
        major.lineWidth: 1
        // Same calculation as Kirigami Separator
        major.color: Kirigami.ColorUtils.linearInterpolation(PlasmaCore.Theme.backgroundColor, PlasmaCore.Theme.textColor, 0.4)
    }

    // @disable-check M300
    QuickCharts.AxisLabels {
        anchors {
            right: plotter.left
            rightMargin: PlasmaCore.Units.smallSpacing
            top: plotter.top
            bottom: plotter.bottom
        }
        constrainToBounds: false
        direction: QuickCharts.AxisLabels.VerticalBottomTop
        delegate:  PlasmaComponents3.Label {
            text: Math.floor(QuickCharts.AxisLabels.label) + i18n(axisSuffix)
            font: PlasmaCore.Theme.smallestFont
        }
        // @disable-check M300
        source: QuickCharts.ChartAxisSource {
            chart: plotter
            axis: QuickCharts.ChartAxisSource.YAxis
            itemCount: 4
        }
    }

    TextMetrics {
        id: speedMetrics
        font: PlasmaCore.Theme.smallestFont
        // Measure 888.8 KiB/s
        text: KCoreAddons.Format.formatByteSize(910131) + i18n("/s")
    }
}
