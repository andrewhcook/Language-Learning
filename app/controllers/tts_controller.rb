class TtsController < ApplicationController
  require 'openai'

  def tts_api_call
    text = params.fetch("text")
    openai_api_key = ENV['chat_gpt_key']
    openai = OpenAI::Client.new(access_token: openai_api_key)
    tts_voice = ["alloy", "echo", "fable", "onyx", "nova", "shimmer"].sample
    audio_response = openai.audio.speech(parameters: { model: "tts-1", voice: tts_voice, input: text })

    # Send the binary audio data in the response
    send_data audio_response, type: 'audio/mp3', disposition: 'inline'
  end
end
