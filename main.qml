import QtQuick 2.6
import QtQuick.Window 2.2
import io.qt.Scanner 1.0

import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import QtCharts 2.1


//import QtQuick 2.6
//import QtQuick.Window 2.2
//import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import "js/app.js" as MyScript
import "js/simpleheat.js" as MyHeatmap


ApplicationWindow {
    id:app
    visible: true
    width: 800
    height: 600
    maximumHeight: height
   // maximumWidth: width

    minimumHeight: height
    minimumWidth: width
    title: qsTr("Boditrak Scanner")
    color: "#243037"



    property string uu

    Rectangle{
        property string w;
        Component.onCompleted: {
            var u;
            var urlArray = ["127.0.0.1","10.0.0.1","192.168.173.1","192.168.137.1"];
            for(u=0; u<urlArray.length; u++){
            MyScript.request('http://'+urlArray[u]+'/api', function (o) {
                var d= JSON.parse(o.responseText);
                scanner.serial = d.sensors[0].name;
                scanner.url = d.device.address;
                w = d.device.address;

                hm.numcolumns = d.sensors[0].columns;
                hm.numrows = d.sensors[0].rows;
                hm.sizematwidth = d.sensors[0].width;
                hm.sizematheight = d.sensors[0].height;
                hm.maximum = d.sensors[0].maximum;
                scanner.sensorArea = (hm.sizematwidth/hm.numcolumns)*(hm.sizematheight/hm.numrows);

                    var gridsize = 340/hm.numcolumns;
                    rectangleBox.width = gridsize * hm.numrows;
                    rectangleBox.height = gridsize * hm.numcolumns;
                    app.width = gridsize * hm.numcolumns + 180 + 225 + 60;
                    if(rectangleBox.width > 800){
                        gridsize = 800 / hm.numrows;
                        rectangleBox.width = 800;
                        rectangleBox.height = gridsize * hm.numcolumns;

                    }

                    hm.width = gridsize * hm.numcolumns;
                    hm.height = gridsize * hm.numrows;
                    app.width = gridsize * hm.numrows + 180 + 225 + 60 + 200;
                    app.setX(Screen.width / 2 - app.width / 2);
                    app.setY(Screen.height / 2 - app.height / 2);

                });

            }//end of for(
            console.log("URL: "+w);
        }

    }


    Scanner {
        id: scanner
        property bool toggle:false
        property string s_units
        property string s_name
        property double s_actualweight:50.0
        property double s_weight: 0
        property double s_percentdifference:0
        property string s_status
        property int counter:0
        property point oldpoint;
        property point newpoint;
        property string serial:"NO MAT"
        property string unit: "mmHg"
        property int clipoff:5
        property double max:0
        property double ave:0
        property double area:0
        property double sensorArea:0
        property string url:""
        property bool started:false

        property int w
        property int h

        onToggleChanged: {
            //console.log("onToggleChanged:");

            MyScript.request('http://'+scanner.url+'/api', function (o) {
                var d= JSON.parse(o.responseText);

                hm.values = d.frames[0].readings[0];
                var m_max = 0;
                var m_total = 0;
                var m_active = 0;

                    for(var x=0; x<hm.values.length; x++){
                        if(hm.values[x] >= scanner.clipoff){
                            if(hm.values[x] > m_max){
                                m_max = hm.values[x];
                            }
                            m_total += hm.values[x];
                            m_active++;
                        }
                    } //end of for(var x=0...
                    scanner.max = m_max;
                    if(m_active){
                        scanner.area = m_active * scanner.sensorArea;
                        scanner.ave = m_total / m_active;
                        scanner.s_weight = scanner.area * scanner.ave / 10000;
                        scanner.s_percentdifference = ((scanner.s_weight - scanner.s_actualweight)/scanner.s_actualweight)*100;
                    }
                    if(counter <= 20){
                        percentDifferenceSeries.append(counter,s_percentdifference);
                    }else{
                        for(var i = 1; i <= 20; i++){
                            newpoint = percentDifferenceSeries.at(i);
                            percentDifferenceSeries.remove(i-1);
                            percentDifferenceSeries.insert(i-1,i-1,newpoint.y);
                            if(i == 20){
                                percentDifferenceSeries.remove(i);
                                percentDifferenceSeries.insert(i,i,s_percentdifference);

                            }
                       }
                    }
                    counter++;
                    m_max = 0;
                    m_total=0;
                    m_active=0;


                });
        }

        onStatusChanged: {
//           console.log(newStatus);
           // message = newStatus;
         }

        onScanUpdated: {
            hm.values = i_val;
        }

        onMatInfoUpdated: {
            serial = info[0];
            hm.numcolumns = info[1];
            hm.numrows = info[2];
            hm.sizematwidth = info[3];
            hm.sizematheight = info[4];
            hm.maximum = info[5];
            //unit = info[6];
//            console.log(info);

                var gridsize = 340/hm.numcolumns;
                rectangleBox.width = gridsize * hm.numrows;
                rectangleBox.height = gridsize * hm.numcolumns;
                app.width = gridsize * hm.numcolumns + 180 + 225 + 60;
                if(rectangleBox.width > 800){
                    gridsize = 800 / hm.numrows;
                    rectangleBox.width = 800;
                    rectangleBox.height = gridsize * hm.numcolumns;

                }

                hm.width = gridsize * hm.numcolumns;
                hm.height = gridsize * hm.numrows;
                app.width = gridsize * hm.numrows + 180 + 225 + 60;
                app.setX(Screen.width / 2 - app.width / 2);
                app.setY(Screen.height / 2 - app.height / 2);
               // w = gridsize * hm.numrows;
               // h = gridsize * hm.numcolumns;

 //           console.log(hm.numcolumns);
  //          console.log(hm.numrows);
 //           console.log(gridsize);
/*
            if(hm.numcolumns == hm.numrows){
                hm.cu=false;
                hm.cd=true;
            }else{
                hm.cd=false;
                 hm.cu=true;
            }
*/


        }

        onStatisticsUpdated:  {
 //          console.log(stat);
            scanner.max = stat[0];
            scanner.ave = stat[1];
            scanner.area = stat[2];

            //console.log(weight);
            if(scanner.s_units == "lbs"){
                scanner.s_weight = stat[3] / 0.453592;
            }else{
                scanner.s_weight = stat[3];
            }

            scanner.s_percentdifference = ((scanner.s_weight - scanner.s_actualweight)/scanner.s_actualweight)*100;
            if(Math.abs(scanner.s_percentdifference) <= 10){
                scanner.s_status = "PASSED";
                statusText.color = "green";
            }else{
                scanner.s_status = "FAILED";
                statusText.color = "red";
            }

            if(counter <= 20){
                percentDifferenceSeries.append(counter,s_percentdifference);
            }else{
                for(var i = 1; i <= 20; i++){
                    newpoint = percentDifferenceSeries.at(i);
                    percentDifferenceSeries.remove(i-1);
                    percentDifferenceSeries.insert(i-1,i-1,newpoint.y);
                    if(i == 20){
                        percentDifferenceSeries.remove(i);
                        percentDifferenceSeries.insert(i,i,s_percentdifference);

                    }
               }
            }
            counter++;

        }
    }

    Rectangle {
        id:weightRectangle
        width:225
        height:360
        anchors{
            right:parent.right
            top:parent.top
            margins:20
        }
        color: "#2f3e47"

        Rectangle{
            width: 204
            height:width
            color: "#243037"

            radius:  width/2
            anchors{
                top:parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter

            }

            Image {
                width: parent.width - 15
                height: parent.height - 15
                source: "/images/scale.png"

                anchors{
                    centerIn: parent
                }

                NeedleScale {
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    value: scanner.s_weight

                }

                Rectangle{
                    id:smallcircle
                    width:15
                    height: width
                    radius:height/2
                    color:"gray"
                    anchors{
                        centerIn: parent
                    }
                }

                Text{
                    id:gaugecalculatedweightText
                    text: scanner.s_weight.toFixed(0)
                    font.pixelSize: 20
                    font.family: "Eurostile"
                    font.bold: true
                    color: "#1994b3"
                    anchors{
                        top:parent.top
                        topMargin: 62
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Text{
                    id:gaugeunitsText
                    text: scanner.s_units
                    font.pixelSize: 10
                    font.family: "Eurostile"
                    font.bold: true
                    color: "#1994b3"
                    anchors{
                        bottom: gaugecalculatedweightText.bottom
                        left:gaugecalculatedweightText.right
                        leftMargin: 3

                    }
                }

            }

        }

        Rectangle{
            width: 204
            height:parent.height - 234
            color: "#243037"
            anchors{
                bottom: parent.bottom
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                width: parent.width - 10
                height: parent.height - 10
                color: "#2f3e47"
                anchors{
                    centerIn: parent
                }

                RowLayout {
                    anchors.fill: parent

                    spacing: 6

                    Text {
                        id: nameLabel
                        text: "Name:"
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        y: 60
                        color: "#c8c8c8"
                        anchors{
                            top:parent.top
                            topMargin: 10
                            left:parent.left
                            leftMargin: 10
                        }
                    }

                    Text {
                        id:nameText
                        text: scanner.s_name
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        font.bold: true
                        y: 60
                        color: "white"
                        anchors{
                            top:parent.top
                            topMargin: 10
                            left: nameLabel.right
                            leftMargin: 10
                        }
                    }

                    Text {
                        id: weightLabel
                        text: "Weight:"
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        color: "#c8c8c8"
                        anchors{
                            top:nameLabel.bottom
                            topMargin: 5
                            left:parent.left
                            leftMargin: 10
                        }
                    }

                    Text {
                        id:weightText
                        text: scanner.s_actualweight + " " + scanner.s_units
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        font.bold: true
                        color: "white"
                        anchors{
                            top:nameText.bottom
                            topMargin: 5
                            left: weightLabel.right
                            leftMargin: 10
                        }
                    }

                    Text {
                        id: calculatedweightLabel
                        text: "Calculated Wgt:"
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        color: "#c8c8c8"
                        anchors{
                            top:weightLabel.bottom
                            topMargin: 5
                            left:parent.left
                            leftMargin: 10
                        }
                    }

                    Text {
                        id:calculatedweightText
                        text: scanner.s_weight.toFixed(0) + " " + scanner.s_units
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        font.bold: true
                        color: "white"
                        anchors{
                            top:weightText.bottom
                            topMargin: 5
                            left: calculatedweightLabel.right
                            leftMargin: 10
                        }
                    }

                    Text {
                        id: percentdifferenceLabel
                        text: "Percent Difference:"
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        color: "#c8c8c8"
                        anchors{
                            top:calculatedweightLabel.bottom
                            topMargin: 5
                            left:parent.left
                            leftMargin: 10
                        }
                    }

                    Text {
                        id:percentdifferenceText
                        text: scanner.s_percentdifference.toFixed(0) + " %"
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        font.bold: true
                        color: "white"
                        anchors{
                            top:calculatedweightText.bottom
                            topMargin: 5
                            left: percentdifferenceLabel.right
                            leftMargin: 10
                        }
                    }

                    Text {
                        id: statusLabel
                        text: "Status:"
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        color: "#c8c8c8"
                        anchors{
                            top:percentdifferenceLabel.bottom
                            topMargin: 5
                            left:parent.left
                            leftMargin: 10
                        }
                    }

                    Text {
                        id:statusText
                        text: scanner.s_status
                        width: 100
                        height:40
                        font.pixelSize: 14
                        font.family: "Eurostile"
                        font.bold: true
                        color: "green"
                        anchors{
                            top:percentdifferenceText.bottom
                            topMargin: 5
                            left: statusLabel.right
                            leftMargin: 10
                        }
                    }

                }//end of RowLayout

                RowLayout {
                    anchors.fill: parent
                    spacing: 6





                }//end of RowLayout


            }

        }



        //border.color: "black"
        //border.width: 1




    }

    Rectangle {
        id:controlsRectangle
        width:225
        height:190
        anchors{
            right:parent.right
            rightMargin: 20
            bottom:parent.bottom
            bottomMargin:20
        }
        color: "#2f3e47"

        Button {
            id:startButton
            y: parent.height - 30
            x:15
            anchors{
                right: stopButton.left
                rightMargin: 10
                bottom: stopButton.bottom
            }

            style: ButtonStyle {
                background: Rectangle {
                    id:startbuttonRectangle
                    implicitWidth: 50
                    implicitHeight: implicitWidth
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#02330a"
                    radius: implicitWidth/2
                    color: "transparent"
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 1
                        verticalOffset: 1
                        color: "#ffffff"
                    }
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.hovered  || control.pressed ? "#02330a" : "#127923" }
                        GradientStop { position: 1 ; color: control.hovered  || control.pressed ? "#127923" : "#02330a" }
                    }
                }
                label: Text{
                    text: "START"
                    font.bold: true
                    font.family: "Helvetica"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pointSize: 8
                    color: control.pressed ? "yellow" :"#def6e2"
                }
            }
            onClicked: {

                this.enabled = false;
                stopButton.enabled=true;
                settingsButton.enabled=false;
                //scanner.startClicked(calibrator.cal_units, calibrator.cal_cycles, calibrator.cal_targets, calibrator.cal_holdtimes);
                scanner.started=true;
                scanner.toggle=!scanner.toggle;
                scanner.startClicked();


                /*
                //var hey = new MyHeatmap.simpleheat(mycanvas);
                var heat = MyHeatmap.simpleheat(mycanvas).data(Mydata.data).max(18),
                    frame;
                function draw() {
                    console.time('draw');
                    heat.draw();
                    console.timeEnd('draw');
                    frame = null;
                }
                draw();
                */
                //console.log(hey.radius(3));
            }
        } //end of startButton

        Button {
            id:stopButton
            anchors{
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 10
            }

            style: ButtonStyle {
                background: Rectangle {
                    id:stopbuttonRectangle
                    implicitWidth: 50
                    implicitHeight: implicitWidth
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#f11f03"
                    radius: implicitWidth/2
                    color: "transparent"
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 1
                        verticalOffset: 1
                        color: "#ffffff"
                    }
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.hovered  || control.pressed ? "#801a0d" : "#f11f03" }
                        GradientStop { position: 1 ; color: control.hovered  || control.pressed ? "#f11f03" : "#801a0d" }
                    }
                }
                label: Text{
                    text: "STOP"
                    font.bold: true
                    font.family: "Helvetica"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pointSize: 8
                    color: control.pressed ? "yellow" :"#def6e2"
                }
            }
            onClicked: {
                scanner.stopClicked();
                this.enabled = false;
                startButton.enabled=true;
                settingsButton.enabled=true;
                hm.start = true;
                scanner.started=false;
                //scanner.toggle=!scanner.toggle;

            }
        } //end of stopButton

        Button {
            id:settingsButton

            anchors{
                left: stopButton.right
                leftMargin: 10
                bottom: stopButton.bottom
            }

            style: ButtonStyle {
                background: Rectangle {
                    id:settingsbuttonRectangle
                    implicitWidth: 50
                    implicitHeight: implicitWidth
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#0c46b0"
                    radius: implicitWidth/2
                    color: "transparent"
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 1
                        verticalOffset: 1
                        color: "#ffffff"
                    }
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.hovered  || control.pressed ? "#042d79" : "#0c46b0" }
                        GradientStop { position: 1 ; color: control.hovered  || control.pressed ? "#0c46b0" : "#042d79" }
                    }
                }
                label: Text{
                    text: "SETTINGS"
                    font.bold: true
                    font.family: "Helvetica"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pointSize: 6
                    color: control.pressed ? "yellow" :"#def6e2"
                }
            }
            onClicked: {
                    var component = Qt.createComponent("settings.qml");
                    if (component.status === Component.Ready) {
                    var dialog = component.createObject(parent,{popupType: 1});
                    dialogConnection.target = dialog
                    dialog.show();
               }
            }
        } //end of settingsButton

        Rectangle{
            width: parent.width - 20
            height: parent.height - 80
            color: "#243037"
            anchors{
                bottom: parent.bottom
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                width: parent.width - 10
                height: parent.height - 10
                color: "#2f3e47"
                anchors{
                    centerIn: parent
                }

                Text {
                    id: preferences
                    text: "Settings"
                    width: parent.width - 20
                    font.pixelSize: 15
                    font.family: "Eurostile"
                    font.bold: true
                    color: "white"
                    anchors{
                        top:parent.top
                        topMargin: 5
                        left:parent.left
                        leftMargin: 10
                    }

                }

                Text {
                    id: unitssettingsLabel
                    text: "Units:"
                    font.pixelSize: 14
                    font.family: "Eurostile"
                    color: "#c8c8c8"
                    anchors{
                        top:preferences.bottom
                        topMargin: 5
                        left:parent.left
                        leftMargin: 10
                    }
                }

                Text {
                    id:unitsstettingsText
                    text: scanner.s_units
                    font.pixelSize: 14
                    font.family: "Eurostile"
                    font.bold: true
                    color: "white"
                    anchors{
                        top:preferences.bottom
                        topMargin: 5
                        left: unitssettingsLabel.right
                        leftMargin: 10
                    }
                }

                Text {
                    id: namesettingsLabel
                    text: "Name:"
                    font.pixelSize: 14
                    font.family: "Eurostile"
                    color: "#c8c8c8"
                    anchors{
                        top:unitssettingsLabel.bottom
                        topMargin: 5
                        left:parent.left
                        leftMargin: 10
                    }
                }

                Text {
                    id:namesettingsText
                    text: scanner.s_name
                    font.pixelSize: 14
                    font.family: "Eurostile"
                    font.bold: true
                    color: "white"
                    anchors{
                        top:unitssettingsLabel.bottom
                        topMargin: 5
                        left: unitssettingsLabel.right
                        leftMargin: 10
                    }
                }

                Text {
                    id: weightsettingsLabel
                    text: "Weight:"
                    font.pixelSize: 14
                    font.family: "Eurostile"
                    color: "#c8c8c8"
                    anchors{
                        top:namesettingsText.bottom
                        topMargin: 5
                        left:parent.left
                        leftMargin: 10
                    }
                }

                Text {
                    id:weightsettingsText
                    text: scanner.s_actualweight + " " + scanner.s_units
                    font.pixelSize: 14
                    font.family: "Eurostile"
                    font.bold: true
                    color: "white"
                    anchors{
                        top:namesettingsText.bottom
                        topMargin: 5
                        left: weightsettingsLabel.right
                        leftMargin: 10
                    }
                }



            }

        }

    } // end of id:controlsRectangle

    Rectangle {
        id:heatmapRectangle
        width:rectangleBox.width + 180 + 200
        height:rectangleBox.height + 20
        anchors{
            left:parent.left
            top:parent.top
            margins:20
        }
        color: "#2f3e47"
//        color: "white"

        Rectangle{
            id:rectangleBox
            width: 340
            height: 340
            color: "#0f0e0e"
            anchors{
                bottom:parent.bottom
                bottomMargin: 10
                left:parent.left
                leftMargin: 10
            }

            Heatmap{
                id:hm
                //width:rectangleBox.width
                //height:rectangleBox.height
                width:parent.width
                height:parent.height
                anchors.centerIn: parent
            }
        }


        Rectangle{
            id:heatmapSidebar
            //width: parent.width - 370
            //height: parent.height - 20
            //width: 160
            width: heatmapRectangle.width - hm.width
            height: parent.height - 20

            color: "#243037"

            anchors{
                bottom: parent.bottom
                bottomMargin: 10
                right: parent.right
                rightMargin: 10
            }

            Text {
                id: serialLabel
                text: "Model/Serial:"
                font.pixelSize: 14
                font.family: "Eurostile"
                color: "#c8c8c8"
                anchors{
                    top:parent.top
                    topMargin: 10
                    left:parent.left
                    leftMargin: 10
                }
            }

            Text {
                id:serialText
                text: scanner.serial
                font.pixelSize: 14
                font.family: "Eurostile"
                font.bold: true
                color: "white"
                anchors{
                    top:serialLabel.bottom
                    topMargin: 5
                    left: parent.left
                    leftMargin: 10
                }
            }

            Text {
                id: maximumPressureLabel
                text: "Maximum Pressure:"
                font.pixelSize: 14
                font.family: "Eurostile"
                color: "#c8c8c8"
                anchors{
                    top:serialText.bottom
                    topMargin: 5
                    left:parent.left
                    leftMargin: 10
                }
            }

            Text {
                id:maximumPressureText
                text: scanner.max.toFixed(0) + " " + scanner.unit
                font.pixelSize: 14
                font.family: "Eurostile"
                font.bold: true
                color: "white"
                anchors{
                    top:maximumPressureLabel.bottom
                    topMargin: 5
                    left: parent.left
                    leftMargin: 10
                }
            }

            Text {
                id: averagePressureLabel
                text: "Average Pressure:"
                font.pixelSize: 14
                font.family: "Eurostile"
                color: "#c8c8c8"
                anchors{
                    top:maximumPressureText.bottom
                    topMargin: 5
                    left:parent.left
                    leftMargin: 10
                }
            }

            Text {
                id:averagePressureText
                text: scanner.ave.toFixed(0) + " " + scanner.unit
                font.pixelSize: 14
                font.family: "Eurostile"
                font.bold: true
                color: "white"
                anchors{
                    top:averagePressureLabel.bottom
                    topMargin: 5
                    left: parent.left
                    leftMargin: 10
                }
            }


            Text {
                id: sensingAreaLabel
                text: "Sensing Area:"
                font.pixelSize: 14
                font.family: "Eurostile"
                color: "#c8c8c8"
                anchors{
                    top:averagePressureText.bottom
                    topMargin: 5
                    left:parent.left
                    leftMargin: 10
                }
            }

            Text {
                id:sensingAreaText
                textFormat: Text.RichText
                text: scanner.area.toFixed(0) + " " + "mm<sup>2</<sup>"
                font.pixelSize: 14
                font.family: "Eurostile"
                font.bold: true
                color: "white"
                anchors{
                    top:sensingAreaLabel.bottom
                    topMargin: 5
                    left: parent.left
                    leftMargin: 10
                }
            }


        }//end of heatmapSidebar


    }//end of id:heatmapRectangle


    Rectangle {
        id:graphRectangle
        width:heatmapRectangle.width
        height:190
        anchors{
            left:parent.left
            bottom:parent.bottom
            margins:20
        }
        color: "#2f3e47"



        ChartView {
          //  title: "Line"
            id:mylinegraph
            anchors.fill: parent
            antialiasing: true
            legend.visible: false

            backgroundColor : "white"
            theme:ChartView.ChartThemeLight

            ValueAxis {
                id: yAxis
                min: -30
                max: 30
                minorTickCount: 4
                tickCount: 5
            }
            ValueAxis {
                id: xAxis
                min: 0
                max: 20
                minorTickCount: 5
                tickCount: 6
            }

            LineSeries {
                id:percentDifferenceSeries
                name: "% Difference"
                axisX: xAxis
                axisY: yAxis

                property  XYSeries series



            }

            LineSeries {
                name: "Actual Weight"
                axisX: xAxis
                axisY: yAxis
                color:"red"

                XYPoint { x: 0; y: 10 }
                XYPoint { x: 1; y: 10 }
                XYPoint { x: 2; y: 10 }
                XYPoint { x: 3; y: 10 }
                XYPoint { x: 4; y: 10 }
                XYPoint { x: 5; y: 10 }
                XYPoint { x: 6; y: 10 }
                XYPoint { x: 7; y: 10 }
                XYPoint { x: 8; y: 10 }
                XYPoint { x: 9; y: 10 }
                XYPoint { x: 10; y: 10 }
                XYPoint { x: 11; y: 10 }
                XYPoint { x: 12; y: 10 }
                XYPoint { x: 13; y: 10 }
                XYPoint { x: 14; y: 10 }
                XYPoint { x: 15; y: 10 }
                XYPoint { x: 16; y: 10 }
                XYPoint { x: 17; y: 10 }
                XYPoint { x: 18; y: 10 }
                XYPoint { x: 19; y: 10 }
                XYPoint { x: 20; y: 10 }

            }


            LineSeries {
                name: "Actual Weight"
                axisX: xAxis
                axisY: yAxis
                color:"red"

                XYPoint { x: 0; y: -10 }
                XYPoint { x: 1; y: -10 }
                XYPoint { x: 2; y: -10 }
                XYPoint { x: 3; y: -10 }
                XYPoint { x: 4; y: -10 }
                XYPoint { x: 5; y: -10 }
                XYPoint { x: 6; y: -10 }
                XYPoint { x: 7; y: -10 }
                XYPoint { x: 8; y: -10 }
                XYPoint { x: 9; y: -10 }
                XYPoint { x: 10; y: -10 }
                XYPoint { x: 11; y: -10 }
                XYPoint { x: 12; y: -10 }
                XYPoint { x: 13; y: -10 }
                XYPoint { x: 14; y: -10 }
                XYPoint { x: 15; y: -10 }
                XYPoint { x: 16; y: -10 }
                XYPoint { x: 17; y: -10 }
                XYPoint { x: 18; y: -10 }
                XYPoint { x: 19; y: -10 }
                XYPoint { x: 20; y: -10 }

            }


        }//end of chartview

        Text{
            id:graphtitleText
            text: "Percent Difference"
            font.pixelSize: 16
            font.family: "Eurostile"
            font.bold: true
            color: "#1994b3"
            anchors{
                top:parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }

    }


    //Added May 6, 2018
        Connections {
            id: dialogConnection
            property string units
            property string name
            property double weight

            onVisibleChanged: {
                if(!target.visible){
              //      console.log(target.r_units);
                    scanner.s_units = target.r_units;
              //      console.log(target.r_name);
                    scanner.s_name = target.r_name;
               //     console.log(target.r_actualweight);
                    scanner.s_actualweight = target.r_actualweight;
               //     console.log(target.err);
                    //connectvar = target.returnValue;
                    if(target.err){
                      //  calibrator.message = target.err;
                    }
                }

            }

            onClosing:{
             //   console.log("CLOSE NA PO AKO");
                scanner.stopClicked();
                stopButton.enabled = false;
                startButton.enabled=true;
                settingsButton.enabled=true;
            }


            Component.onCompleted: readfile();

            function readfile(){
                var st = FileIO.read("bw.conf");
                var new_arr = st.split('/');
                scanner.s_units = new_arr[0].split('=')[1];
            //    console.log(scanner.s_units);
                scanner.s_name = new_arr[1].split('=')[1];
            //    console.log(scanner.s_name);
                scanner.s_actualweight = new_arr[2].split('=')[1];
           //     console.log(scanner.s_actualweight);

            }

        }//end of Connections



}
