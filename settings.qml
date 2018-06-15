//import QtQuick 2.2
//import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtQuick 2.6
import QtQuick.Controls 2.1
//import QtQuick.Controls 1.4
import QtQuick.Controls 1.3 as QQC1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0


Window {
    id: mypopDialog
    title: "Settings"
    width: 300
    height: 300
    flags: Qt.Dialog
    modality: Qt.WindowModal
    color:"#243037"
/*
    Image {
        width: parent.width
        height: parent.height
        source: "/images/Background.png"
    }
*/
   // property int popupType: 1
   // property string returnValue: ""
    //property string radio_units
    property string r_units: "lbs"
    property string r_name
    property variant r_actualweight
    property string err:""

        Rectangle {
             id: innerRingRect
             height: parent.height - 40
             width: parent.width - 40
             anchors{
                 centerIn: parent
             }
             color:"#2f3e47"

             Text {
                 id:unitslabel
                 text: "Units:"
                 font.pixelSize: 13
                 font.bold: true
                 font.family: "Eurostile"
                 color: "gray"
                 anchors{
                     top: parent.top
                     topMargin: 20
                     left: parent.left
                     leftMargin: 30
                 }

             }


                   RadioButton {
                      id: lbsRadio
                      checked: true
                      text:lbs.text
                      anchors{
                          top:parent.top
                          topMargin: 10
                          left: unitslabel.right
                          leftMargin: 10
                      }

                      onClicked: {
                          r_units = this.text;
                          console.log(text);
                      }

                      Text {
                          id:lbs
                          text: "lbs"
                          font.pixelSize: 15
                          font.bold: true
                          font.family: "Eurostile"
                          color: "white"
                          anchors{
                             top: parent.top
                             topMargin: 10
                             left: lbsRadio.right
                             leftMargin: -5
                          }

                      }
                  }



                  RadioButton {
                      id:kgRadio
                      text: kg.text
                      anchors{
                          top:parent.top
                          topMargin: 10
                          left: unitslabel.right
                          leftMargin: 90
                      }
                      onClicked: {
                          r_units = this.text;
                          console.log(text);
                      }

                      Text {
                          id:kg
                          text: "kgs"
                          font.pixelSize: 15
                          font.bold: true
                          font.family: "Eurostile"
                          color: "white"
                          anchors{
                              top: parent.top
                              topMargin: 10
                              left: kgRadio.right
                              leftMargin: -5
                          }
                      }

                  }


                  Text{
                      id:namelabel
                      text: "Name:"
                      font.pixelSize: 13
                      font.bold: true
                      font.family: "Eurostile"
                      color: "gray"
                      anchors{
                          top: unitslabel.top
                          topMargin: 30
                          left: parent.left
                          leftMargin: 30
                      }


                  }

                  TextField {
                      id:name

                    //  implicitWidth: 50
                      font.pixelSize: 14
                      font.family: "Eurostile"
                      //implicitHeight: 40
                      placeholderText: qsTr("Enter your name:")
                      anchors{
                          top: namelabel.bottom
                          topMargin: 5
                          left: parent.left
                          leftMargin: 30
                      }

                  }


                  Text{
                      id:weightlabel
                      text: "Weight:"
                      font.pixelSize: 13
                      font.bold: true
                      font.family: "Eurostile"
                      anchors{
                          top: name.bottom
                          topMargin: 10
                          left: parent.left
                          leftMargin: 30
                      }
                      color: "gray"

                  }

                  TextField {
                      id:weight

                      //implicitWidth: 220
                      font.pixelSize: 14
                      font.family: "Eurostile"
                      //implicitHeight: 40
                      placeholderText: qsTr("Enter your weight")
                      anchors{
                          top: weightlabel.bottom
                          topMargin: 5
                          left: parent.left
                          leftMargin: 30
                      }
                  }


                 QQC1.Button {

                      style:  ButtonStyle {
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
                              text: "ACCEPT"
                              font.bold: true
                              font.family: "Helvetica"
                              horizontalAlignment: Text.AlignHCenter
                              verticalAlignment: Text.AlignVCenter

                              font.pointSize: 8
                              color: control.pressed ? "yellow" :"#def6e2"
                          }
                      }
                      anchors{
                          top: weight.bottom
                          topMargin: 10
                          left: parent.left
                          leftMargin: 100
                      }

                      onClicked: {
                          validate_values();
                          //FileIO.save(saveMe.text);
                          mypopDialog.close();
                      }
                  } //end of startButton


        }//end of Image




    function validate_values(){
        if(name.text != ''){
                r_name = name.text;
        }else{
            err = "Invalid name.";
        }

        if(weight.text != ''){
            if(!isNaN(weight.text)){
                r_actualweight = parseInt(weight.text);
            }else{
                err = "Invalid weight.";
            }
        }else{
            err = "Weight is required.";
        }


        var content = "units=" + r_units +"\r\n";
            content += "name=" + r_name +"\r\n";
            content += "actualweight=" + r_actualweight +"\r\n";
        FileIO.save(content);

    }


}


