
```html
<h2> 
  LibraFranca
</h2>
<h3> How it works </h3>
<div class = "container mt-3">
  
  <p> This application aims to aid language learning by turning subtitle files into a learning plan!  </p>
  
  <p> It works by taking an uploaded text file, parsing it, and sending a request to an internal translation API<p>

    <p> The app then displays translations records in several formats</p>
  </div>
<h4> Translation Mode </h4>
<div class= "container mt-4" >
  <p>
    In this mode the user sees a translation. They can "flip" it to see the translation in their base language. They can also play the translation with the press of the "Play Translation" button which makes a call to OpenAi's text-to-speech API.
    </p>
</div>

<h4> Multiple Choice Mode </h4>
<div class= "container mt-4" >
  <p>
    In multiple choice mode the user is given a translation in their target language and they are tasked with selecting the correct translation in their base language from the dropdown list
    </p>
</div>
<h4> Text-to-speech </h4>
<div class= "container mt-4" >
  <p>
    This function works by making a call to OpenAi's tts API and handling the response with jquery. This is a very neat feature, and everyone should make sure to check it out!
    </p>
</div>
```
