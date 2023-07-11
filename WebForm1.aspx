<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<!DOCTYPE html>
<html lang="en">
  <head>

      <style>
          .container {
	display: flex;
	flex-direction: column;
	
	> * {
		margin: 8px;
	}
}

button {
	max-width: 300px;
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
  </body>
</html>
