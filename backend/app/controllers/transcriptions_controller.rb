class TranscriptionsController < ApplicationController
  require 'openai'

  def create
    file = params[:audioFile]

    transcribed_text = transcribe_audio(file)
    corrected_text = correct_grammar(transcribed_text)
    render json: { original_text: transcribed_text, corrected_text: corrected_text }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def transcribe_audio(file)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    # ファイルを開く
    File.open(file.path, 'rb') do |audio_file|
      response = client.audio.transcribe(
        parameters: {
          model: 'whisper-1',
          file: audio_file
        }
      )
      return response['text']
    end
  end

  def correct_grammar(text)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [
          { role: 'system', content: "You are a helpful assistant." },
          { role: 'user', content: "文法を正してなぜそのように正したのか文法の説明もして:\n\n#{text}" }
        ]
      }
    )
    response.dig('choices', 0, 'message', 'content').strip
  end
end