AMPLITUDE_MOD = 1

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
    for index = 1, newData:getSampleCount() - 1, 1 do
      table.insert(lastSecondData, newData:getSample(index))
    end

    --Remove older data if the table size exceeds 1 second of data
    while #lastSecondData > microphone:getSampleCount() do
      table.remove(lastSecondData, 1)
    end

    -- Process the last second of data
    Amplitude = CalculateAmplitude(lastSecondData)
  end
  return Amplitude
end

-- Function to calculate amplitude (simplified example)
function CalculateAmplitude(data)
  local sum = 0
  local count = 0
  local avgAmplitude = 1

  if #data < 10 then
    return avgAmplitude
  end

  local new_data = High_pass_filter(data, 60)

  -- Iterate through the audio data
  for i = 1, #new_data do
    --print("Data: "..tostring(new_data[i]))
    if math.abs(new_data[i]) > 0.08 then
      sum = sum + math.abs(new_data[i])
      count = count + 1
    end
  end

  -- Calculate average amplitude
  if count > 6 then
    avgAmplitude = 1 + AMPLITUDE_MOD * sum / count
  end

  return avgAmplitude
end

-- Define the high-pass filter function
function High_pass_filter(signal, cutoff_freq)
  local alpha = 1 - math.exp(-2 * math.pi * cutoff_freq / #signal)
  local y = {}
  local y_prev = 0

  y[1] = alpha * signal[1]

  for i = 2, #signal do
    y[i] = alpha * (y_prev + signal[i] - signal[i - 1])
    y_prev = y[i]
  end

  return y
end
