<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<!DOCTYPE html>
<html lang="en">
<head>

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
  "container": "body",
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
  "url": "/wavesurfer-code/examples/audio/audio.wav",
  "media": {},
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
        <asp:Button ID="Button1" runat="server" Text="Button" />
    </form>
    <div class="container">
        <h1>VOICE RECORDING DEMO FTW, BRO</h1>
        <span>Recorder</span>
        <audio id="recorder" muted hidden></audio>
        <div>
            <button id="start">Record</button>
            <button id="stop">Stop Recording</button>
        </div>
        <span>Saved Recording</span>
        <audio id="player" controls></audio>

       

    </div>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>

<div id="waveform"></div>

<!-- https://wavesurfer-js.org/examples/#all-options.js -->
<script type="module">
    import WaveSurfer from 'https://unpkg.com/wavesurfer.js@7/dist/wavesurfer.esm.js'

    const wavesurfer = WaveSurfer.create({
        container: '#waveform',
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
        url: '/myFile.mp3',
    })

    wavesurfer.on('interaction', () => {
        wavesurfer.play()
    })
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
                this.playerRef = document.querySelector("#player")
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
                //object blob : blob

                const audioURL = window.URL.createObjectURL(blob)
                this.playerRef.src = audioURL
                this.chunks = []
                this.stream.getAudioTracks().forEach(track => track.stop())
                // media streamtrack: this.stream.getAudioTracks()
                // object mediastream: this.stream.

                this.stream = null
            }

            startRecording() {
                if (this.isRecording) return
                this.isRecording = true
                this.startRef.innerHTML = 'Recording...'
                this.playerRef.src = ''
                navigator.mediaDevices
                    .getUserMedia(this.constraints)
                    .then(this.handleSuccess.bind(this))
                    .catch(this.handleError.bind(this))
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
            alert(b);
            //var form = new FormData();
            //form.append("data", "Robert");
            //var xhrForm = new XMLHttpRequest();
            //xhrForm.open("POST", "WebService1.asmx/HelloWorld");
            //xhrForm.send(form);

            var form = new FormData();
            form.append("data1", b);

            var xhttp = new XMLHttpRequest();
            xhttp.open("POST", "WebService1.asmx/HelloWorld", true);
            //xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhttp.send(form);

            //$.post('ajax_info.txt', function (responseText) {
            //    alert(responseText);
            //});

            // Run webservice and pass some parametere
            ///////////////////////////////////// [1] ///////////////////////////////////
            //var Data = {
            //    'data': b.files[0]
            //};

            //$.ajax({
            //    type: "POST",
            //    url: "WebService1.asmx/HelloWorld",
            //    contentType: "s",
            //    datatype: "json",
            //    data: Data,
            //    success: function () {
            //        alert("z");
            //    },
            //    error: function (xhr, w, e) {
            //        alert(xhr.responseText);
            //    }
            //});
            ///////////////////////////////////// [2] ///////////////////////////////////
            //var xhttp = new XMLHttpRequest();
            //xhttp.open("POST", "WebService1.asmx/HelloWorld", true);
            //xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            //xhttp.send("data=Henry"); //for several parameter: data=Henry&data2=Henry2
            //////////////////////////////////////////////////////////////////////////////
        }
    </script>

    <%--  <script type="text/javascript">  
         $(document).ready(function () {

             var Data = {
                 'name': 'luck'
             };

             $.ajax({
                 type: "POST",
                 url: "WebService1.asmx/HelloWorld",
                 contentType: "application/x-www-form-urlencoded",
                 datatype: "json",
                 data: Data,
                 success: function () {
                     alert("z");
                 },
                 error: function (xhr, w, e) {
                     alert(xhr.responseText);
                 }
             });
         });  
</script> --%>

    <script>
        // All wavesurfer options in one place

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
            url: 'myFile.mp3',
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
</body>
</html>
