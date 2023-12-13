<h2> 
  LibraFranca
</h2>
  <p> This application aims to aid language learning by turning subtitle files into a learning plan!  </p>
<h3> How it works </h3>
<div class = "container mt-3">
  
  
  <p> It works by taking an uploaded text file, parsing it, and sending a request to an internal translation API</p>
  
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

<h3> Technical Details </h3>

<p>  A user uploads a file and  a call is made to the perform function in the app/jobs/parse_file_to_database.rb file. that function parses the file line by line and makes requests to the translation service </p>

<p> Upon success the translation service responds with the translation in the requested language. This translation, along with the original line is committed to a new Translation model record</p>


 <p> After some time there can be an intermittent PG::BAD_CONNECTION error, so there is retry logic in place in the perform function to make the job picks up where it left off in the event of this error. </p>

These records can be viewed in the translation mode, multiple choice mode and "need to review" views. 

<h4> View Locations </h4>

<ul>

<li> app/views/homepage/: the views for the instructions and landing pages </li>

<li> app/views/learning_paths/: views related to the main view </li>

<li>app/views/translations/: views related to individual translations </li>
<li> app/views/flashcards/: Views related to the multiple choice mode and translation mode </li>
  
</ul>

<h4> Controllers </h4>
<p> Logic related to what is displayed can generally be found in the controllers section </p>

<p> The tts controller contains a function responsible for making requests to Openai and sending the received binary file to the view where the file is assigned to a (jquery) blob and played immediately </p>

<h3>
<p> Aside from that the app structure generally follows a typical rails application <p>
</h3>
