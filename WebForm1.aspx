<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<!DOCTYPE html>
<html lang="en">
<head>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>

    <style>
        .container {
            display: flex;
            flex-direction: column;
            > *

        {
            margin: 8px;
        }

        }

        button {
            max-width: 300px;
        }
    </style>

    <style>
        {
            "container": "body", "height": 96, "splitChannels": false, "normalize": true, "waveColor": "#ffdd00", "progressColor": "#8f8f8f", "cursorColor": "#ddd5e9", "cursorWidth": 5, "barWidth": 5, "barGap": 2, "barRadius": 30, "barHeight": 0.5, "barAlign": "", "minPxPerSec": 1, "fillParent": true, "url": "/wavesurfer-code/examples/audio/audio.wav", "media":

        {
        }

        ,
        "autoplay": false,
        "interact": true,
        "hideScrollbar": false,
        "audioRate": 1,
        "autoScroll": true,
        "autoCenter": true,
        "sampleRate": 8000
        }
    </style>


</head>
<body runat="server">
    <form runat="server">

        <div class="container">
            <h1>VOICE RECORDING by Eghbaldar.ir</h1>
            <audio id="recorder" muted hidden></audio>
            <div>

                <div>
                <img src="img/ic_record.png" style="cursor: pointer;" onclick="StatusRec()" width="50" id="start" />
                <img src="img/ic_stop.gif" onclick="StatusRec()" style="display: none; cursor: pointer;" width="50" id="stop" />
                <div id="countup">
                    <span id="minutes"></span>
                    <span id="seconds"></span>
                </div>
                    </div>

            </div>
        </div>

        <asp:GridView ID="GridViewVocies" runat="server" Width="100%" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Name" ItemStyle-Width="150" />
                <asp:BoundField DataField="Play" HeaderText="Play" ItemStyle-Width="150" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <div id='<%# String.Format("div_{0}", Eval("Name")) %>'>
                        </div>
                        <div id='<%# String.Format("divPlayPause_{0}", Eval("Name")) %>'>
                            Play
                        </div>
                        <script type="module">

                            import WaveSurfer from 'https://unpkg.com/wavesurfer.js@7/dist/wavesurfer.esm.js'

                            var file = '/voices/' + '<%#String.Format("{0}.mp3", Eval("Name")) %>';

                            const wavesurfer = WaveSurfer.create({
                                container: '<%# String.Format("#div_{0}", Eval("Name")) %>',
                                "height": 96,
                                "splitChannels": false,
                                "normalize": true,
                                "waveColor": "#ffdd00",
                                "progressColor": "#8f8f8f",
                                "cursorColor": "#ddd5e9",
                                "cursorWidth": 5,
                                "barWidth": 5,
                                "barGap": 2,
                                "barRadius": 30,
                                "barHeight": 0.5,
                                "barAlign": "",
                                "minPxPerSec": 1,
                                "fillParent": true,
                                url: file,
                            })

                            wavesurfer.on('interaction', () => {
                                wavesurfer.play()
                            })

                            // Play/pause button
                            const button = document.getElementById('<%# String.Format("divPlayPause_{0}", Eval("Name")) %>')
                            wavesurfer.once('ready', () => {
                                button.onclick = () => {
                                    wavesurfer.playPause()
                                }
                            })
                            wavesurfer.on('play', () => {
                                button.textContent = 'Pause'
                            })
                            wavesurfer.on('pause', () => {
                                button.textContent = 'Play'
                            })
                        </script>

                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <script>
            // All wavesurfer options in one place: https://wavesurfer-js.org/examples/#all-options.js 
            import WaveSurfer from 'https://unpkg.com/wavesurfer.js@7/dist/wavesurfer.esm.js'

            const audio = new Audio()
            audio.controls = true
            audio.style.width = '100%'
            document.body.appendChild(audio)

            const options = {
                /** HTML element or CSS selector (required) */
                container: 'body',
                /** The height of the waveform in pixels */
                height: 128,
                /** Render each audio channel as a separate waveform */
                splitChannels: false,
                /** Stretch the waveform to the full height */
                normalize: false,
                /** The color of the waveform */
                waveColor: '#ff4e00',
                /** The color of the progress mask */
                progressColor: '#dd5e98',
                /** The color of the playpack cursor */
                cursorColor: '#ddd5e9',
                /** The cursor width */
                cursorWidth: 2,
                /** Render the waveform with bars like this: ▁ ▂ ▇ ▃ ▅ ▂ */
                barWidth: NaN,
                /** Spacing between bars in pixels */
                barGap: NaN,
                /** Rounded borders for bars */
                barRadius: NaN,
                /** A vertical scaling factor for the waveform */
                barHeight: NaN,
                /** Vertical bar alignment **/
                barAlign: '',
                /** Minimum pixels per second of audio (i.e. zoom level) */
                minPxPerSec: 1,
                /** Stretch the waveform to fill the container, true by default */
                fillParent: true,
                /** Audio URL */
                //url: file,*/
                /** Pre-computed audio data */
                peaks: undefined,
                /** Pre-computed duration */
                duration: undefined,
                /** Use an existing media element instead of creating one */
                media: audio,
                /** Play the audio on load */
                autoplay: false,
                /** Pass false to disable clicks on the waveform */
                interact: true,
                /** Hide the scrollbar */
                hideScrollbar: false,
                /** Audio rate */
                audioRate: 1,
                /** Automatically scroll the container to keep the current position in viewport */
                autoScroll: true,
                /** If autoScroll is enabled, keep the cursor in the center of the waveform during playback */
                autoCenter: true,
                /** Decoding sample rate. Doesn't affect the playback. Defaults to 8000 */
                sampleRate: 8000,
            }

            const wavesurfer = WaveSurfer.create(options)

            wavesurfer.on('ready', () => {
                wavesurfer.setTime(10)
            })

            // Generate a form input for each option
            const schema = {
                height: {
                    value: 128,
                    min: 10,
                    max: 512,
                    step: 1,
                },
                cursorWidth: {
                    value: 1,
                    min: 0,
                    max: 10,
                    step: 1,
                },
                minPxPerSec: {
                    value: 1,
                    min: 1,
                    max: 1000,
                    step: 1,
                },
                barWidth: {
                    value: 0,
                    min: 1,
                    max: 30,
                    step: 1,
                },
                barHeight: {
                    value: 1,
                    min: 0.1,
                    max: 4,
                    step: 0.1,
                },
                barGap: {
                    value: 0,
                    min: 1,
                    max: 30,
                    step: 1,
                },
                barRadius: {
                    value: 0,
                    min: 1,
                    max: 30,
                    step: 1,
                },
                peaks: {
                    type: 'json',
                },
                audioRate: {
                    value: 1,
                    min: 0.1,
                    max: 4,
                    step: 0.1,
                },
                sampleRate: {
                    value: 8000,
                    min: 8000,
                    max: 48000,
                    step: 1000,
                },
            }

            const form = document.createElement('form')
            Object.assign(form.style, {
                display: 'flex',
                flexDirection: 'column',
                gap: '1rem',
                padding: '1rem',
            })
            document.body.appendChild(form)

            for (const key in options) {
                if (options[key] === undefined) continue
                const isColor = key.includes('Color')

                const label = document.createElement('label')
                Object.assign(label.style, {
                    display: 'flex',
                    alignItems: 'center',
                })

                const span = document.createElement('span')
                Object.assign(span.style, {
                    textTransform: 'capitalize',
                    width: '7em',
                })
                span.textContent = `${key.replace(/[a-z0-9](?=[A-Z])/g, '$& ')}: `
                label.appendChild(span)

                const input = document.createElement('input')
                const type = typeof options[key]
                Object.assign(input, {
                    type: isColor ? 'color' : type === 'number' ? 'range' : type === 'boolean' ? 'checkbox' : 'text',
                    name: key,
                    value: options[key],
                    checked: options[key] === true,
                })
                if (input.type === 'text') input.style.flex = 1
                if (options[key] instanceof HTMLElement) input.disabled = true

                if (schema[key]) {
                    Object.assign(input, schema[key])
                }

                label.appendChild(input)
                form.appendChild(label)

                input.oninput = () => {
                    if (type === 'number') {
                        options[key] = input.valueAsNumber
                    } else if (type === 'boolean') {
                        options[key] = input.checked
                    } else if (schema[key] && schema[key].type === 'json') {
                        options[key] = JSON.parse(input.value)
                    } else {
                        options[key] = input.value
                    }
                    wavesurfer.setOptions(options)
                    textarea.value = JSON.stringify(options, null, 2)
                }
            }

            const textarea = document.createElement('textarea')
            Object.assign(textarea.style, {
                width: '100%',
                height: Object.keys(options).length + 1 + 'rem',
            })
            textarea.value = JSON.stringify(options, null, 2)
            textarea.readOnly = true
            form.appendChild(textarea)

        </script>

        <script type="text/javascript">
            class VoiceRecorder {
                constructor() {
                    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                        console.log("getUserMedia supported")
                    } else {
                        console.log("getUserMedia is not supported on your browser!")
                    }
                    this.mediaRecorder
                    this.stream
                    this.chunks = []
                    this.isRecording = false
                    this.recorderRef = document.querySelector("#recorder")
                    this.startRef = document.querySelector("#start")
                    this.stopRef = document.querySelector("#stop")
                    this.startRef.onclick = this.startRecording.bind(this)
                    this.stopRef.onclick = this.stopRecording.bind(this)
                    this.constraints = {
                        audio: true,
                        video: false
                    }

                }

                handleSuccess(stream) {
                    this.stream = stream
                    this.stream.oninactive = () => {
                        console.log("Stream ended!")
                    };
                    this.recorderRef.srcObject = this.stream
                    this.mediaRecorder = new MediaRecorder(this.stream)
                    console.log(this.mediaRecorder)

                    this.mediaRecorder.ondataavailable = this.onMediaRecorderDataAvailable.bind(this)

                    this.mediaRecorder.onstop = this.onMediaRecorderStop.bind(this)
                    this.recorderRef.play()
                    this.mediaRecorder.start()

                }

                handleError(error) {
                    console.log("navigator.getUserMedia error: ", error)
                }

                onMediaRecorderDataAvailable(e) {
                    this.chunks.push(e.data)
                    //object blob : e.data
                    fun(e.data)

                }

                onMediaRecorderStop(e) {
                    const blob = new Blob(this.chunks, { 'type': 'audio/ogg; codecs=opus' })
                    const audioURL = window.URL.createObjectURL(blob)
                    this.chunks = []
                    this.stream.getAudioTracks().forEach(track => track.stop())
                    this.stream = null
                    StatusRec('OK')
                }

                startRecording() {
                    if (this.isRecording) return
                    this.isRecording = true
                    this.startRef.innerHTML = 'Recording...'
                    navigator.mediaDevices
                        .getUserMedia(this.constraints)
                        .then(this.handleSuccess.bind(this))
                        .catch(this.handleError.bind(this))
                    StatusRec()
                }

                stopRecording() {
                    if (!this.isRecording) return
                    this.isRecording = false
                    this.startRef.innerHTML = 'Record'
                    this.recorderRef.pause()
                    this.mediaRecorder.stop()
                }
            }

            window.voiceRecorder = new VoiceRecorder();
        </script>

        <script>
            function fun(b) {

                var form = new FormData();
                form.append("data1", b);
                var xhttp = new XMLHttpRequest();

                xhttp.onreadystatechange = (e) => {
                    if (xhttp.readyState !== 4) {
                        return;
                    }
                    if (xhttp.status === 200) {
                        alert('Your voice was uploaded successfully!');
                        location.reload();
                    } else {
                        alert('Something went worng!');
                    }
                };

                xhttp.open("POST", "WebService1.asmx/RecordVoice", true);
                xhttp.send(form);
            }
            function StatusRec() {

                var start = document.getElementById("start");
                var stop = document.getElementById("stop");

                if (start.style.display === "none") {
                    start.style.display = "block";
                } else {
                    start.style.display = "none";
                    startTime();
                }
                if (stop.style.display === "none") {
                    stop.style.display = "block";
                } else {
                    stop.style.display = "none";
                    stopTime();
                }

            }

            var count;
            var second = 0;

            function startTime() {
                var second = 0;
                function upTimer(count) { return count > 9 ? count : "0" + count; }
                count = setInterval(function () {
                    $("#seconds").html(':' + upTimer(++second % 60));
                    $("#minutes").html(upTimer(parseInt(second / 30, 10)));
                }, 1000);
            }
            function stopTime() {
                clearInterval(count);
            }
        </script>


    </form>
</body>
</html>
