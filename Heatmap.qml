import QtQuick 2.0
import "js/data.js" as Mydata

Item {
    id: id_root
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    property bool start:false
//    property real _r:width/numrows
    property real _r:hticks
    property real _opac:0.05
    property var values
    property int numrows:0
    property int numcolumns:0
    property real sizematwidth:0
    property real sizematheight:0
    property real maximum:0
    property real hticks:(width)/numcolumns
    //property real vticks:(height-20)/numrows
    property real vticks:hticks
    property bool cu:false
    property bool cd:true



    Canvas{
        id:gradientCanvas

        width:1
        height:256

        property var grad
        //property var defaultGradient: {0.15: 'white', 0.4: 'blue', 0.6: 'cyan', 0.7: 'lime', 0.8: 'yellow', 1.0: 'red'}
        property var defaultGradient: {0: 'white',0.15: 'white', 0.4: 'blue', 0.6: 'cyan', 0.7: 'lime', 0.8: 'yellow', 1.0: 'red'}

        onPaint: {
            var ctx2 = getContext('2d');
            ctx2.clearRect(0, 0, width, height);


        }
/*                 var gradient = ctx2.createLinearGradient(0, 0, 0, 256);


             for (var i in defaultGradient) {
                 gradient.addColorStop(+i, defaultGradient[i]);
             }

             ctx2.fillStyle = gradient;
             ctx2.fillRect(0, 0, 1, 256);

             grad = ctx2.getImageData(0, 0, 1, 256);

           // ctx2.clearRect(0, 0, width, height);

        }
*/
    }//end of id:gradientCanvas

    Canvas{
        id:circleCanvas
        property real blur:id_root._r * 0.8
        property real radius:id_root._r
        property real r2: radius + blur
        width:r2 * 2
        height:width

        property var cir
        property real opac:id_root._opac

        onRadiusChanged: {
            //console.log("onRadiusChange");
            requestPaint();
        }

        onOpacChanged: {
           // console.log("onOpacityChanged");
            //requestPaint();
        }

        onPaint: {

            var ctx2 = getContext('2d');
            ctx2.clearRect(0, 0, width, height);

            ctx2.shadowOffsetX = ctx2.shadowOffsetY = r2 * 2;
            ctx2.shadowBlur = blur;
            ctx2.shadowColor = 'black';

            ctx2.beginPath();
            ctx2.arc(-r2, -r2, radius, 0, Math.PI * 2, true);
            ctx2.closePath();
            ctx2.fill();
          //  console.log(opac);

            cir = ctx2.getImageData(0, 0, width, height);


            ctx2.clearRect(0, 0, width, height);

        }

    }//end of id:circleCanvas

    Canvas{
        id:mainCanvas
        anchors.centerIn: parent
         width:id_root.hticks * id_root.numrows
         height:id_root.vticks * id_root.numcolumns
//        width:parent.width - 20
//        height:parent.height - 20
        property real minOpacity:0.05
        property real max:id_root.maximum
        property var _circle:circleCanvas
        property bool start: id_root.start
        property var val: id_root.values
        property bool cup:id_root.cu
        property bool cdown: id_root.cd


        property int rows:numrows
        property int columns:numcolumns
    //    property int width:455
    //    property int length:455

         Rectangle{
             id:cableup
             visible:false
             width:10
             height:10
             anchors{
                 top: parent.top
                 topMargin: 10
                 left:parent.left
                 leftMargin: -10
             }
             color:"black"
         }

        Rectangle{
            id:cabledown
            visible:true
            width:10
            height:10
            anchors{
                bottom: parent.bottom
                bottomMargin: -10
                left:parent.left
                leftMargin: 10
            }
            color:"black"
        }

        onWidthChanged: {
            requestPaint();
        }


        onValChanged: {
            requestPaint();
        }

        onStartChanged: {
           // console.log("onStartChanged");
           // requestPaint();
        }

        onPaint: {

            if(id_root.numcolumns == id_root.numrows){
                cabledown.visible=true;
                cableup.visible=false;
            }else{
                cabledown.visible=false;
                cableup.visible=true;
            }



             var ctx3 = gradientCanvas.getContext("2d");

             var gradient = ctx3.createLinearGradient(0, 0, 0, 256);
             for (var y in gradientCanvas.defaultGradient) {
                 gradient.addColorStop(+y, gradientCanvas.defaultGradient[y]);
             }

             ctx3.fillStyle = gradient;
             ctx3.fillRect(0, 0, 1, 256);

             var grad = ctx3.getImageData(0, 0, 1, 256);
             ctx3.clearRect(0, 0, 1, 256);
             ctx3.reset();
             gradientCanvas.requestPaint();
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
             ctx.reset();
 //            ctx.font = "bold 9px sans-serif";
 //            ctx.fillStyle = "white";
/*
            for (var i = 0, len = Mydata.data.length, p; i < len; i++) {
                p = Mydata.data[i];
                ctx.globalAlpha = Math.min(Math.max(p[2] / max, minOpacity === undefined ? 0.05 : minOpacity), 1);
                ctx.drawImage(circleCanvas.cir, p[0] - circleCanvas.r2, p[1] - circleCanvas.r2);
            }
*/
if(id_root.numcolumns == id_root.numrows){
            for (var i = 0, len = val.length; i < len; i++) {
                var x2 = ((i % id_root.numcolumns)*gridCanvas.h_ticks)+(gridCanvas.h_ticks/2);
                var y2 = (Math.floor(i/id_root.numrows))*gridCanvas.v_ticks + gridCanvas.v_ticks/2;

                ctx.globalAlpha = Math.min(Math.max(val[i] / max, minOpacity === undefined ? 0.05 : minOpacity), 1);
                ctx.drawImage(circleCanvas.cir, x2 - circleCanvas.width/2, y2 - circleCanvas.height/2);
            }
}else{
    //console.log("ARAY KO");
    //console.log("width:" + width);
    //console.log("height:" + height);

                for (var j2 = 0, le = val.length; j2 < le; j2++) {
                    var y3 = ((j2 % id_root.numcolumns)*id_root.vticks)+(id_root.vticks/2);
                    var x3 = width - ((Math.floor(j2/id_root.numcolumns))*id_root.hticks);
//console.log("x3:" + x3);
//console.log("counter:" + j2);
                    ctx.globalAlpha = Math.min(Math.max(val[j2] / max, minOpacity === undefined ? 0.05 : minOpacity), 1);
                    ctx.drawImage(circleCanvas.cir, x3 - circleCanvas.width/2, y3 - circleCanvas.height/2);
                }
}

            var colored = ctx.getImageData(0, 0, width, height);


            for (var i2 = 0, len2 = colored.data.length, j; i2 < len2; i2 += 4) {
                j = colored.data[i2 + 3]; // get gradient color from opacity value

                if (j) {
                    colored.data[i2] = grad.data[j*4];
                    colored.data[i2 + 1] = grad.data[j*4 + 1];
                    colored.data[i2 + 2] = grad.data[j*4 + 2];
                    colored.data[i2 + 3] = 255;
                }
            }
            ctx.globalAlpha=1;

            ctx.drawImage(colored, 0, 0);




        }//end of onPaint:

        onPainted: {
            scanner.toggle = !scanner.toggle;
        }


    }//end of id:mainCanvas


    Canvas{
        id:gridCanvas

       width:id_root.hticks * id_root.numrows
        height:id_root.vticks * id_root.numcolumns
        anchors.centerIn: parent
       // width:height
        property var val: id_root.values


        /*
        property double h_ticks: id_root.width/(id_root.numcolumns + 1)
        property double v_ticks: id_root.height/(id_root.numrows + 1)
        */
        property double h_ticks: id_root.hticks
        property double v_ticks: id_root.vticks

        onValChanged: {
   //         requestPaint();
        }

        onPaint: {
//            console.log("width: " + width);
//            console.log("height: " + height);
//            console.log("hticks: " + id_root.hticks);
//            console.log("vticks: " + id_root.vticks);
            var ctx = getContext('2d');
            ctx.clearRect(0, 0, width, height);
            ctx.lineWidth = 1;
            ctx.strokeStyle = "#0f0e0e"
            //ctx.strokeStyle = "white";
            ctx.globalAlpha=0.1;
//vertical lines
            for(var i=0; i<=id_root.numrows ; i++){
                ctx.beginPath();
                ctx.moveTo(i*h_ticks,0);
                ctx.lineTo(i*h_ticks,v_ticks*id_root.numcolumns);
                ctx.stroke();
            }
            /*
            ctx.beginPath();
            ctx.moveTo(width,0);
            ctx.lineTo(width,height);
            ctx.stroke();
            */
//horizontal lines
            for(var j=0; j<=id_root.numcolumns ; j++){
                ctx.beginPath();
                ctx.moveTo(0,j*v_ticks);
                ctx.lineTo(h_ticks*id_root.numrows,j*v_ticks);
                ctx.stroke();
            }
            /*
            ctx.beginPath();
            ctx.moveTo(0,height);
            ctx.lineTo(width,height);
            ctx.stroke();
            */



        //   ctx.rotate(Math.PI/3);
          //  ctx.drawImage(c, 0, 0);




          //  ctx.restore();

/*
            for (var d = 0, len = val.length; d < len; d++) {
                var x2 = ((d % id_root.numcolumns)*h_ticks)+(h_ticks/2);
                var y2 = (Math.floor(d/id_root.numrows))*h_ticks + h_ticks/2;

                ctx.fillText(val[d], x2-h_ticks/4, y2+v_ticks/4);
                ctx.stroke();
            }
*/
        }

    }//end of gridCanvas

    Canvas{
        id:valuesCanvas

        width:id_root.hticks * id_root.numrows
         height:id_root.vticks * id_root.numcolumns
         anchors.centerIn: parent
        property var val: id_root.values

        onValChanged: {
            requestPaint();
        }

        onPaint: {
           // console.log(val[0]);
            var ctx = getContext('2d');
            ctx.reset();
            ctx.clearRect(0, 0, width, height);

            ctx.lineWidth = 1;
            ctx.strokeStyle = "#0f0e0e"
            ctx.globalAlpha=0.7;
if(id_root.numcolumns == id_root.numrows){
            for (var d = 0, len = val.length; d < len; d++) {
                var x2 = ((d % id_root.numcolumns)*gridCanvas.h_ticks)+(gridCanvas.h_ticks/2);
                var y2 = (Math.floor(d/id_root.numrows))*gridCanvas.v_ticks + gridCanvas.v_ticks/2;

                  ctx.fillText(val[d], x2-gridCanvas.h_ticks/8, y2+gridCanvas.v_ticks/8);

            }
}else{
    //console.log("ARAY KO");
    //console.log("width:" + width);
    //console.log("height:" + height);

                for (var j2 = 0, le = val.length; j2 < le; j2++) {
                    var y3 = ((j2 % id_root.numcolumns)*id_root.vticks)+(id_root.vticks/2);
                    var x3 = width - ((Math.floor(j2/id_root.numcolumns))*id_root.hticks);
//console.log("x3:" + x3);
//console.log("counter:" + j2);
                    ctx.fillText(val[j2], x3-id_root.hticks/2, y3+id_root.vticks/4);

                }
}

        }

    }//end of valuesCanvas

}

