import QtQuick 2.0
import "js/data.js" as Mydata

Item {
    id: id_root
    property bool start:false





    Canvas{
        id:mainCanvas
        width:1000
        height:600
        property double defaultRadius: 25
        property var defaultGradient: {0.4: 'blue', 0.6: 'cyan', 0.7: 'lime', 0.8: 'yellow', 1.0: 'red'}
        property var _data

        property bool s:id_root.start

        property double _maximum:6
        property var _circle:radiusCanvas
        property int _r:10
        property var _grad:gradientCanvas
        property real minOpacity:0.05

        onSChanged: {
            //console.log(_grad);
            requestPaint();
        }

        onPaint:{
            //console.log(_circle);
            //if (!mainCanvas._circle) this.radius(this.defaultRadius);
            //if (!mainCanvas._grad) this.gradient(this.defaultGradient);
            //console.log(Mydata.data);
            //var ctx = this._ctx;

            var ctx2 = gradientCanvas.getContext("2d");
            var gradient = ctx2.createLinearGradient(0, 0, 0, 256);

            for (var i in mainCanvas.defaultGradient) {
                gradient.addColorStop(+i, mainCanvas.defaultGradient[i]);
            }

            ctx2.fillStyle = gradient;
            ctx2.fillRect(0, 0, 1, 256);
            var col = ctx2.getImageData(0, 0, 1, 256);
                console.log(col.data.length);
            var pix = col.data;
            for(var x=0; x < pix.length; x++){
   //             console.log(pix[x]);
            }



            var ctx = getContext("2d");
            //console.log(ctx);


            ctx.clearRect(0, 0, width, height);

            // draw a grayscale heatmap by putting a blurred circle at each data point
            for (var i = 0, len = Mydata.data.length, p; i < len; i++) {
                p = Mydata.data[i];
                ctx.globalAlpha = Math.min(Math.max(p[2] / _maximum, minOpacity === undefined ? 0.05 : minOpacity), 1);
                ctx.drawImage(_circle, p[0] - _r, p[1] - _r);
                var colored = ctx.getImageData(p[0] - _r, p[1] - _r, radiusCanvas.width, radiusCanvas.height);
                     console.log(colored.data.length);
                      var pixels = colored.data;
                for (var c = 0; c < pixels.length; c += 4) {
                    var j = pixels[c + 3] * 4; // get gradient color from opacity value
                    if (j) {
    //                    console.log(pixels[j]);
    //                    console.log(j);
                        console.log(pix[j]);
                        console.log(pix[j + 1]);
                        console.log(pix[j + 2]);
                        colored.data[c] = pix[j];
                        colored.data[c + 1] = pix[j + 1];
                        colored.data[c + 2] = pix[j + 2];

                    }
                }
                ctx.putImageData(colored, p[0] - _r, p[1] - _r);


            }

            // colorize the heatmap, using opacity value of each pixel to get the right color from our gradient
          //  var colored = ctx.getImageData(0, 0, mainCanvas.width, mainCanvas.height);
          //  var pixels = colored.data;
           // var l = pixels.length;

            var j;
            //for (var c = 0; c < l; c += 4) {
             //   j = pixels[c + 3] * 4; // get gradient color from opacity value


              //  if (j) {
                //    console.log(_grad[j+1]);
                    //console.log("hello");
                    //pixels[c] = gradientCanvas.gr[j];
                    //pixels[c + 1] = gradientCanvas.gr[j + 1];
                    //pixels[c + 2] = gradientCanvas.gr[j + 2];

             //   }
            //}

    //        ctx.putImageData(colored, 0, 0);
        }

        Canvas{
            id:gradientCanvas
            width: 1
            height: 256

            property double grad
            property bool a: id_root.start
            property var gr

            onPaint: {
                // Get drawing context
                console.log("TEST");
                var ctx = getContext("2d");
                var gradient = ctx.createLinearGradient(0, 0, 0, 256);

                for (var i in mainCanvas.defaultGradient) {
                    gradient.addColorStop(+i, mainCanvas.defaultGradient[i]);
                }

                ctx.fillStyle = gradient;
                ctx.fillRect(0, 0, 1, 256);

               radiusCanvas.g = ctx.getImageData(0, 0, 1, 256).data;

                //console.log(gr.length);
  //              for(var x=0; x < gr.length; x++){
  //                  console.log(gr[x]);
  //              }



                //console.log(mainCanvas._grad);

            }
        }//end of id:gradientCanvas

        Canvas{
            id:radiusCanvas
            property var g
            property int b:0
            property double blur: 15
            property double r:5
            property double r2:r + blur;

            width: r2*2
            height: width

            onPaint:  {
                // Get drawing context
                var ctx = getContext("2d");

                ctx.shadowOffsetX = ctx.shadowOffsetY = r2 * 2;
                ctx.shadowBlur = blur;
                ctx.shadowColor = 'black';

                ctx.beginPath();
                ctx.arc(-r2, -r2, r, 0, Math.PI * 2, true);
                ctx.closePath();
                ctx.fill();
            }
        }//end of id:radiusCanvas




    }//end of id:mainCanvas




}
