function Initialize_audio_input()
    local devices = love.audio.getRecordingDevices()
    local microphone = devices[1]
    local success = microphone:start(4000, 44100, 16, 1)
    print("Recording on" .. microphone:getName() .. " " .. tostring(success))
    local lastSecondData = {}
    return microphone, lastSecondData
end

-- microphone is RecordingDevice object
function Process_audio(microphone, lastSecondData)
    if microphone:isRecording() then
        -- Get the new audio data
        local newData = microphone:getData()

        -- Append new data to the lastSecondData table
        for index = 1, newData:getSampleCount() - 1 , 1 do
            table.insert(lastSecondData, newData:getSample(index))
        end

        --Remove older data if the table size exceeds 1 second of data
        while #lastSecondData > microphone:getSampleRate() do
            table.remove(lastSecondData, 1)
        end

        -- Process the last second of data
        local amplitude = CalculateAmplitude(lastSecondData)
        print("Amplitude:", amplitude)
      end
  end

-- Function to calculate amplitude (simplified example)
function CalculateAmplitude(data)
  local sum = 0

  -- Iterate through the audio data
  for i = 1, #data do
    --print("Data: "..data[i])
    sum = sum + math.abs(data[i])
  end

  -- Calculate average amplitude
  local avgAmplitude = sum * sum / #data

  return avgAmplitude
end
