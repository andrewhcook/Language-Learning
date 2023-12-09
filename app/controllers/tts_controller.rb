class TtsController < ApplicationController
  # this might be over the top considering this endpoint would be very difficult to target, but this at least forces the user to sign in before abusing text-to-speech programmatically
  before_action :set_user, :tts_api_call
  before_action :ensure_user_is_authorized, :tts_api_call
  require 'openai'

  def tts_api_call
    text = params.fetch('text')
    openai_api_key = ENV['chat_gpt_key']
    openai = OpenAI::Client.new(access_token: openai_api_key)
    tts_voice = %w[alloy echo fable onyx nova shimmer].sample
    audio_response = openai.audio.speech(parameters: { model: 'tts-1', voice: tts_voice, input: text })

    # Send the binary audio data in the response
    send_data audio_response, type: 'audio/mp3', disposition: 'inline'
  end

  def set_user
    @user = current_user
  end

  def ensure_user_is_authorized
    return if TtsPolicy.new(@user).trigger?

    redirect_back fallback_location: '/learning_paths'
  end
end
