<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm2.aspx.vb" Inherits="WebApplication1.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <button id="start-recognition">Hold This Button and Speak</button>
<button id="play">Play Recorded Audio</button>
<h1 id="output">Voice over here</h1>


<%--<button id="requestAnimationFrame">requestAnimationFrame</button>
<button id="cancelAnimationFrame">cancelAnimationFrame</button>--%>


<%--<button id="playMovie">playMovie</button>

<video id="player" controls="" autoplay="" name="media"><source src="https://cdn.plyr.io/static/demo/View_From_A_Blue_Moon_Trailer-576p.mp4" type="video/mp4"></video>--%>

        <script>
            let audioChunks = [];
            let rec;
            let stopRecognize;
            const output = document.getElementById('output');
            document.head.insertAdjacentHTML('beforeend', '<audio id="recordedAudio" crossorigin="anonymous"></audio>');


            navigator.mediaDevices.getUserMedia({ audio: true })
                .then(stream => {
                    rec = new MediaRecorder(stream);
                    rec.ondataavailable = e => {
                        audioChunks.push(e.data);
                        if (rec.state == "inactive") {
                            blob = new Blob(audioChunks, { type: 'audio/x-mpeg-3' });
                            recordedAudio.src = URL.createObjectURL(blob);
                        }
                    }
                    recorderSupport = true;
                    recordPermissions.allowed = true;
                    recordPermissions.mic = true;
                }).catch(err => {
                    recorderSupport = false;
                    switch (err.name) {
                        case 'NotAllowedError':
                            console.log('User denied the Permission to record!');
                            recordPermissions.allowed = false;
                            recordPermissions.mic = true;
                            break;
                        default:
                            console.log('No Mic Connected' + err.name);
                            recordPermissions.mic = false;
                            break;
                    }
                });


            async function Recognize() {
                console.log('Recognize')
                let recognitionAllowed = true;
                stopRecognize = function () {
                    if (recognitionAllowed) {
                        recognition.stop();
                        recognitionAllowed = false;
                    }
                }

                var SpeechRecognition = SpeechRecognition || webkitSpeechRecognition;
                var SpeechGrammarList = SpeechGrammarList || webkitSpeechGrammarList;
                var SpeechRecognitionEvent = SpeechRecognitionEvent || webkitSpeechRecognitionEvent;
                var recognition = new SpeechRecognition();
                var speechRecognitionList = new SpeechGrammarList();
                recognition.grammars = speechRecognitionList;
                recognition.lang = 'en-GB';
                recognition.continuous = false;
                recognition.interimResults = true;
                recognition.maxAlternatives = 1;
                recognition.start();

                recognition.onresult = function (event) {
                    window.interim_transcript = '';
                    window.speechResult = '';
                    for (var i = event.resultIndex; i < event.results.length; ++i) {
                        if (event.results[i].isFinal) {
                            speechResult += event.results[i][0].transcript;
                            console.log(speechResult);
                            output.innerHTML = speechResult;
                        } else {
                            interim_transcript += event.results[i][0].transcript;
                            console.log(interim_transcript);
                            output.innerHTML = interim_transcript;
                        }
                    }
                }

                recognition.onerror = function (event) {
                    // restartRecognition();
                    console.log('recognition error: ' + event.error);
                }

                recognition.onend = async function (event) {
                    restartRecognition();
                }

                function restartRecognition() {
                    try { if (recognitionAllowed) recognition.start(); } catch (err) { }
                }

            }






            const startRecognition = document.getElementById('start-recognition');
            startRecognition.addEventListener('mousedown', handleRecognitionStart);
            startRecognition.addEventListener('mouseup', handleRecognitionEnd);
            startRecognition.addEventListener('touchstart', handleRecognitionStart);
            startRecognition.addEventListener('touchend', handleRecognitionEnd);

            function handleRecognitionStart(e) {
                console.log('handleRecognitionStart', isTouchDevice)
                const event = e.type;
                if (isTouchDevice && event == 'touchstart') {
                    recognitionStart();
                } else if (!isTouchDevice && event == 'mousedown') {
                    console.log('handleRecognitionStart')
                    recognitionStart();
                }
            }
            const isTouchDevice = touchCheck();

            function touchCheck() {
                const maxTouchPoints = navigator.maxTouchPoints || navigator.msMaxTouchPoints;
                return 'ontouchstart' in window || maxTouchPoints > 0 || window.matchMedia && matchMedia('(any-pointer: coarse)').matches;
            }


            function handleRecognitionEnd(e) {
                const event = e.type;
                console.log(':::', event == 'touchend');
                if (isTouchDevice && event == 'touchend') {
                    recognitionEnd();
                } else if (!isTouchDevice && event == 'mouseup') {
                    recognitionEnd();
                }
            }

            function recognitionEnd() {
                resetRecognition();
            }

            function recognitionStart() {
                console.log('recognitionStart')
                Recognize();
                audioChunks = [];
                if (rec.state !== 'recording') rec.start();
            }

            function resetRecognition() {
                console.log('reset')
                if (typeof stopRecognize == "function") stopRecognize();
                if (rec.state !== 'inactive') rec.stop();
            }

            const playAudio = document.getElementById('play');

            playAudio.addEventListener('click', () => {
                console.log('play');
                const recordedAudio = document.getElementById('recordedAudio');
                const playPromise = recordedAudio.play();
            })


            let reqAnimationFrame

            document.getElementById('requestAnimationFrame').addEventListener('click', () => {
                console.log('requestAnimationFrame');
                reqAnimationFrame = window.requestAnimationFrame(stepRevision);
            });

            let step = 0;
            function stepRevision() {
                step++;
                console.log(step);
                reqAnimationFrame = window.requestAnimationFrame(stepRevision);
            }


            document.getElementById('cancelAnimationFrame').addEventListener('click', () => {
                console.log('cancelAnimationFrame');
                reqAnimationFrame = window.requestAnimationFrame(cancelstepRevision);
            });

            function cancelstepRevision() {
                console.log('cancelstepRevision');
                window.cancelAnimationFrame(reqAnimationFrame);
                step = 0;
            }


            document.getElementById('playMovie').addEventListener('click', async () => {
                console.log('playMovie');
                await MediaPlay({ start: '0:17.192', end: '0:28.192' }, 1);
                console.log('movie stoped');
            });

            async function MediaPlay({ start, end }, speed = 1, format = true) {

                start = start == -1 ? -1 : getSecondsDuration('0:12.192', start);
                end = end == -1 ? -1 : getSecondsDuration('0:12.192', end);
                await Video({ start, end }, speed);
            }

            function getSecondsDuration(start, end) {
                const milisecondsDiff = (hrsToSecs(end) * 1000) - (hrsToSecs(start) * 1000);
                return milisecondsDiff / 1000;
            }

            function hrsToSecs(hrs) {
                var b = hrs.split(':');
                return b.length > 2 ? b[0] * 3600 + b[1] * 60 + +b[2] : b[0] * 60 + +b[1];
            }
            function secsToHrs(secs) {
                var z = n => (n < 10 ? '0' : '') + n;
                return (secs / 3600 | 0) + ':' +
                    z(secs % 3600 / 60 | 0) + ':' +
                    z(secs % 60);
            }

            let movieSkipedTimeout;

            function Video(duration, speed) {

                console.log('Video:', duration, speed)

                return new Promise((resolve, reject) => {

                    rejectMediaPlayer = () => { reject(); }
                    const player = document.getElementById('player');
                    videoTrackBlock = false;
                    player.playbackRate = speed;
                    if (duration.end != -1) duration.end = duration.end - 0.080;

                    console.log('Video1:', duration, speed)

                    const start = duration.start;
                    const end = duration.end;
                    player.currentTime = start;
                    Track(end);
                    Start(start);

                    function Track(end) {
                        const startCheck = (((end - player.currentTime) * (1 / player.playbackRate)) - 0.25) * 1000;
                        const delay = Math.sign(startCheck) === -1 ? 0 : startCheck;
                        clearTimeout(movieSkipedTimeout);
                        movieSkipedTimeout = setTimeout(() => {
                            const updatedFrame = (now, metadata) => {
                                if (videoTrackBlock) return;
                                if (metadata.mediaTime >= end) return Stop();
                                player.requestVideoFrameCallback(updatedFrame);
                            }
                            player.requestVideoFrameCallback(updatedFrame);
                        }, delay);
                    }

                    function Start(start, fade = false) {
                        player.volume = 1;
                        player.play();
                        console.log('play')
                    }

                    function Stop() {
                        // player.pause();
                        // return resolve();
                        let volumeValue = player.volume;
                        const stopCheck = setInterval(stopCheckInterval, 5);
                        function stopCheckInterval() {
                            player.volume = Math.max(volumeValue -= 0.5, 0);
                            if (player.volume === 0) {
                                clearInterval(stopCheck);
                                player.pause();
                                resolve();
                            }
                        }
                    }

                });

            } // end of Movie function
        </script>
    </form>
</body>
</html>
