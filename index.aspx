<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style>
</style>
    <script src="js/WebRTC.js"></script>
    <script>
        //check for the existence of navigator.getUserMedia
        if (hasGetUserMedia()) {
            navigator.getMedia = navigator.getUserMedia ||
                           navigator.webkitGetUserMedia ||
                           navigator.mozGetUserMedia ||
                           navigator.msGetUserMedia;
        } else {
            alert('getUserMedia() is not supported in your browser');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
        <video autoplay></video>
        <img src="">
        <canvas style="display:none;" width="640" height="480"></canvas>

        <script>
            var video = document.querySelector('video');
            var canvas = document.querySelector('canvas');
            var ctx = canvas.getContext('2d');
            var localMediaStream = null;
            video.addEventListener('click', snapshot, false);

            function snapshot() {
                if (localMediaStream) {
                    ctx.drawImage(video, 0, 0);
                    // "image/webp" works in Chrome.
                    // Other browsers will fall back to image/png.
                    document.querySelector('img').src = canvas.toDataURL('image/webp');
                }
            }
            MediaStreamTrack.getSources(function (sourceInfos) {
                var audioSource = null;
                var videoSource = null;

                for (var i = 0; i != sourceInfos.length; ++i) {
                    var sourceInfo = sourceInfos[i];
                    if (sourceInfo.kind === 'audio') {
                        console.log(sourceInfo.id, sourceInfo.label || 'microphone');

                        audioSource = sourceInfo.id;
                    } else if (sourceInfo.kind === 'video') {
                        console.log(sourceInfo.id, sourceInfo.label || 'camera');

                        videoSource = sourceInfo.id;
                    } else {
                        console.log('Some other kind of source: ', sourceInfo);
                    }
                }

                sourceSelected(audioSource, videoSource);
            });

            

            function sourceSelected(audioSource, videoSource) {
                var constraints = {
                    audio: {
                        optional: [{ sourceId: audioSource }]
                    },
                    video: {
                        optional: [{ sourceId: videoSource }]
                    }
                };

                navigator.getMedia(
                // constraints
                constraints,

                // successCallback
                function (Stream) {
                    video.src = window.URL.createObjectURL(Stream);
                    localMediaStream = Stream;
                    video.onloadedmetadata = function (e) {
                        // Do something with the video here.
                    };
                },

                // errorCallback
                function (err) {
                    console.log("The following error occured: " + err);
                }
           );
            }
            
        </script>
    </form>
</body>
</html>
